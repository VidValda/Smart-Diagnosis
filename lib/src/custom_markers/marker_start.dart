part of "custom_markers.dart";

class MarkerStartPainter extends CustomPainter {
  final int minutos;

  MarkerStartPainter(this.minutos);
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
    path.moveTo(40, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(40, 100);
    canvas.drawShadow(path, Colors.black87, 10, false);
    // Draw Box white
    final whiteRect = Rect.fromLTWH(40, 20, size.width - 55, 80);
    canvas.drawRect(whiteRect, paint);
    // Draw Box white
    paint.color = Color(0xFF3397FF);
    final blackRect = Rect.fromLTWH(40, 20, 70, 80);
    canvas.drawRect(blackRect, paint);
    // Draw Text
    TextSpan textSpan = TextSpan(
      style: TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
      text: minutos.toString(),
    );
    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(
        minWidth: 70,
        maxWidth: 70,
      );
    textPainter.paint(canvas, Offset(40, 35));
    //dibujar minutos
    textSpan = TextSpan(
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
      text: "Min",
    );
    textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(
        minWidth: 70,
        maxWidth: 70,
      );
    textPainter.paint(canvas, Offset(40, 67));
    // ubication draw
    textSpan = TextSpan(
      style: TextStyle(
          color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
      text: "Mi Ubicaciòn",
    );
    textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(
        maxWidth: size.width - 130,
      );
    textPainter.paint(canvas, Offset(160, 50));
  }

  @override
  bool shouldRepaint(MarkerStartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(MarkerStartPainter oldDelegate) => false;
}
