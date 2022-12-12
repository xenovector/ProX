import 'package:get_storage/get_storage.dart';

class ProXKey {
  static const isHMS = 'IS_HMS';
  static const appVersion = '';
  static const stagName = '';
  static const accessToken = 'ACCESS_TOKEN';
  static const deviceID = 'DEVICE_ID';
  static const userID = 'USER_ID';
  static const isFirstTime = 'IS_FIRST_TIME';
  static const isFirstTimeEnterTopic = 'IS_FIRST_TIME_ENTER_TOPIC';
  static const isNotificationEnabled = 'IS_NOTIFICATION_ENABLED';
  static const dbVersion = 'DB_VERSION';
}

final isHMS = ReadWriteValue(ProXKey.isHMS, false, ProXStorage.box);
final appVersion = ReadWriteValue(ProXKey.appVersion, '', ProXStorage.box);
final stagName = ReadWriteValue(ProXKey.stagName, '', ProXStorage.box);
final accessToken = ReadWriteValue(ProXKey.accessToken, '', ProXStorage.box);
final deviceID = ReadWriteValue(ProXKey.deviceID, '', ProXStorage.box);
final userID = ReadWriteValue(ProXKey.userID, '', ProXStorage.box);
final isFirstTime = ReadWriteValue(ProXKey.isFirstTime, false, ProXStorage.box);
final isFirstTimeEnterTopic = ReadWriteValue(ProXKey.isFirstTimeEnterTopic, true, ProXStorage.box);
final isNotificationEnable = ReadWriteValue(ProXKey.isNotificationEnabled, true, ProXStorage.box);
final dbVersion = ReadWriteValue(ProXKey.dbVersion, 0, ProXStorage.box);

class ProXStorage {
  static const proXStorageKey = 'ProXStorage';
  static GetStorage box() => GetStorage(proXStorageKey);

  static Future<void> init({Function()? taskAfterInit}) async {
    await GetStorage.init(proXStorageKey);
    if (taskAfterInit != null) taskAfterInit();
    return;
  }
}
