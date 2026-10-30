import 'package:flutter/material.dart';

import '../theme.dart';

/// Logo Pinote: lingkaran teal dengan huruf "P" dan titik pin coral.
class PinoteLogo extends StatelessWidget {
  final double size;
  const PinoteLogo({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _LogoPainter(),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 120; // desain asli 120 x 120

    // Lingkaran latar
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      Paint()..color = AppColors.accent,
    );

    // Huruf P
    final p = Path()
      ..moveTo(42 * s, 88 * s)
      ..lineTo(42 * s, 32 * s)
      ..lineTo(66 * s, 32 * s)
      ..arcToPoint(
        Offset(66 * s, 66 * s),
        radius: Radius.circular(17 * s),
        clockwise: true,
      )
      ..lineTo(42 * s, 66 * s);

    canvas.drawPath(
      p,
      Paint()
        ..color = AppColors.text
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Titik pin di dalam lengkung P
    canvas.drawCircle(
      Offset(66 * s, 49 * s),
      4 * s,
      Paint()..color = AppColors.primary,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}