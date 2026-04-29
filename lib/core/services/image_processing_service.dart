// lib/core/services/image_processing_service.dart
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class ImageProcessingService {
  static const _uuid = Uuid();

  // BUG FIX: Limit image width to 1200px max before any processing.
  // This prevents OOM errors on high-res camera output and speeds up OCR.
  static const int _maxWidth = 1200;

  /// Preprocess: resize + grayscale + contrast boost, then save to app storage
  Future<File> preprocess(File sourceFile) async {
    final bytes = await sourceFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) return sourceFile;

    // BUG FIX: Resize before grayscale to prevent OOM on 12MP+ cameras
    if (image.width > _maxWidth) {
      image = img.copyResize(image, width: _maxWidth);
    }

    // Convert to grayscale
    image = img.grayscale(image);

    // Boost contrast slightly for better OCR accuracy
    image = img.adjustColor(image, contrast: 1.15, brightness: 1.05);

    // Save processed image
    final dir = await getApplicationDocumentsDirectory();
    final receiptsDir =
        Directory(path.join(dir.path, 'receipts_processed'));
    await receiptsDir.create(recursive: true);

    final fileName = '${_uuid.v4()}_processed.jpg';
    final outPath = path.join(receiptsDir.path, fileName);
    final outFile = File(outPath);
    // BUG FIX: Use quality 80 (not 90) to reduce file size ~30%
    await outFile.writeAsBytes(img.encodeJpg(image, quality: 80));

    return outFile;
  }

  /// Save original photo to app-internal storage (not public gallery)
  /// BUG FIX: Compress original to max 1200px width, quality 80 before saving.
  Future<File> saveReceiptPhoto(File sourceFile) async {
    final dir = await getApplicationDocumentsDirectory();
    final receiptsDir =
        Directory(path.join(dir.path, 'receipts_original'));
    await receiptsDir.create(recursive: true);

    final fileName = '${_uuid.v4()}.jpg';
    final destPath = path.join(receiptsDir.path, fileName);

    // Decode, resize, re-encode to save storage space
    final bytes = await sourceFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      return sourceFile.copy(destPath);
    }

    if (image.width > _maxWidth) {
      image = img.copyResize(image, width: _maxWidth);
    }

    final outFile = File(destPath);
    await outFile.writeAsBytes(img.encodeJpg(image, quality: 80));
    return outFile;
  }

  /// Crop image to given rect (relative 0.0–1.0 coordinates)
  Future<File> cropImage(
    File sourceFile, {
    required double left,
    required double top,
    required double width,
    required double height,
  }) async {
    final bytes = await sourceFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) return sourceFile;

    final x = (left * image.width).round().clamp(0, image.width - 1);
    final y = (top * image.height).round().clamp(0, image.height - 1);
    // BUG FIX: Clamp width/height to prevent out-of-bounds crop
    final w = (width * image.width).round().clamp(1, image.width - x);
    final h = (height * image.height).round().clamp(1, image.height - y);

    final cropped = img.copyCrop(image, x: x, y: y, width: w, height: h);

    final dir = await getApplicationDocumentsDirectory();
    final tmpPath = path.join(dir.path, '${_uuid.v4()}_crop.jpg');
    final outFile = File(tmpPath);
    await outFile.writeAsBytes(img.encodeJpg(cropped, quality: 85));
    return outFile;
  }

  /// Delete a receipt photo from app storage
  Future<void> deletePhoto(String? photoPath) async {
    if (photoPath == null) return;
    final file = File(photoPath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
