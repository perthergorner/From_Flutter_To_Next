import 'package:flutter/material.dart';

class CustomBubbleShape extends CustomPainter {
  final Color bgColor;

  CustomBubbleShape(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;
    Paint paint1 = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;
    var path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 8);
    path.lineTo(10, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
