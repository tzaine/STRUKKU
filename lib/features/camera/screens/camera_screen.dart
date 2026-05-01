// lib/features/camera/screens/camera_screen.dart  [SCREEN 03]
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:strukku/core/theme/app_colors.dart';
import 'package:strukku/core/theme/app_typography.dart';
import 'package:strukku/features/camera/widgets/scan_overlay.dart';
import 'package:strukku/features/camera/widgets/scan_line_animation.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCapturing = false;
  bool _isFlashOn = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) return;

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      _controller = CameraController(
        _cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      if (mounted) setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      setState(() => _isInitialized = false);
      _controller!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    if (_isCapturing || _controller == null) return;
    setState(() => _isCapturing = true);
    HapticFeedback.lightImpact();

    try {
      final XFile photo = await _controller!.takePicture();
      if (mounted) {
        context.go('/camera/preview', extra: File(photo.path));
      }
    } catch (e) {
      debugPrint('Capture error: $e');
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (image != null && mounted) {
      context.go('/camera/preview', extra: File(image.path));
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;
    setState(() => _isFlashOn = !_isFlashOn);
    await _controller!.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ─── Camera preview ───────────────────────────────────────────────
          if (_isInitialized && _controller != null)
            CameraPreview(_controller!)
          else
            const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            ),

          // ─── Scan overlay ─────────────────────────────────────────────────
          const ScanOverlay(),

          // ─── Scan line ────────────────────────────────────────────────────
          if (_isInitialized)
            const Center(
              child: SizedBox(
                width: 280,
                height: 380,
                child: ScanLineAnimation(width: 280),
              ),
            ),

          // ─── Top bar ──────────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _IconButton(
                    icon: Icons.close_rounded,
                    onTap: () => context.pop(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Scan Struk',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),

          // ─── Guide text ───────────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * 0.5 + 210,
            child: const Center(
              child: Text(
                'Posisikan struk dalam bingkai',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontSize: 13,
                  backgroundColor: Colors.black38,
                ),
              ),
            ),
          ),

          // ─── Bottom controls ──────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(48, 24, 48, 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Gallery
                    GestureDetector(
                      onTap: _pickFromGallery,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _IconButton(
                            icon: Icons.photo_library_outlined,
                            onTap: _pickFromGallery,
                          ),
                          const SizedBox(height: 6),
                          const Text('Galeri',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontFamily: 'Inter')),
                        ],
                      ),
                    ),

                    // Capture button
                    GestureDetector(
                      onTap: _capture,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: AppColors.accent,
                            width: 3,
                          ),
                        ),
                        child: _isCapturing
                            ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(AppColors.accent),
                                ),
                              )
                            : Center(
                                child: Container(
                                  width: 52,
                                  height: 52,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                      ),
                    ),

                    // Flash
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _IconButton(
                          icon: _isFlashOn
                              ? Icons.flash_on_rounded
                              : Icons.flash_off_rounded,
                          onTap: _toggleFlash,
                          active: _isFlashOn,
                        ),
                        const SizedBox(height: 6),
                        const Text('Flash',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontFamily: 'Inter')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  const _IconButton({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active
              ? AppColors.accent.withOpacity(0.3)
              : Colors.white.withOpacity(0.15),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
