import 'package:flutter/material.dart';

class StyleShadow {
  final softShadow = [
    const BoxShadow(
      blurRadius: 20,
      offset: Offset(0, 2)
    )
  ];

  final hardShadow = [
    const BoxShadow(
      blurRadius: 2,
      offset: Offset(0, 2)
    ),
    const BoxShadow(
      blurRadius: 4,
      offset: Offset(0, 4)
    ),
  ];

  final proxShadow = [
    BoxShadow(
      color: Colors.black12,
      offset: Offset(0, 1),
      blurRadius: 2,
    )
  ];

  final proxShadowX2 = [
    BoxShadow(
      color: Colors.black12,
      offset: Offset(0, 2),
      blurRadius: 4,
    )
  ];

  final proxShadowHalfDark = [
    BoxShadow(
      color: Colors.black54,
      offset: Offset(0, 1),
      blurRadius: 2,
    )
  ];
}