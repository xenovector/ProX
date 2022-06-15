//import 'dart:ui';
import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  Image? imageToDraw;
  final Color _color;

  CirclePainter(this._color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = _color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, 120), 60, paint1);
    // canvas.drawImage(imageToDraw!, Offset(size.width / 2, 0), paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
