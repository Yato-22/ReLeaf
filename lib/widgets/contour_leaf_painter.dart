import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ContourLeafWidget extends StatelessWidget {
  final double width;
  final double height;

  const ContourLeafWidget({super.key, this.width = 280, this.height = 190});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          CustomPaint(
            size: Size(width, height),
            painter: const ContourLeafPainter(),
          ),
          Positioned(
            bottom: 4,
            right: 8,
            child: Text(
              'INDEX: 0.842 NDVI',
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.06 * 11,
                color: AppColors.primaryFixedDim.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContourLeafPainter extends CustomPainter {
  const ContourLeafPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 320.0;
    final scaleY = size.height / 220.0;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    // 1. Orthogonal Grid
    final gridPaint = Paint()
      ..color = AppColors.inversePrimary.withValues(alpha: 0.2)
      ..strokeWidth = 0.75
      ..style = PaintingStyle.stroke;

    const hLines = [30.0, 70.0, 110.0, 150.0, 190.0];
    for (final y in hLines) {
      _drawDashedLine(
        canvas,
        const Offset(20, 0) + Offset(0, y),
        const Offset(300, 0) + Offset(0, y),
        gridPaint,
        3,
        3,
      );
    }

    const vLines = [50.0, 110.0, 160.0, 210.0, 270.0];
    for (final x in vLines) {
      _drawDashedLine(canvas, Offset(x, 10), Offset(x, 210), gridPaint, 3, 3);
    }

    // 2. Corner Reticles
    final reticlePaint = Paint()
      ..color = AppColors.inversePrimary.withValues(alpha: 0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(32, 20)
        ..lineTo(24, 20)
        ..lineTo(24, 28),
      reticlePaint,
    );
    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(288, 20)
        ..lineTo(296, 20)
        ..lineTo(296, 28),
      reticlePaint,
    );
    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(24, 192)
        ..lineTo(24, 200)
        ..lineTo(32, 200),
      reticlePaint,
    );
    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(296, 192)
        ..lineTo(296, 200)
        ..lineTo(288, 200),
      reticlePaint,
    );

    // 3. Leaf Contour Tiers
    // Outer Contour
    final outerPath = Path()
      ..moveTo(160, 25)
      ..cubicTo(225, 60, 260, 115, 240, 165)
      ..cubicTo(220, 205, 175, 200, 160, 205)
      ..cubicTo(145, 200, 100, 205, 80, 165)
      ..cubicTo(60, 115, 95, 60, 160, 25)
      ..close();

    final outerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(outerPath, outerPaint);

    // Mid Tier Contour
    final midPath = Path()
      ..moveTo(160, 48)
      ..cubicTo(208, 78, 232, 120, 216, 156)
      ..cubicTo(200, 184, 172, 182, 160, 185)
      ..cubicTo(148, 182, 120, 184, 104, 156)
      ..cubicTo(88, 120, 112, 78, 160, 48)
      ..close();

    final midPaint = Paint()
      ..color = AppColors.inversePrimary.withValues(alpha: 0.85)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(midPath, midPaint);

    // Inner Core Contour
    final innerPath = Path()
      ..moveTo(160, 72)
      ..cubicTo(190, 94, 204, 125, 192, 148)
      ..cubicTo(180, 166, 168, 165, 160, 168)
      ..cubicTo(152, 165, 140, 166, 128, 148)
      ..cubicTo(116, 125, 130, 94, 160, 72)
      ..close();

    final innerPaint = Paint()
      ..color = AppColors.inversePrimary.withValues(alpha: 0.6)
      ..strokeWidth = 0.9
      ..style = PaintingStyle.stroke;
    canvas.drawPath(innerPath, innerPaint);

    // 4. Center Axis
    final axisPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    _drawDashedLine(
      canvas,
      const Offset(160, 15),
      const Offset(160, 205),
      axisPaint,
      2,
      2,
    );

    // 5. Lateral Ribs
    final ribPaint = Paint()
      ..color = AppColors.inversePrimary.withValues(alpha: 0.7)
      ..strokeWidth = 0.9
      ..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(160, 80), const Offset(210, 65), ribPaint);
    canvas.drawLine(const Offset(160, 80), const Offset(110, 65), ribPaint);
    canvas.drawLine(const Offset(160, 110), const Offset(235, 100), ribPaint);
    canvas.drawLine(const Offset(160, 110), const Offset(85, 100), ribPaint);
    canvas.drawLine(const Offset(160, 140), const Offset(220, 140), ribPaint);
    canvas.drawLine(const Offset(160, 140), const Offset(100, 140), ribPaint);

    // 6. Telemetry Gold Nodes
    final nodePaint = Paint()
      ..color = AppColors.tertiaryContainer
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(160, 25), 2.5, nodePaint);
    canvas.drawCircle(const Offset(210, 65), 2.0, nodePaint);
    canvas.drawCircle(const Offset(110, 65), 2.0, nodePaint);
    canvas.drawCircle(const Offset(235, 100), 2.5, nodePaint);
    canvas.drawCircle(const Offset(85, 100), 2.5, nodePaint);
    canvas.drawCircle(const Offset(220, 140), 2.0, nodePaint);
    canvas.drawCircle(const Offset(100, 140), 2.0, nodePaint);
    canvas.drawCircle(const Offset(160, 168), 2.0, nodePaint);

    canvas.restore();
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Paint paint,
    double dashWidth,
    double dashSpace,
  ) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final distance = (p2 - p1).distance;
    final steps = (distance / (dashWidth + dashSpace)).floor();
    final unitX = dx / distance;
    final unitY = dy / distance;

    for (int i = 0; i < steps; i++) {
      final startDist = i * (dashWidth + dashSpace);
      final start = Offset(
        p1.dx + unitX * startDist,
        p1.dy + unitY * startDist,
      );
      final endDist = startDist + dashWidth;
      final end = Offset(p1.dx + unitX * endDist, p1.dy + unitY * endDist);
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
