import '../export.dart';

class SizeConfig {
  static final MediaQueryData _mqData = Get.mediaQuery;
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
  static bool isSmallScreen = false;

  static double get customAppBarHeight => topSafeAreaHeight + kToolbarHeight;

  // check tablet
  static bool isTablet = false;

  static void init() async {
    //_mqData = ;
    screenWidth = _mqData.size.width;
    screenHeight = _mqData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    topSafeAreaHeight = await ProX.getSystemTopSafeAreaHeight();
    //bottomSafeAreaHeight = await ProX.getSystemBottomSafeAreaHeight();
    bottomSafeAreaHeight = _mqData.viewPadding.bottom;
    appBarHeight = SizeConfig.topSafeAreaHeight + kToolbarHeight;
    // safe area
    _safeAreaHorizontal = _mqData.padding.left + _mqData.padding.right;
    _safeAreaVertical = _mqData.padding.top + _mqData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
    safeHeight = screenHeight - _safeAreaVertical;
    safeWidth = screenWidth - _safeAreaHorizontal;

    // Determine whether the device is tablet, 600 here is
    // a common breakpoint for a typical 7-inch tablet.
    isTablet = _mqData.size.shortestSide >= 600;

    print('screenWidth: $screenWidth');
    print('screenHeight: $screenHeight');
    print('ratio: ${screenWidth / screenHeight}');
    print('devicePixelRatio: ${_mqData.devicePixelRatio}');
    print('textScaleFactor: ${_mqData.textScaleFactor}');
    if (screenWidth / screenHeight > 0.5) {
      isSmallScreen = true;
    }
  }
}
