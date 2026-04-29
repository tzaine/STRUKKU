// lib/core/services/ocr_service.dart
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

enum OcrConfidence { high, medium, low }

class OcrField<T> {
  final T? value;
  final OcrConfidence confidence;

  const OcrField({this.value, this.confidence = OcrConfidence.low});
}

class OcrResult {
  final OcrField<String> storeName;
  final OcrField<DateTime> date;
  final OcrField<double> total;
  final List<OcrLineItem> items;
  final String rawText;

  const OcrResult({
    required this.storeName,
    required this.date,
    required this.total,
    required this.items,
    required this.rawText,
  });
}

class OcrLineItem {
  final String name;
  final double? price;

  const OcrLineItem({required this.name, this.price});
}

class OcrService {
  final TextRecognizer _recognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  Future<OcrResult> processImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognizedText =
        await _recognizer.processImage(inputImage);

    final rawText = recognizedText.text;
    final lines = rawText.split('\n').map((l) => l.trim()).toList();

    return OcrResult(
      storeName: _extractStoreName(lines),
      date: _extractDate(lines),
      total: _extractTotal(lines),
      items: _extractItems(lines),
      rawText: rawText,
    );
  }

  // ─── Store name: first non-empty line, usually bold/header ────────────────
  OcrField<String> _extractStoreName(List<String> lines) {
    final candidates =
        lines.where((l) => l.length > 2 && l.length < 60).toList();
    if (candidates.isEmpty) {
      return const OcrField(confidence: OcrConfidence.low);
    }
    // Score confidence by whether it looks like a store name (no numbers)
    final first = candidates.first;
    final hasNumbers = RegExp(r'\d').hasMatch(first);
    final confidence =
        hasNumbers ? OcrConfidence.medium : OcrConfidence.high;
    return OcrField(value: first, confidence: confidence);
  }

  // ─── Date extraction ──────────────────────────────────────────────────────
  OcrField<DateTime> _extractDate(List<String> lines) {
    // Patterns: dd/mm/yyyy, dd-mm-yyyy, dd MMM yyyy
    final patterns = [
      RegExp(r'(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})'),
      RegExp(r'(\d{1,2})\s+(Jan|Feb|Mar|Apr|Mei|Jun|Jul|Agu|Sep|Okt|Nov|Des)\s+(\d{4})',
          caseSensitive: false),
    ];

    for (final line in lines) {
      for (int i = 0; i < patterns.length; i++) {
        final match = patterns[i].firstMatch(line);
        if (match != null) {
          try {
            DateTime? date;
            if (i == 0) {
              final day = int.parse(match.group(1)!);
              final month = int.parse(match.group(2)!);
              final year = int.parse(match.group(3)!);
              date = DateTime(year, month, day);
            } else {
              // Month name pattern
              final monthMap = {
                'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'mei': 5,
                'jun': 6, 'jul': 7, 'agu': 8, 'sep': 9, 'okt': 10,
                'nov': 11, 'des': 12,
              };
              final day = int.parse(match.group(1)!);
              final month =
                  monthMap[match.group(2)!.toLowerCase()] ?? 1;
              final year = int.parse(match.group(3)!);
              date = DateTime(year, month, day);
            }
            return OcrField(value: date, confidence: OcrConfidence.high);
                    } catch (_) {}
        }
      }
    }
    return OcrField(value: DateTime.now(), confidence: OcrConfidence.low);
  }

  // ─── Total extraction ─────────────────────────────────────────────────────
  OcrField<double> _extractTotal(List<String> lines) {
    // Look for "Total", "TOTAL", "Grand Total", "Jumlah" followed by a number
    final totalKeywords =
        RegExp(r'(total|grand total|jumlah|tagihan)', caseSensitive: false);
    final pricePattern = RegExp(r'[\d\.,]{4,}');

    for (final line in lines) {
      if (totalKeywords.hasMatch(line)) {
        final priceMatch = pricePattern.firstMatch(line);
        if (priceMatch != null) {
          final cleaned = priceMatch
              .group(0)!
              .replaceAll('.', '')
              .replaceAll(',', '.');
          final value = double.tryParse(cleaned);
          if (value != null && value > 0) {
            return OcrField(value: value, confidence: OcrConfidence.high);
          }
        }
        // Check next line for price
        final idx = lines.indexOf(line);
        if (idx + 1 < lines.length) {
          final nextMatch = pricePattern.firstMatch(lines[idx + 1]);
          if (nextMatch != null) {
            final cleaned = nextMatch
                .group(0)!
                .replaceAll('.', '')
                .replaceAll(',', '.');
            final value = double.tryParse(cleaned);
            if (value != null && value > 0) {
              return OcrField(value: value, confidence: OcrConfidence.medium);
            }
          }
        }
      }
    }

    // Fallback: largest price found
    double maxPrice = 0;
    for (final line in lines) {
      final match = pricePattern.firstMatch(line);
      if (match != null) {
        final cleaned =
            match.group(0)!.replaceAll('.', '').replaceAll(',', '.');
        final value = double.tryParse(cleaned) ?? 0;
        if (value > maxPrice) maxPrice = value;
      }
    }

    return OcrField(
      value: maxPrice > 0 ? maxPrice : null,
      confidence: OcrConfidence.low,
    );
  }

  // ─── Line items extraction ────────────────────────────────────────────────
  List<OcrLineItem> _extractItems(List<String> lines) {
    final items = <OcrLineItem>[];
    final pricePattern = RegExp(r'([\d\.]{4,})$');
    final skipKeywords = RegExp(
        r'(total|subtotal|ppn|pajak|cash|kembalian|bayar|tanggal|kasir|struk|no\.|receipt)',
        caseSensitive: false);

    for (final line in lines) {
      if (line.length < 3) continue;
      if (skipKeywords.hasMatch(line)) continue;

      final priceMatch = pricePattern.firstMatch(line);
      if (priceMatch != null) {
        final priceStr =
            priceMatch.group(0)!.replaceAll('.', '').replaceAll(',', '.');
        final price = double.tryParse(priceStr);
        final name =
            line.substring(0, line.length - priceMatch.group(0)!.length).trim();
        if (name.length > 1 && price != null && price > 0) {
          items.add(OcrLineItem(name: name, price: price));
        }
      }
    }

    return items;
  }

  void dispose() {
    _recognizer.close();
  }
}
