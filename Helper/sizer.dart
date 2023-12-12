import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Core/prox_locker.dart';

class Sizer {
  static MediaQueryData mqData = Get.mediaQuery;
  static double screenWidth = 0;
  static double screenHeight = 0;

  // top and bottom safearea.
  static double topSafeAreaHeight = 0;
  static double bottomSafeAreaHeight = 0;

  // toolbar and appbar height.
  static double toolbarHeight = 0;
  static double appBarHeight = 0;

  // Determine huawei for smalelr text factor issue.
  static double get textFactor => isHMS.val ? 0.83 : 1.0;

  // Determine whether the device is iPhoneX serious.
  static bool get isiPhoneX => Platform.isIOS && mqData.viewPadding.bottom > 0;

  // Determine whether the device is tablet, 600 here is
  // a common breakpoint for a typical 7-inch tablet.
  static bool get isTablet => mqData.size.shortestSide >= 600;


  // ---
  static double designWidth = 411;
  static double designHeight = 830;
  // ---

  static double get bottomSafeAreaWithSpec {
    if (Platform.isIOS) {
      return 15 + Sizer.bottomSafeAreaHeight / 2;
    } else {
      return 15 + Sizer.bottomSafeAreaHeight;
    }
  }

  static void init() async {
    // reset value for optimized device.
    mqData = Get.mediaQuery;

    //
    screenWidth = mqData.size.width;
    screenHeight = mqData.size.height;
    topSafeAreaHeight = Get.mediaQuery.viewPadding.top; //await ProX.getSystemTopSafeAreaHeight() * (isiPhoneX ? 5 : 6) / 6;
    //bottomSafeAreaHeight = await ProX.getSystemBottomSafeAreaHeight();
    bottomSafeAreaHeight = mqData.viewPadding.bottom * (isiPhoneX ? 2 / 3 : 1);
    toolbarHeight = kToolbarHeight;
    appBarHeight = Sizer.topSafeAreaHeight + kToolbarHeight;

    if (kDebugMode) {
      print("""\n ═══ Sizer Information ════════════════════════════════════════════════════════════
    screenHeight: $screenHeight
    screenWidth: $screenWidth
    ratio: ${screenWidth / screenHeight}
    devicePixelRatio: ${mqData.devicePixelRatio}
    textScaleFactor: ${mqData.textScaleFactor}
    isiPhoneX: $isiPhoneX
    isTablet: $isTablet
 ══════════════════════════════════════════════════════════════════════════════════ \n """);
    }
  }
}
