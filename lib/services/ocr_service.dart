import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrResult {
  final String fullText;
  final DateTime? expiryDate;
  OcrResult({required this.fullText, this.expiryDate});
}

/// Reads label text off a medicine photo and tries to find the expiry date.
/// Handles common Indian medicine-strip formats:
///   EXP 05/2027, EXP: 05 2027, Exp Date 05/06/2027, MFG 05/25 EXP 05/27
class OcrService {
  static final TextRecognizer _recognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  static Future<OcrResult> readImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognized = await _recognizer.processImage(inputImage);
    final text = recognized.text;
    final date = _extractExpiryDate(text);
    return OcrResult(fullText: text, expiryDate: date);
  }

  static void dispose() => _recognizer.close();

  static const _months = {
    'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
    'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
  };

  static DateTime? _extractExpiryDate(String rawText) {
    final text = rawText.toLowerCase();

    // Try to isolate the segment near "exp" first (avoids picking MFG date).
    final expIndex = text.indexOf(RegExp(r'exp'));
    final searchWindow = expIndex >= 0
        ? text.substring(expIndex, (expIndex + 40).clamp(0, text.length))
        : text;

    final candidates = <DateTime>[];

    // Pattern: DD/MM/YYYY or DD-MM-YYYY
    for (final m in RegExp(r'(\d{1,2})[\/\-.](\d{1,2})[\/\-.](\d{2,4})')
        .allMatches(searchWindow)) {
      final d = int.tryParse(m.group(1)!);
      final mo = int.tryParse(m.group(2)!);
      var y = int.tryParse(m.group(3)!);
      if (d != null && mo != null && y != null && mo.in1to12) {
        if (y < 100) y += 2000;
        final dt = _tryDate(y, mo, d);
        if (dt != null) candidates.add(dt);
      }
    }

    // Pattern: MM/YYYY or MM-YY (common on strips, day = last day of month)
    if (candidates.isEmpty) {
      for (final m
          in RegExp(r'(\d{1,2})[\/\-.](\d{2,4})').allMatches(searchWindow)) {
        final mo = int.tryParse(m.group(1)!);
        var y = int.tryParse(m.group(2)!);
        if (mo != null && y != null && mo.in1to12) {
          if (y < 100) y += 2000;
          final lastDay = DateTime(y, mo + 1, 0).day;
          candidates.add(DateTime(y, mo, lastDay));
        }
      }
    }

    // Pattern: "MMM YYYY" e.g. "MAY 2027"
    if (candidates.isEmpty) {
      for (final m in RegExp(
              r'(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\s+(\d{4})')
          .allMatches(searchWindow)) {
        final mo = _months[m.group(1)!.substring(0, 3)];
        final y = int.tryParse(m.group(2)!);
        if (mo != null && y != null) {
          final lastDay = DateTime(y, mo + 1, 0).day;
          candidates.add(DateTime(y, mo, lastDay));
        }
      }
    }

    if (candidates.isEmpty) return null;
    // Prefer the latest plausible date within a sane range.
    candidates.sort();
    final now = DateTime.now();
    final plausible = candidates.where(
      (d) => d.year >= now.year - 2 && d.year <= now.year + 15,
    );
    return plausible.isNotEmpty ? plausible.last : candidates.last;
  }

  static DateTime? _tryDate(int y, int mo, int d) {
    try {
      final dt = DateTime(y, mo, d);
      if (dt.month != mo) return null; // rolled over -> invalid day
      return dt;
    } catch (_) {
      return null;
    }
  }
}

extension on int {
  bool get in1to12 => this >= 1 && this <= 12;
}
