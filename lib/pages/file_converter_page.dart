import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/translations.dart';
import '../utils/conversion_mapping.dart';
import '../widgets/standardized_components.dart';
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

  // Validate file size before conversion
  bool _isFileSizeValid(File file) {
    final fileSizeMB = file.lengthSync() / (1024 * 1024);
    return fileSizeMB <= _maxFileSizeMB;
  }

  // Show configuration error dialog
  void _showConfigurationError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Configuration Error'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CloudConvert API key is not configured.'),
            SizedBox(height: 8),
            Text('To fix this issue:'),
            SizedBox(height: 4),
            Text('1. Copy .env.example to .env'),
            Text('2. Add your CloudConvert API key to .env'),
            Text('3. Restart the application'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
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
    // Security: Check if API key is configured
    final apiKey = _cloudConvertToken;
    if (apiKey == null) {
      _showConfigurationError();
      return;
    }

    // Validation: Check file and format selection
    if (_selectedFile == null || _targetFormat.isEmpty) {
      _showErrorDialog('Please select a file and target format');
      return;
    }
    if (_sourceFormat == null ||
        !isValidConversion(_sourceFormat!, _targetFormat)) {
      _showErrorDialog('Invalid or unsupported conversion!');
      return;
    }

    // Validation: Check file size
    if (!_isFileSizeValid(_selectedFile!)) {
      _showErrorDialog('File size exceeds $_maxFileSizeMB MB limit. Current size: ${(_selectedFile!.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB');
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
          'Authorization': 'Bearer $apiKey',
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
          headers: {'Authorization': 'Bearer $apiKey'},
        ).timeout(Duration(minutes: _timeoutMinutes));

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

      // Enhanced error handling with specific error types
      String errorMessage = 'Error during conversion: $e';
      if (e is SocketException || e.toString().contains('Network is unreachable')) {
        errorMessage = 'Network error. Please check your internet connection and try again.';
      } else if (e is TimeoutException) {
        errorMessage = 'Conversion timed out. Please try again with a smaller file or different format.';
      } else if (e.toString().contains('401') || e.toString().contains('403')) {
        errorMessage = 'Authentication error. Please check your API key configuration.';
      } else if (e.toString().contains('429')) {
        errorMessage = 'Too many requests. Please wait and try again.';
      } else if (e.toString().contains('500') || e.toString().contains('503')) {
        errorMessage = 'Service unavailable. Please try again later.';
      }

      _showErrorDialog(errorMessage);
    }
  }

  // Retry conversion functionality
  Future<void> _retryConversion() async {
    await _convertFile();
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
      appBar: StandardAppBar(
        title: Translations.getTranslation(widget.currentLanguage, 'file_converter'),
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
            _buildFileSelectionSection(),
            if (_selectedFile != null) ...[
              _buildFormatSelectionSection(),
              _buildFileSummarySection(),
              _buildConversionSection(),
            ],
            if (_downloadUrl != null) _buildDownloadSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFileSelectionSection() {
    return AppContainer(
      child: Column(
        children: [
          const Text(
            'Select File',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _pickFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.outline, width: 2, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: _selectedFile == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to select file',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
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
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (!_isFileSizeValid(_selectedFile!))
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.warning, color: Colors.red, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'File size exceeds $_maxFileSizeMB MB limit',
                                  style: TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatSelectionSection() {
    if (_sourceFormat != null && getValidTargetFormats(_sourceFormat!).isNotEmpty) {
      return Column(
        children: [
          if (_selectedFileExtension != null)
            InfoCard(
              title: 'Source Format',
              content: _selectedFileExtension!,
              icon: Icons.file_present,
            ),
          AppContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Target Format',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                StandardDropdown<String>(
                  value: _targetFormat.isNotEmpty &&
                          getValidTargetFormats(_sourceFormat!).contains(_targetFormat)
                      ? _targetFormat
                      : null,
                  labelText: 'Select target format',
                  hintText: 'Choose conversion format',
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
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildFileSummarySection() {
    if (_selectedFile != null) {
      return InfoCard(
        title: 'File Summary',
        content: '''Name: ${_selectedFileName ?? ''}
Size: ${(_selectedFile!.lengthSync() / 1024).toStringAsFixed(2)} KB
Type: ${_selectedFileExtension ?? ''}
${_targetFormat.isNotEmpty ? 'Convert to: $_targetFormat' : ''}''',
        icon: Icons.info_outline,
        iconColor: Theme.of(context).colorScheme.primary,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildConversionSection() {
    return Column(
      children: [
        const SizedBox(height: 8),
        PrimaryButton(
          text: _isConverting
              ? 'Converting... ${(100 * _conversionProgress).toInt()}%'
              : 'Convert File',
          icon: Icons.transform,
          isLoading: _isConverting,
          onPressed: (_selectedFile != null &&
                  _targetFormat.isNotEmpty &&
                  !_isConverting &&
                  _isFileSizeValid(_selectedFile!))
              ? _convertFile
              : null,
        ),
        if (_isConverting) ...[
          const SizedBox(height: 16),
          AppContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.sync, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text(
                      'Conversion Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: _conversionProgress,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(100 * _conversionProgress).toInt()}% complete',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDownloadSection() {
    return AppContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Conversion Complete!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Original: ${_selectedFileName ?? ''}',
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            'Converted to: $_targetFormat',
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            'Estimated size: ${((_selectedFile != null && _selectedFile!.existsSync()) ? (_selectedFile!.lengthSync() ~/ 1024).toString() : '-')} KB',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          Text(
            'Download Link:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: SelectableText(
              _downloadUrl!,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            text: 'Download Now',
            icon: Icons.download,
            onPressed: () async {
              final url = Uri.parse(_downloadUrl!);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
          ),
          const SizedBox(height: 8),
          SecondaryButton(
            text: 'Start New Conversion',
            icon: Icons.refresh,
            onPressed: () async {
              final confirmed = await showStandardConfirmation(
                context,
                'Clear and Start Over?',
                'This will clear the current file and results to start a new conversion.',
              );
              if (confirmed) {
                _clearAll();
              }
            },
          ),
        ],
      ),
    );
  }
}
