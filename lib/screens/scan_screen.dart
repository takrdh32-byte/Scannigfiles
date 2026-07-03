import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ocr_service.dart';
import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';
import 'add_edit_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _processing = false;
  File? _image;

  Future<void> _pick(ImageSource source) async {
    final xfile = await _picker.pickImage(source: source, imageQuality: 85);
    if (xfile == null) return;
    setState(() {
      _image = File(xfile.path);
      _processing = true;
    });
    try {
      final result = await OcrService.readImage(_image!);
      if (!mounted) return;
      final saved = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => AddEditScreen(
            prefillDate: result.expiryDate,
            imagePath: _image!.path,
          ),
        ),
      );
      if (saved == true && mounted) Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of('scan_medicine'))),
      body: Center(
        child: _processing
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(_image!, height: 220),
                    ),
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(color: AppTheme.black),
                  const SizedBox(height: 16),
                  Text(S.of('reading_label')),
                ],
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.medication_liquid_outlined,
                        size: 72, color: AppTheme.black),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _pick(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: Text(S.of('take_photo')),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _pick(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(S.of('gallery')),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
