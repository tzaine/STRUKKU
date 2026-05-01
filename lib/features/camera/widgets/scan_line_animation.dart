// lib/features/camera/widgets/scan_line_animation.dart
import 'package:flutter/material.dart';
import 'package:strukku/core/theme/app_colors.dart';

class ScanLineAnimation extends StatefulWidget {
  final double width;

  const ScanLineAnimation({super.key, required this.width});

  @override
  State<ScanLineAnimation> createState() => _ScanLineAnimationState();
}

class _ScanLineAnimationState extends State<ScanLineAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        return CustomPaint(
          size: Size(widget.width, 380),
          painter: _ScanLinePainter(progress: _anim.value),
        );
      },
    );
  }
}

class _ScanLinePainter extends CustomPainter {
  final double progress;

  _ScanLinePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final y = progress * size.height;

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.accent.withOpacity(0),
          AppColors.accent,
          AppColors.accent.withOpacity(0),
        ],
      ).createShader(Rect.fromLTWH(0, y - 20, size.width, 40));

    canvas.drawRect(Rect.fromLTWH(0, y - 1, size.width, 2), paint);
  }

  @override
  bool shouldRepaint(_ScanLinePainter old) => old.progress != progress;
}
