import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:huawei_hmsavailability/huawei_hmsavailability.dart';
import '../Api/dio_client.dart';
import '../Model/user.dart';
import '../model/preload.dart';
import '../Api/api_error.dart';
import '../Helper/hotkey.dart';
import 'prox_app_config.dart';


bool get isReleaseMode => kReleaseMode;
bool get isDebugMode => kDebugMode;

Preload? preload;
//GuestAccount? guestItem;
UserItem? userItem;
/*UserItem get getUserData => (userItem == null)
    ? guestItem!.toUserItem
    : userItem!.requireUpdateProfile
        ? userItem!.mergeInfo
        : userItem!;*/
bool useShadow = false;
String? linkContent;

class RegisterAndLoginMethod {
  static String get none => 'default';
  static String get emailOnly => 'email_only';
  static String get phoneOnly => 'phone_only';
  static String get apple => 'apple';
  static String get facebook => 'facebook';
  static String get google => 'google';
  static String get instagram => 'instagram';
  static String get linkedin => 'linkedin';
  static String get twitter => 'twitter';
  static String get wechat => 'wechat';
  static String get zalo => 'zalo';
}

class ProX {

  /// default app background color.
  static Color defaultBackgroundColor = S.color.background;

  /// Set a background image if needed, default value is null.
  ///
  /// BackgroundImage will be prior to use instead of background color, the checking will be ignore when the value is null.
  static String? defaultBackgroundImageAssetsPath;

  // Set a default loading widget if needed.
  static Widget? defaultLoadingWidget;

  // App Config.
  static AppConfig? appConfig;

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
    return SafeArea(
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
                onTap: () async {
                  int? bugID =
                      await sendBugReport(error.exceptionAsString(), error.stack.toString(), ProX.onFailed);
                  if (bugID != null) {
                    U.show.toast('Bug Report Send Successfully.\n*Refer ID: $bugID', milliseconds: 3000);
                  }
                },
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

  static MethodChannel get methodChannel => MethodChannel('com.prox.method_channel/prox');

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
    HmsApiAvailability client = HmsApiAvailability();
    int status = await client.isHMSAvailable();
    bool isitGMS = await isGMS();
    //return !_isGMS;
    return status == 0 && !isitGMS;
    // -- Added !_isGMS to ensure the device have actually no GMS, else still can proceed GMS services.
  }

  static Future<bool> isGMS() async {
    if (Platform.isIOS) return false;
    try {
      bool result = await methodChannel.invokeMethod('isGmsAvailable');
      return result;
    } on PlatformException {
      print('Failed to get _isGmsAvailable.');
      return false;
    }
  }

  /// General Error.
  static OnFail onFailed = ((code, title, msg, {data, tryAgain}) async => true);
}

void printSuperLongText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}



