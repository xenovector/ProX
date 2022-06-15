import 'package:get_storage/get_storage.dart';

class ProXKey {
  static const accessToken = 'ACCESS_TOKEN';
  static const userID = 'USER_ID';
  static const isFirstTime = 'IS_FIRST_TIME';
  static const isNotificationEnabled = 'IS_NOTIFICATION_ENABLED';
  static const dbVersion = 'DB_VERSION';
}

final accessToken = ReadWriteValue(ProXKey.accessToken, '', ProXStorage.box);
final userID = ReadWriteValue(ProXKey.userID, '', ProXStorage.box);
final isFirstTime = ReadWriteValue(ProXKey.isFirstTime, false, ProXStorage.box);
final isNotificationEnable = ReadWriteValue(ProXKey.isNotificationEnabled, true, ProXStorage.box);
final dbVersion = ReadWriteValue(ProXKey.dbVersion, 0, ProXStorage.box);

class ProXStorage {
  static const proXStorageKey = 'ProXStorage';
  static GetStorage box() => GetStorage(proXStorageKey);

  static void init({Function()? taskAfterInit}) async {
    await GetStorage.init(proXStorageKey);
    if (taskAfterInit != null) taskAfterInit();
  }
}
