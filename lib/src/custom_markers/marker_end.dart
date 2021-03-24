part of "custom_markers.dart";

class MarkerEndPainter extends CustomPainter {
  final String description;
  final double metros;

  MarkerEndPainter(this.description, this.metros);
  @override
  void paint(Canvas canvas, Size size) {
    final double circleR = 20;
    final double circleR2 = 7;
    Paint paint = Paint()..color = Color(0xFF3397FF);
    //draw circle
    canvas.drawCircle(Offset(circleR, size.height - circleR), circleR, paint);
    paint.color = Colors.white;
    canvas.drawCircle(Offset(circleR, size.height - circleR), circleR2, paint);
    //draw shadow
    final path = Path();
    path.moveTo(0, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(0, 100);
    canvas.drawShadow(path, Colors.black87, 10, false);
    // Draw Box white
    final whiteRect = Rect.fromLTWH(0, 20, size.width - 10, 80);
    canvas.drawRect(whiteRect, paint);
    // Draw Box white
    paint.color = Color(0xFF3397FF);
    final blackRect = Rect.fromLTWH(0, 20, 70, 80);
    canvas.drawRect(blackRect, paint);
    // Draw Text
    TextSpan textSpan = TextSpan(
      style: TextStyle(
          color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
      text: ((metros / 1000).toStringAsFixed(2)).toString(),
    );
    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(
        maxWidth: 70,
        minWidth: 70,
      );
    textPainter.paint(canvas, Offset(0, 35));
    //dibujar minutos
    textSpan = TextSpan(
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
      text: "Km",
    );
    textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(
        maxWidth: 70,
      );
    textPainter.paint(canvas, Offset(20, 67));
    // ubication draw
    textSpan = TextSpan(
      style: TextStyle(
          color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
      text: description,
    );
    textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: 2,
      ellipsis: "...",
    )..layout(
        maxWidth: size.width - 110,
      );
    textPainter.paint(canvas, Offset(100, 35));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
