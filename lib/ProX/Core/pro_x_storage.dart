import 'package:get_storage/get_storage.dart';
export 'package:get_storage/get_storage.dart';

final accessToken = ReadWriteValue(ProXKey.ACCESS_TOKEN, '', ProXStorage.box);
final userID = ReadWriteValue(ProXKey.USER_ID, '', ProXStorage.box);
final isFirstTime = ReadWriteValue(ProXKey.IS_FIRST_TIME, '', ProXStorage.box);
final notificationEnabeld = ReadWriteValue(ProXKey.NOTIFICATION_ENABLED, true, ProXStorage.box);
final dbVersion = ReadWriteValue(ProXKey.DB_VERSION, 0, ProXStorage.box);

class ProXKey {
  static const ACCESS_TOKEN = 'ACCESS_TOKEN';
  static const USER_ID = 'USER_ID';
  static const IS_FIRST_TIME = 'IS_FIRST_TIME';
  static const NOTIFICATION_ENABLED = 'NOTIFICATION_ENABLED';
  static const DB_VERSION = 'DB_VERSION';
}

class ProXStorage {
  static const ProXStorage_KEY = 'ProXStorage';
  static final box = () => GetStorage(ProXStorage_KEY);

  static void init({Function()? taskAfterInit}) async {
    await GetStorage.init(ProXStorage_KEY);
    if (taskAfterInit != null) taskAfterInit();
  }
}
