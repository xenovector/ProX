import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../export.dart';

class SizeConfig {
  static MediaQueryData? _mqData;
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double blockSizeHorizontal = 0;
  static double blockSizeVertical = 0;
  static double appBarHeight = 0;
  // safe area
  static double _safeAreaHorizontal = 0;
  static double _safeAreaVertical = 0;
  static double safeBlockHorizontal = 0;
  static double safeBlockVertical = 0;
  static double safeHeight = 0;
  static double safeWidth = 0;
  static double topSafeAreaHeight = 0;
  static double bottomSafeAreaHeight = 0;

  // check tablet
  static bool isTablet = false;

  void init(BuildContext context) async {
    _mqData = MediaQuery.of(context);
    screenWidth = _mqData!.size.width;
    screenHeight = _mqData!.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    topSafeAreaHeight = await ProX.getSystemTopSafeAreaHeight();
    bottomSafeAreaHeight = await ProX.getSystemBottomSafeAreaHeight();
    appBarHeight = SizeConfig.topSafeAreaHeight + kToolbarHeight;
    // safe area
    _safeAreaHorizontal = _mqData!.padding.left + _mqData!.padding.right;
    _safeAreaVertical = _mqData!.padding.top + _mqData!.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
    safeHeight = screenHeight - _safeAreaVertical;
    safeWidth = screenWidth - _safeAreaHorizontal;

    // Determine whether the device is tablet, 600 here is
    // a common breakpoint for a typical 7-inch tablet.
    isTablet = _mqData!.size.shortestSide >= 600;
  }
}
