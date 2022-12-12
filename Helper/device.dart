import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';
import '../Core/pro_x_storage.dart' as storage;
import '../Core/pro_x.dart';

class DevicePreferences {
  static var appName = '';
  static var packageName = '';
  static var appVersion = '';
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
    storage.appVersion.val = appVersion;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (storage.deviceID.val == '') {
        storage.deviceID.val = Uuid().v1();
      }
      //deviceId = androidInfo.androidId ?? storage.deviceID.val;
      deviceId = storage.deviceID.val;
      osVersion = androidInfo.version.release;
      model = androidInfo.model;
      androidSdkVersion = androidInfo.version.sdkInt;
      bool isHMS = await ProX.isHMS();
      storage.isHMS.val = isHMS;
      platform = isHMS ? 'huawei' : 'android';
      manufacturer = androidInfo.manufacturer;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? '';
      osVersion = iosInfo.systemVersion ?? '';
      model = iosInfo.model ?? '';
      platform = 'ios';
      manufacturer = 'apple';
    }

    if (kDebugMode) {
      print("""\n ═══ Device Information ═══════════════════════════════════════════════════════════
    appName: $appName
    packageName: $packageName
    version: $appVersion
    deviceID: $deviceId
    platform: $platform     [android/huawei/ios]
    osVersion: $osVersion
    model: $model
    ${platform != 'ios' ? 'androidSdkVersion: $androidSdkVersion' : ''}
 ══════════════════════════════════════════════════════════════════════════════════ \n """);
    }
  }
}
