import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DocConversionPage extends StatefulWidget {
  @override
  State<DocConversionPage> createState() => _DocConversionPageState();
}

class _DocConversionPageState extends State<DocConversionPage> {
  PlatformFile? _selectedFile;
  String? _downloadUrl;
  bool _isConverting = false;
  String? _error;
  String _targetFormat = 'pdf';

  final List<String> _formats = [
    'pdf', 'jpg', 'png', 'docx', 'mp3', 'txt', // Add more as needed
  ];

  Future<void> _pickFile() async {
    setState(() {
      _selectedFile = null;
      _downloadUrl = null;
      _error = null;
    });
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = result.files.single;
      });
    }
  }

  Future<void> _convertFile() async {
    if (_selectedFile == null || _selectedFile!.path == null) return;
    setState(() {
      _isConverting = true;
      _downloadUrl = null;
      _error = null;
    });

    final file = File(_selectedFile!.path!);
    final uri = Uri.parse("https://api.docconversionapi.com/convert");
    final request = http.MultipartRequest('POST', uri)
      ..fields['target_format'] = _targetFormat
      ..headers['Application-ID'] = 'a73d5420-2be8-4744-b165-5ee36f8f9950'
      ..headers['Application-Key'] = '9bee44ab-5b9f-4dfd-a346-111f52449962'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        setState(() {
          _downloadUrl = data['download_url'];
        });
      } else {
        setState(() {
          _error = "Failed: Status {response.statusCode}\n$responseBody";
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error: $e";
      });
    } finally {
      setState(() {
        _isConverting = false;
      });
    }
  }

  Widget _buildFilePreview() {
    if (_selectedFile == null) return Text("No file selected.");
    return ListTile(
      leading: Icon(Icons.insert_drive_file),
      title: Text(_selectedFile!.name),
      subtitle: Text(
        "${(_selectedFile!.size / 1024).toStringAsFixed(2)} KB\nType: ${_selectedFile!.extension ?? 'unknown'}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("File Converter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.folder_open),
              label: Text("Pick File"),
              onPressed: _isConverting ? null : _pickFile,
            ),
            SizedBox(height: 16),
            _buildFilePreview(),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _targetFormat,
              items: _formats
                  .map((f) =>
                      DropdownMenuItem(value: f, child: Text(f.toUpperCase())))
                  .toList(),
              onChanged: _isConverting
                  ? null
                  : (val) => setState(() => _targetFormat = val!),
              decoration: InputDecoration(labelText: "Convert to format"),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              icon: _isConverting
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(Icons.swap_horiz),
              label: Text("Convert"),
              onPressed: (_selectedFile != null && !_isConverting)
                  ? _convertFile
                  : null,
            ),
            if (_downloadUrl != null) ...[
              SizedBox(height: 24),
              Text("Conversion complete!"),
              TextButton.icon(
                icon: Icon(Icons.download),
                label: Text("Download File"),
                onPressed: () => launchUrl(Uri.parse(_downloadUrl!)),
              ),
            ],
            if (_error != null) ...[
              SizedBox(height: 24),
              Text(_error!, style: TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
