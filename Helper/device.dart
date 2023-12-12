import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';
import '../Core/prox_locker.dart' as locker;
import '../Core/prox_constant.dart';

class DevicePreferences {
  static var appName = '';
  static var packageName = '';
  static var appVersion = '';
  static var buildVersion = '';
  static var deviceId = '';
  static var platform = '';
  static var osVersion = '';
  static var model = '';
  static var manufacturer = '';
  static var androidSdkVersion = 0;

  static Future init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    appVersion = packageInfo.version;
    buildVersion = packageInfo.buildNumber;
    locker.appVersion.val = appVersion;
    locker.buildVersion.val = buildVersion;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (locker.deviceID.val == '') {
        locker.deviceID.val = Uuid().v1();
      }
      //deviceId = androidInfo.androidId ?? storage.deviceID.val;
      deviceId = locker.deviceID.val;
      osVersion = androidInfo.version.release;
      model = androidInfo.model;
      androidSdkVersion = androidInfo.version.sdkInt;
      bool isHMS = await ProX.isHMS();
      locker.isHMS.val = isHMS;
      platform = isHMS ? 'huawei' : 'android';
      manufacturer = androidInfo.manufacturer;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? '';
      osVersion = iosInfo.systemVersion;
      model = iosInfo.utsname.machine;
      platform = 'ios';
      manufacturer = 'apple';
    }

    if (kDebugMode) {
      print("""\n ═══ Device Information ═══════════════════════════════════════════════════════════
    appName: $appName
    packageName: $packageName
    version: $appVersion
    build: $buildVersion
    deviceID: $deviceId
    platform: $platform     [android/huawei/ios]
    osVersion: $osVersion
    model: $model
    ${platform != 'ios' ? 'androidSdkVersion: $androidSdkVersion' : ''}
 ══════════════════════════════════════════════════════════════════════════════════ \n """);
    }
  }
}
