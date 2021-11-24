import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:huawei_hmsavailability/huawei_hmsavailability.dart';
//import 'package:huawei_hmsavailability/huawei_hmsavailability.dart';
import 'package:lottie/lottie.dart';
import '../export.dart';

class ProX {
  /// Set a default background color if needed, default value is `Colors.white`.
  static Color defaultBackgroundColor = Colors.white;

  /// Set a background image if needed, default value is null.
  ///
  /// BackgroundImage will be prior to use instead of background color, the checking will be ignore when the value is null.
  static String? defaultBackgroundImageAssetsPath;

  // Set a default loading widget if needed.
  static Widget? defaultLoadingWidget;

  /// By default have a function called forceUpdate(),
  /// which straight redirect user to the store when needed,
  /// but ios and hms required to manually insert the id.
  static String iosAppID = '', hmsAppID = '';

  /// A reusable image place holder, default value is `lib/ProX/Assets/empty_img.png`.
  static String placeHolderImage = 'lib/ProX/Assets/empty_img.png';

  static Future<void> setStatusBarTextColor({bool isWhite = true}) async {
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(isWhite);
  }

  static Future<void> setStatusBarBackground(Color color) async {
    await FlutterStatusbarcolor.setStatusBarColor(color);
  }

  static void setAllowedOrientation(List<DeviceOrientation> orientationList) {
    SystemChrome.setPreferredOrientations(orientationList);
  }

  static Widget customErrorWidget(FlutterErrorDetails error) {
    return ProXSafeArea(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 30, bottom: 10),
              child: Icon(Icons.announcement, size: 40, color: Colors.red)),
          Text(
            'An application error has occurred.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Error message:',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500, decoration: TextDecoration.underline)),
                  Text(error.exceptionAsString()),
                ],
              )),
          Expanded(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Stack Trace:',
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w500, decoration: TextDecoration.underline)),
                    Expanded(child: SingleChildScrollView(child: Text(error.stack.toString()))),
                  ],
                )),
          ),
          Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              child: InkWell(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text('Send Bug Report',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ))),
                ),
              )),
        ]),
      ),
    );
  }

  static MethodChannel _methodChannel = MethodChannel('com.prox.method_channel/prox');

  /// 0: HMS Core (APK) is available.
  ///
  /// 1: No HMS Core (APK) is found on device.
  ///
  /// 2: HMS Core (APK) installed is out of date.
  ///
  /// 3: HMS Core (APK) installed on the device is unavailable.
  ///
  /// 9: HMS Core (APK) installed on the device is not the official version.
  ///
  /// 21: The device is too old to support HMS Core (APK)
  ///
  static Future<bool> isHMS() async {
    if (Platform.isIOS) return false;
    HmsApiAvailability client = new HmsApiAvailability();
    int status = await client.isHMSAvailable();
    bool _isGMS = await isGMS();
    //return !_isGMS;
    return status == 0 && !_isGMS;
    // -- Added !_isGMS to ensure the device have actually no GMS, else still can proceed GMS services.
  }

  static Future<bool> isGMS() async {
    if (Platform.isIOS) return false;
    try {
      bool result = await _methodChannel.invokeMethod('isGmsAvailable');
      return result;
    } on PlatformException {
      print('Failed to get _isGmsAvailable.');
      return false;
    }
  }

  static Future<double> getSystemTopSafeAreaHeight() async {
    if (Platform.isIOS) {
      return Get.mediaQuery.viewPadding.top;
    }
    try {
      int result = await _methodChannel.invokeMethod('statusBarHeight');
      return result / Get.mediaQuery.devicePixelRatio;
    } on PlatformException {
      print('Failed to get navigationBarHeight.');
      return 0;
    }
  }

  static Future<double> getSystemBottomSafeAreaHeight({bool forceAndroidZero = true}) async {
    if (Platform.isIOS) {
      return Get.mediaQuery.viewPadding.bottom;
    }
    if (forceAndroidZero) return 0;
    try {
      int result = await _methodChannel.invokeMethod('navigationBarHeight');
      return result / Get.mediaQuery.devicePixelRatio;
    } on PlatformException {
      print('Failed to get navigationBarHeight.');
      return 0;
    }
  }

  static GeneralErrorHandle onFailed = ((code, msg, {tryAgain}) async => true);
}

abstract class GeneralCallBack {
  Future<bool> onFailed(int code, String msg, {Function() tryAgain});
}

typedef GeneralErrorHandle = Future<bool> Function(int code, String msg, {Function()? tryAgain});

class ProXController extends GetxController with WidgetsBindingObserver implements GeneralCallBack {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  RxBool _isLoading = false.obs;
  RxString _onLoadingText = ''.obs;
  RxString selectedLanguage = Get.locale?.languageCode.obs ?? 'en'.obs;
  double _horizontalDown = 0;
  //StreamSubscription subscription;

  @override
  void onInit() {
    WidgetsBinding.instance?.addObserver(this);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    WidgetsBinding.instance?.removeObserver(this);
    //subscription?.cancel();
    super.onClose();
  }

  /// There is *four* type of state is below:
  ///
  /// AppLifecycleState.inactive
  ///
  /// AppLifecycleState.paused
  ///
  /// AppLifecycleState.inactive
  ///
  /// AppLifecycleState.resumed
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      //
    } else if (state == AppLifecycleState.resumed) {
      //
    }
  }

  Future<bool> onHandleWillPop() async {
    return true;
  }

  void initStreamSubscription(VoidCallback callback) {
    /*subscription = NC.eventBus.on<NC.NotificationData>().listen((data) {
      showFlash(data.title, data.message);
      callback();
    });*/
  }

  void isLoading(bool value,
      {String textAfterSeconds = 'Just a moment more,\nsorry for keep you waiting...', int seconds = 7}) async {
    _isLoading(value);
    if (value && !textAfterSeconds.isEmptyOrNull) {
      await Future.delayed(Duration(seconds: seconds));
      if (_isLoading.isTrue) {
        /*timer = Timer.periodic(Duration(milliseconds: 900), (timer) {
          var szText = '';
          if (_onLoadingText.value.endsWith('...')) {
            szText = _onLoadingText.value.substring(0, _onLoadingText.value.length - 3);
            szText += '.';
          } else if (_onLoadingText.value.endsWith('.') || _onLoadingText.value.endsWith('..')) {
            szText = _onLoadingText.value += '.';
          } else {
            szText = textAfterSeconds;
            if (!szText.endsWith('.')) szText += '.';
          }
          _onLoadingText(szText);
        });*/
        _onLoadingText(textAfterSeconds);
      }
    } else if (!value) {
      //timer?.cancel();
      _onLoadingText('');
    }
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  set changeLanguage(String lang) {
    Locale locale = new Locale(lang);
    Get.updateLocale(locale);
    selectedLanguage.value = lang;
  }

  @override
  Future<bool> onFailed(int code, String msg, {Function()? tryAgain}) async {
    return ProX.onFailed(code, msg, tryAgain: tryAgain);
  }
}

class ProXWidget<T extends ProXController> extends GetView<T> {
  final Widget? appBar;
  final Color? appBarColor;
  final Gradient? appBarGradient;
  final bool appBarWithShadow;
  final Drawer? drawer;
  final Widget child;
  final Color? customBackgroundColor;
  final String? customBackgroundImage;

  ProXWidget(
      {Key? key,
      this.appBar,
      this.appBarColor,
      this.appBarGradient,
      this.appBarWithShadow = true,
      this.drawer,
      required this.child,
      this.customBackgroundColor,
      this.customBackgroundImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      drawer: drawer,
      extendBodyBehindAppBar: true,
      body: Obx(() => WillPopScope(
            onWillPop: controller.onHandleWillPop,
            child: GestureDetector(
              onHorizontalDragDown: (details) {
                controller._horizontalDown = details.localPosition.dx;
              },
              onHorizontalDragEnd: (details) async {
                if (controller._horizontalDown < 5) {
                  bool needPop = await controller.onHandleWillPop();
                  if (needPop) Get.back();
                }
              },
              child: KeyboardDismissOnTap(
                child: MediaQuery(
                  data: Get.mediaQuery.copyWith(textScaleFactor: 1.0),
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: (customBackgroundImage != null || ProX.defaultBackgroundImageAssetsPath != null)
                              ? Image.asset(customBackgroundImage ?? ProX.defaultBackgroundImageAssetsPath!,
                                  fit: BoxFit.cover)
                              : Container(color: customBackgroundColor ?? ProX.defaultBackgroundColor)),
                      Positioned.fill(
                          top: appBar == null ? 0 : SizeConfig.topSafeAreaHeight + kToolbarHeight, child: child),
                      appBar == null
                          ? Center()
                          : Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              child: Container(
                                  height: SizeConfig.topSafeAreaHeight + kToolbarHeight,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: appBarGradient == null ? appBarColor ?? Colors.white : null,
                                    gradient: appBarGradient,
                                    boxShadow: appBarWithShadow
                                        ? [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0,
                                              blurRadius: 7,
                                              offset: Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: SizeConfig.topSafeAreaHeight),
                                      Expanded(child: appBar!)
                                    ],
                                  )),
                            ),
                      Positioned.fill(
                          child: controller._isLoading.isTrue
                              ? GestureDetector(
                                  child: ProX.defaultLoadingWidget ??
                                      Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          color: Colors.black26,
                                          padding: EdgeInsets.symmetric(horizontal: 30),
                                          child: Center(
                                            child: AnimatedContainer(
                                              duration: Duration(milliseconds: 750),
                                              //curve: Curves.easeOutExpo,
                                              padding: EdgeInsets.fromLTRB(15, controller._onLoadingText.value.isEmptyOrNull ? 15 : 50, 15, 10),
                                              decoration: BoxDecoration(
                                                  color: controller._onLoadingText.value.isEmptyOrNull
                                                      ? Colors.white12
                                                      : Colors.white.withOpacity(0.85),
                                                  borderRadius: BorderRadius.circular(12),
                                                  boxShadow: controller._onLoadingText.value.isEmptyOrNull
                                                      ? null
                                                      : ProXShadow),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircularProgressIndicator(),
                                                  SizedBox(height: controller._onLoadingText.value.isEmptyOrNull ? 5 : 10),
                                                  if (!controller._onLoadingText.value.isEmptyOrNull)
                                                    Container(
                                                    padding: EdgeInsets.symmetric(vertical: 20),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(controller._onLoadingText.value,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: ThemeColor.main)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                  onTap: () {
                                    controller.isLoading(false);
                                  },
                                )
                              : Center()),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

class ProXSafeArea extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  ProXSafeArea({required this.child, this.top = true, this.bottom = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: top ? SizeConfig.topSafeAreaHeight : 0,
        bottom: bottom ? SizeConfig.bottomSafeAreaHeight : 0,
      ),
      child: child,
    );
  }
}

class ProXDebugWidget extends StatelessWidget {
  final Widget child;
  final Color color;
  ProXDebugWidget({required this.child, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: color)),
      child: child,
    );
  }
}

class ProXWorkInProgressWidget extends StatelessWidget {
  final String text;
  ProXWorkInProgressWidget({this.text = 'Work In Progress...'});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.network('https://assets2.lottiefiles.com/packages/lf20_8uHQ7s.json', width: 300, reverse: true),
        SizedBox(height: 20),
        Text(text),
      ],
    )));
  }
}

const ProXShadow = [
  BoxShadow(
    color: Colors.black12,
    offset: Offset(0, 1),
    blurRadius: 2,
  )
];

void printSuperLongText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
