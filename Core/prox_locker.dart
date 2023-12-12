import 'package:get_storage/get_storage.dart';

class ProXKey {
  static const isHMS = 'IS_HMS';
  static const appVersion = 'APP_VERSION';
  static const buildVersion = 'BUILD_VERSION';
  static const environmentName = 'ENVIRONMENT_NAME';
  static const accessToken = 'ACCESS_TOKEN';
  static const pushToken = 'PUSH_TOKEN';
  static const deviceID = 'DEVICE_ID';
  static const isFirstTime = 'IS_FIRST_TIME';

  static const isNotificationEnabled = 'IS_NOTIFICATION_ENABLED';
  static const dbVersion = 'DB_VERSION';
}

final isHMS = ReadWriteValue(ProXKey.isHMS, false, ProXLocker.box);
final appVersion = ReadWriteValue(ProXKey.appVersion, '', ProXLocker.box);
final buildVersion = ReadWriteValue(ProXKey.buildVersion, '', ProXLocker.box);
final environmentName = ReadWriteValue(ProXKey.environmentName, '', ProXLocker.box);
final accessToken = ReadWriteValue(ProXKey.accessToken, '', ProXLocker.box);
final pushToken = ReadWriteValue(ProXKey.pushToken, '', ProXLocker.box);
final deviceID = ReadWriteValue(ProXKey.deviceID, '', ProXLocker.box);
final isFirstTime = ReadWriteValue(ProXKey.isFirstTime, true, ProXLocker.box);

final isNotificationEnable = ReadWriteValue(ProXKey.isNotificationEnabled, true, ProXLocker.box);
final dbVersion = ReadWriteValue(ProXKey.dbVersion, 0, ProXLocker.box);

class ProXLocker {
  static const proXLockerKey = 'ProXLocker';
  static GetStorage box() => GetStorage(proXLockerKey);

  static Future<void> init({Function()? taskAfterInit}) async {
    await GetStorage.init(proXLockerKey);
    if (taskAfterInit != null) taskAfterInit();
    return;
  }
}
