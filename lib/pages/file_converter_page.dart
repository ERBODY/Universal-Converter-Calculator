import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/translations.dart';
import '../utils/conversion_mapping.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FileConverterPage extends StatefulWidget {
  final String currentLanguage;

  const FileConverterPage({Key? key, required this.currentLanguage})
      : super(key: key);

  @override
  _FileConverterPageState createState() => _FileConverterPageState();
}

class _FileConverterPageState extends State<FileConverterPage> {
  File? _selectedFile;
  String? _selectedFileName;
  String? _selectedFileExtension;
  String _targetFormat = '';
  String? _sourceFormat; // The selected source format (e.g., 'PDF')
  bool _isConverting = false;
  double _conversionProgress = 0.0;
  String? _downloadUrl;

  // Security: Load API key from environment variables
  String? get _cloudConvertToken {
    final apiKey = dotenv.env['CLOUDCONVERT_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'your_cloudconvert_api_key_here') {
      return null;
    }
    return apiKey;
  }

  // Configuration
  final int _maxFileSizeMB = int.tryParse(dotenv.env['MAX_FILE_SIZE_MB'] ?? '100') ?? 100;
  final int _timeoutMinutes = int.tryParse(dotenv.env['SUPPORTED_CONVERSION_TIMEOUT_MINUTES'] ?? '10') ?? 10;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path;
        if (filePath != null) {
          setState(() {
            _selectedFile = File(filePath);
            _selectedFileName = result.files.single.name;
            _selectedFileExtension =
                result.files.single.extension?.toUpperCase();
            _sourceFormat = _selectedFileExtension;
            _targetFormat = '';
            _downloadUrl = null;
          });
        } else {
          _showErrorDialog('File path is null. Please select a valid file.');
        }
      }
    } catch (e) {
      _showErrorDialog('Error picking file: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(Translations.getTranslation(widget.currentLanguage, 'error')),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text(Translations.getTranslation(widget.currentLanguage, 'ok')),
          ),
        ],
      ),
    );
  }

  Future<void> _convertFile() async {
    if (_selectedFile == null || _targetFormat.isEmpty) {
      _showErrorDialog('Please select a file and target format');
      return;
    }
    if (_sourceFormat == null ||
        !isValidConversion(_sourceFormat!, _targetFormat)) {
      _showErrorDialog('Invalid or unsupported conversion!');
      return;
    }

    setState(() {
      _isConverting = true;
      _conversionProgress = 0.0;
      _downloadUrl = null;
    });

    try {
      // Step 1: Create Job
      final jobRes = await http.post(
        Uri.parse("https://api.cloudconvert.com/v2/jobs"),
        headers: {
          'Authorization': 'Bearer $_cloudConvertToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "tasks": {
            "import-my-file": {"operation": "import/upload"},
            "convert-my-file": {
              "operation": "convert",
              "input": "import-my-file",
              "output_format": _targetFormat.toLowerCase()
            },
            "export-my-file": {
              "operation": "export/url",
              "input": "convert-my-file"
            }
          }
        }),
      );

      if (jobRes.statusCode != 201) {
        throw Exception('Failed to create CloudConvert job');
      }

      final jobData = jsonDecode(jobRes.body);
      final jobId = jobData['data']['id'];
      final uploadTask = jobData['data']['tasks']
          .firstWhere((t) => t['name'] == 'import-my-file');
      final uploadUrl = uploadTask['result']['form']['url'];
      final uploadParams = uploadTask['result']['form']['parameters'];

      // Step 2: Upload File to S3
      final uploadRequest = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // Add all form parameters
      (uploadParams as Map<String, dynamic>).forEach((key, value) {
        uploadRequest.fields[key] = value.toString();
      });

      // Add file to upload
      uploadRequest.files
          .add(await http.MultipartFile.fromPath('file', _selectedFile!.path));

      // Track upload progress
      final uploadStream = await uploadRequest.send();
      int totalBytes = 0;
      final contentLength = uploadStream.contentLength ?? 0;

      uploadStream.stream.listen((List<int> chunk) {
        totalBytes += chunk.length;
        if (contentLength > 0) {
          setState(() {
            _conversionProgress = totalBytes / contentLength;
          });
        } else {
          setState(() {
            _conversionProgress = 0.5;
          });
        }
      });

      await uploadStream.stream.toBytes();
      if (uploadStream.statusCode != 204) {
        throw Exception('File upload failed');
      }

      // Step 3: Wait for job completion
      bool jobDone = false;
      while (!jobDone && _isConverting) {
        await Future.delayed(const Duration(seconds: 2));
        final checkRes = await http.get(
          Uri.parse("https://api.cloudconvert.com/v2/jobs/$jobId"),
          headers: {'Authorization': 'Bearer $_cloudConvertToken'},
        );

        if (checkRes.statusCode != 200) {
          throw Exception('Failed to check job status');
        }

        final checkData = jsonDecode(checkRes.body);
        final status = checkData['data']['status'];

        if (status == 'finished') {
          jobDone = true;
          final exportTask = checkData['data']['tasks']
              .firstWhere((t) => t['name'] == 'export-my-file');
          final fileUrl = exportTask['result']['files'][0]['url'];
          setState(() {
            _downloadUrl = fileUrl;
            _isConverting = false;
            _conversionProgress = 1.0;
          });
        } else if (status == 'error') {
          throw Exception('Conversion failed');
        } else if (status == 'processing') {
          setState(() {
            _conversionProgress = 0.5 + (_conversionProgress * 0.5);
          });
        }
      }
    } catch (e) {
      setState(() {
        _isConverting = false;
        _conversionProgress = 0.0;
      });
      _showErrorDialog('Error during conversion: $e');
    }
  }

  void _clearAll() {
    setState(() {
      _selectedFile = null;
      _selectedFileName = null;
      _selectedFileExtension = null;
      _targetFormat = '';
      _isConverting = false;
      _conversionProgress = 0.0;
      _downloadUrl = null;
    });
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.blueGrey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(':  '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.getTranslation(widget.currentLanguage, 'file_converter'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearAll,
            tooltip: 'Clear',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File Selection Card
            Card(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50,
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Select File',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickFile,
                      child: _selectedFile == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.cloud_upload,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to select file',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.description,
                                  size: 48,
                                  color: Colors.blue,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _selectedFileName ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${(_selectedFile!.lengthSync() / 1024).toStringAsFixed(2)} KB',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Source Format (auto-detected, not editable)
            if (_selectedFile != null && _selectedFileExtension != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    const Text('Source Format: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(_selectedFileExtension ?? '',
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            // Target Format Dropdown (all valid for detected source)
            if (_sourceFormat != null &&
                getValidTargetFormats(_sourceFormat!).isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Target Format',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _targetFormat.isNotEmpty &&
                              getValidTargetFormats(_sourceFormat!)
                                  .contains(_targetFormat)
                          ? _targetFormat
                          : null,
                      hint: const Text('Select target format'),
                      items: getValidTargetFormats(_sourceFormat!)
                          .map<DropdownMenuItem<String>>((format) {
                        return DropdownMenuItem<String>(
                          value: format,
                          child: Text(format),
                        );
                      }).toList(),
                      onChanged: (_selectedFile != null &&
                              _sourceFormat != null &&
                              getValidTargetFormats(_sourceFormat!).isNotEmpty)
                          ? (val) {
                              setState(() {
                                _targetFormat = val ?? '';
                              });
                            }
                          : null,
                      isExpanded: true,
                    ),
                  ),
                ),
              ),
            // Summary Section
            if (_selectedFile != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.blue.shade100,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.blue.shade700, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'File Summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow('Name', _selectedFileName ?? ''),
                    const Divider(
                        height: 16, thickness: 0.5, color: Colors.blueGrey),
                    _buildSummaryRow('Size',
                        '${(_selectedFile!.lengthSync() / 1024).toStringAsFixed(2)} KB'),
                    const Divider(
                        height: 16, thickness: 0.5, color: Colors.blueGrey),
                    _buildSummaryRow('Type', _selectedFileExtension ?? ''),
                    if (_targetFormat.isNotEmpty) ...[
                      const Divider(
                          height: 16, thickness: 0.5, color: Colors.blueGrey),
                      _buildSummaryRow('Convert To', _targetFormat),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 16),
            // Convert Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: _isConverting
                    ? const Icon(Icons.transform)
                    : const Icon(Icons.transform),
                label: _isConverting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              value: _conversionProgress,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                              'Converting... ${(100 * _conversionProgress).toInt()}%'),
                        ],
                      )
                    : Text('Convert File',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: (_selectedFile != null &&
                        _targetFormat.isNotEmpty &&
                        !_isConverting)
                    ? _convertFile
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Download section and summary after conversion
            if (_downloadUrl != null) ...[
              const SizedBox(height: 20),
              Card(
                color: Colors.grey[100],
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("✅ Conversion Summary:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text("Original: " + (_selectedFileName ?? '')),
                      Text("Converted to: $_targetFormat"),
                      Text("Estimated size: " +
                          ((_selectedFile != null &&
                                  _selectedFile!.existsSync())
                              ? (_selectedFile!.lengthSync() ~/ 1024).toString()
                              : '-') +
                          " KB"),
                      SizedBox(height: 8),
                      Text("Download Link:"),
                      SelectableText(_downloadUrl!),
                      SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: Icon(Icons.download),
                        label: Text("Download Now"),
                        onPressed: () async {
                          final url = Uri.parse(_downloadUrl!);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
