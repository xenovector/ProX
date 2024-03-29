import 'package:flutter/material.dart';

class StyleColor {
  static const int _r = 0, _g = 0, _b = 0;
  static const darkMode = false; //Get.isDarkMode;

  /// Main
  final main = darkMode ? _mainDark : _mainLight;
  static const _mainLight = Color(0xFF2C92CE);
  static const _mainDark = Color(0xFF2C92CE);

  /// Secondary
  final subMain = darkMode ? subMainDark : subMainLight;
  static const subMainLight = Color(0xFF2C92CE);
  static const subMainDark = Color(0xFF2C92CE);

  /// Background
  final background = darkMode ? backgroundDark : backgroundLight;
  static const backgroundLight = Color(0xFFF5F6FA);
  static const backgroundDark = Color(0xFFF5F6FA);

  /// Text
  final text = darkMode ? textDark : textLight;
  static const textLight = Color(0xFF969595);
  static const textDark = Color(0xFF4D4D4D);

  /// Line
  final line = darkMode ? lineDark : lineLight;
  static const lineLight = Color(0xFFC3C3C3);
  static const lineDark = Color(0xFFC3C3C3);

  // ProX's Color
  final disable = Color(0x29000000);
  final tickGreen = Color(0xFF1EA328);
  final dialogErrorColor = Color(0xFFFC6666);
  final alertSecondaryColor = Color(0xFFEC4D3D);
  final alertPrimaryColor = Color(0xFF3182FA);

  // Custom
  final themeLightGrey = Color(0xFFDDDDDD);
  final themeInActiveGrey = Color(0xFFC6C6C6);
  final themeTitleColor = Color(0xFF4D4D4D);
  final themeTextColor = Color(0xFF969595);
  //
  final themeMainDefault = Color(0xFF139649);
  final themeMainLight = Color(0xFF2ED876);
  final themeMainDark = Color(0xFF22C366);
  final themeMainShadow = Color(0xFF2DC46D);
  final themeYellowBg = Color(0xFFFFFCE3);

  /// ThemeSwatch
  ///
  /// Add default font if needed. <* e.g. ThemeData(fontFamily: 'Poppins') *>
  ///
  final ThemeData themeData = ThemeData(
      primarySwatch: swatch,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: _mainLight,
        selectionHandleColor: _mainLight,
      )); /*.copyWith(
    colorScheme: themeData.colorScheme.copyWith(secondary: ThemeColor.main),
  );*/
  static const MaterialColor swatch = MaterialColor(0xFF2C92CE, _color);
  static const Map<int, Color> _color = {
    50: Color.fromRGBO(_r, _g, _b, .1),
    100: Color.fromRGBO(_r, _g, _b, .2),
    200: Color.fromRGBO(_r, _g, _b, .3),
    300: Color.fromRGBO(_r, _g, _b, .4),
    400: Color.fromRGBO(_r, _g, _b, .5),
    500: Color.fromRGBO(_r, _g, _b, .6),
    600: Color.fromRGBO(_r, _g, _b, .7),
    700: Color.fromRGBO(_r, _g, _b, .8),
    800: Color.fromRGBO(_r, _g, _b, .9),
    900: Color.fromRGBO(_r, _g, _b, 1),
  };
}
