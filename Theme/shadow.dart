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
}