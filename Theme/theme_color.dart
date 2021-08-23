import 'package:flutter/material.dart';

/// App Theme Color Controller.
class ThemeColor {
  static const int _r = 0, _g = 0, _b = 0;
  static const darkMode = false; //Get.isDarkMode;

  /// Main
  static const main = darkMode ? mainDark : mainLight;
  static const mainLight = Color(0xFF2C92CE);
  static const mainDark = Color(0xFF2C92CE);

  /// Background
  static const background = darkMode ? backgroundDark : backgroundLight;
  static const backgroundLight = Color(0xFFF5F6FA);
  static const backgroundDark = Color(0xFFF5F6FA);

  /// Text
  static const text = darkMode ? textDark : textLight;
  static const textLight = Color(0xFF6C6C6C);
  static const textDark = Color(0xFF082F3B);

  /// Line
  static const line = darkMode ? lineDark : lineLight;
  static const lineLight = Color(0xFFC3C3C3);
  static const lineDark = Color(0xFFC3C3C3);

  //ProX's Color
  static const disable = Color(0x29000000);
  static const tickGreen = Color(0xFF1EA328);
  static const dialog_error_color = Color(0xFFFC6666);

  // Custom
  static const secondary = Color(0xFFFFAF46);
  static const light_black = Color(0xFFA8A8A8);
  static const text_color = Color(0xFF000000);
  static const text_color_contrast = Color(0xFFFFFFFF);

  /// ThemeSwatch
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
