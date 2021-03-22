import 'package:flutter/material.dart';

class BlueHeader1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomBlueHeader(),
    );
  }
}

class CustomBlueHeader extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    Paint pen = Paint()
      ..color = Color(0xFF3397FF)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
    Path path = Path();
    path.lineTo(0, height * 0.108);
    path.quadraticBezierTo(
      22,
      height * 0.25,
      width * 0.4,
      height * 0.2,
    );
    path.quadraticBezierTo(
      width * 0.7,
      height * 0.15,
      width * 0.9,
      height * 0.35,
    );
    path.quadraticBezierTo(
      width * 0.96,
      height * 0.4,
      width,
      height * 0.4,
    );
    path.lineTo(width, 0);
    canvas.drawPath(path, pen);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
