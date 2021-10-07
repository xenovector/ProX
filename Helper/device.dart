import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:device_info/device_info.dart';
import '../Core/pro_x.dart';

class DevicePreferences {

  static var packageName = '';
  static var version = '';
  static var deviceId = '';
  static var platform = '';
  static var osVersion = '';
  static var model = '';
  static var manufacturer = '';

  static Future init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.androidId;
      osVersion = androidInfo.version.release;
      model = androidInfo.model;
      bool isHMS = await ProX.isHMS();
      platform = isHMS ? 'huawei' : 'android';
      manufacturer = androidInfo.manufacturer;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
      osVersion = iosInfo.systemVersion;
      model = iosInfo.model;
      platform = 'ios';
      manufacturer = 'apple';
    }

    print(""" ═══════════════════════════════════════════════════════════════════════════════════
    packageName: $packageName
    version: $version
    deviceID: $deviceId
    platform: $platform
    osVersion: $osVersion
    model: $model
 ═══════════════════════════════════════════════════════════════════════════════════""");
  }
}
