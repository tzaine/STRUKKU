// lib/features/camera/widgets/scan_overlay.dart
import 'package:flutter/material.dart';
import 'package:strukku/core/theme/app_colors.dart';

class ScanOverlay extends StatelessWidget {
  final double scanAreaWidth;
  final double scanAreaHeight;

  const ScanOverlay({
    super.key,
    this.scanAreaWidth = 280,
    this.scanAreaHeight = 380,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScanOverlayPainter(
        scanWidth: scanAreaWidth,
        scanHeight: scanAreaHeight,
      ),
      child: Center(
        child: SizedBox(
          width: scanAreaWidth,
          height: scanAreaHeight,
          child: const Stack(
            children: [
              // ─── Corner brackets ──────────────────────────────────────────
              _CornerBracket(alignment: Alignment.topLeft),
              _CornerBracket(alignment: Alignment.topRight),
              _CornerBracket(alignment: Alignment.bottomLeft),
              _CornerBracket(alignment: Alignment.bottomRight),
            ],
          ),
        ),
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  final Alignment alignment;

  const _CornerBracket({required this.alignment});

  @override
  Widget build(BuildContext context) {
    final isLeft =
        alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;
    final isTop =
        alignment == Alignment.topLeft || alignment == Alignment.topRight;

    return Align(
      alignment: alignment,
      child: CustomPaint(
        size: const Size(24, 24),
        painter: _BracketPainter(isLeft: isLeft, isTop: isTop),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  final bool isLeft;
  final bool isTop;

  _BracketPainter({required this.isLeft, required this.isTop});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double x = isLeft ? 0 : size.width;
    final double y = isTop ? 0 : size.height;
    final double dx = isLeft ? size.width : -size.width;
    final double dy = isTop ? size.height : -size.height;

    canvas.drawLine(
      Offset(x, y),
      Offset(x + dx, y),
      paint,
    );
    canvas.drawLine(
      Offset(x, y),
      Offset(x, y + dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ScanOverlayPainter extends CustomPainter {
  final double scanWidth;
  final double scanHeight;

  _ScanOverlayPainter({required this.scanWidth, required this.scanHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.55);

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final left = centerX - scanWidth / 2;
    final top = centerY - scanHeight / 2;
    final right = left + scanWidth;
    final bottom = top + scanHeight;

    // Draw 4 dark rectangles around the scan area
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, top), paint);
    canvas.drawRect(Rect.fromLTRB(0, bottom, size.width, size.height), paint);
    canvas.drawRect(Rect.fromLTRB(0, top, left, bottom), paint);
    canvas.drawRect(Rect.fromLTRB(right, top, size.width, bottom), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
