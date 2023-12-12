import 'package:flutter/material.dart';

class StyleDecoration {
  final neoDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(6.0),
    color: Colors.grey.shade50,
    shape: BoxShape.rectangle,
    boxShadow: [
      BoxShadow(color: Colors.grey.shade300, spreadRadius: 0.0, blurRadius: 6, offset: Offset(3.0, 3.0)),
      BoxShadow(color: Colors.grey.shade400, spreadRadius: 0.0, blurRadius: 6 / 2.0, offset: Offset(3.0, 3.0)),
      BoxShadow(color: Colors.white, spreadRadius: 2.0, blurRadius: 6, offset: Offset(-3.0, -3.0)),
      BoxShadow(color: Colors.white, spreadRadius: 2.0, blurRadius: 6 / 2, offset: Offset(-3.0, -3.0)),
    ],
  );
}
