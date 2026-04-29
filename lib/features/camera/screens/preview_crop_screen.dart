// lib/features/camera/screens/preview_crop_screen.dart  [SCREEN 04]
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/image_processing_service.dart';
import '../../../core/services/ocr_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/shimmer_loader.dart';

class PreviewCropScreen extends ConsumerStatefulWidget {
  final File imageFile;

  const PreviewCropScreen({super.key, required this.imageFile});

  @override
  ConsumerState<PreviewCropScreen> createState() => _PreviewCropScreenState();
}

class _PreviewCropScreenState extends ConsumerState<PreviewCropScreen> {
  bool _isProcessing = false;

  Future<void> _processOcr() async {
    setState(() => _isProcessing = true);

    try {
      final imgSvc = ImageProcessingService();
      final ocrSvc = OcrService();

      // Save original + preprocess
      final savedOriginal =
          await imgSvc.saveReceiptPhoto(widget.imageFile);
      final processedFile = await imgSvc.preprocess(savedOriginal);

      // Run OCR
      final ocrResult = await ocrSvc.processImage(processedFile);
      ocrSvc.dispose();

      if (mounted) {
        context.go(
          '/camera/review',
          extra: {
            'photoPath': savedOriginal.path,
            'ocrResult': ocrResult,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memproses gambar: $e')),
        );
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Preview Foto'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // ─── Image preview ────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _isProcessing
                    ? Container(
                        width: double.infinity,
                        color: AppColors.surface,
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                  color: AppColors.accent),
                              SizedBox(height: 16),
                              Text('Memproses OCR...',
                                  style: AppTypography.body),
                            ],
                          ),
                        ),
                      )
                    : Image.file(
                        widget.imageFile,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
              ),
            ),
          ),

          // ─── Actions ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: Column(
              children: [
                OutlinedButton(
                  onPressed: _isProcessing ? null : () => context.go('/camera'),
                  child: const Text('Ambil Ulang'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isProcessing ? null : _processOcr,
                  child: _isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text('Proses OCR'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
