// ignore_for_file: constant_identifier_names

import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'languages.dart';
import '../Api/dio_client.dart';
import '../Core/pro_x_storage.dart';

/*
  Welcome to Dexter's Enhanced Flutter i18n!
  ╔════════════════════════════════════════╗
  ║  Flutter i18n custom json from server  ║
  ╚════════════════════════════════════════╝

  -----
    This library is using Flutter GetX for state management,
    Feel free to provide feedback to improved the library, thanks!
  -----

  Step 1: Setup API
  ╔═══════════════════════════════════════════════════════════════════╗
  ║ Customise your API <endpoint> and <parameter/body> under the      ║
  ║ extension class LanguageApi in the language.api.dart file.        ║
  ║                                                                   ║
  ║   final urlPath = '/<your language api url path>';                ║
  ║                                                                   ║
  ║ * Make sure your backend team follow the json return format. *    ║
  ╚═══════════════════════════════════════════════════════════════════╝

  Setup 2: Call instance and initial it, handle error if any.
  ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
  ║ RequestException? error = await AppLanguage.init();                                                       ║
  ║ if (error != null) {                                                                                      ║
  ║   print('AppLanguage.init Error: ${error.errorMessage}');                                                 ║
  ║   await showNativeDialog('Error: ${error.code}', message: error.errorMessage, onDone: checkCredential);   ║
  ║   return;                                                                                                 ║
  ║ }                                                                                                         ║
  ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

  Step 3: Add your custom key in the language_key.dart.
  ╔════════════════════════════════════════════════════╗
  ║ static const Your_Custom_Key = 'Your_Custom_Key';  ║
  ╚════════════════════════════════════════════════════╝

  Step 4: Simply add .tr behind your key string, and you are good to go.
  ╔═════════════════════════════╗
  ║ Text('Your_Custom_Key'.tr)  ║
  ╚═════════════════════════════╝

  GoodLuck & Enjoy :D

*/

class AppLanguage {
  // class instance.
  static AppLanguage shared = AppLanguage();

  // key from server side.
  static const String Label_Support_JsonKey = 'supported_locale';
  static const String Label_Language_Name = 'name';
  static const String Label_Locale_Image = 'image_url';
  static const String Label_Version_Long_JsonKey = 'label_version';
  static const String Label_Version_Short_JsonKey = 'version';
  static const String Label_MapData_JsonKey = 'labels';

  // key for preferences.
  static const String KEY_LANGUAGE_CODE = 'language_code';
  static const String KEY_SUPPORTED_CODES = 'supported_codes';
  static const String KEY_USER_PREFER_LOCALE_CODE = 'user_prefer_locale_code';

  // default locale.
  static const Locale defaultLocale = Locale('en', 'US');

  // main translation key for i18n.
  static Map<String, Map<String, String>> key = {
    "en": {"app_name": "App Name"}
  };

  static Locale? _appLocale;
  static List<String>? _supportLocale = [];
  static Locale? get appLocale => _appLocale;
  static List<String>? get supportLocale => _supportLocale;

  static ReadWriteValue<String> langCode = ReadWriteValue<String>(KEY_LANGUAGE_CODE, '', ProXStorage.box);
  static ReadWriteValue<List<String>> suppCodes =
      ReadWriteValue<List<String>>(KEY_SUPPORTED_CODES, [], ProXStorage.box);
  static ReadWriteValue<String> userPreferLocaleCode =
      ReadWriteValue<String>(KEY_USER_PREFER_LOCALE_CODE, '', ProXStorage.box);

  // Initializer.
  static Future<RequestException?> init({bool isDefault = false}) async {
    RequestException? error;
    bool noInternetion = !(await checkInternetConnection());
    if (noInternetion) {
      _supportLocale = suppCodes.val != [] ? suppCodes.val : ['en'];
      _appLocale = langCode.val != '' ? Locale(langCode.val) : defaultLocale;
    } else {
      var labelHandleError = await _loadAllTranslations<List<String>>(isDefault);
      if (labelHandleError.error == null) {
        _supportLocale = labelHandleError.data;
        if (userPreferLocaleCode.val == '') {
          _appLocale = supportLocale!.contains(Get.deviceLocale?.languageCode) ? Get.deviceLocale : defaultLocale;
        } else {
          _appLocale =
              supportLocale!.contains(userPreferLocaleCode.val) ? Locale(userPreferLocaleCode.val) : defaultLocale;
        }
        langCode.val = _appLocale!.languageCode;
        suppCodes.val = supportLocale!;
      } else {
        error = labelHandleError.error;
      }
    }
    if (error == null) {
      await _loadFromLocaleFile();
      Get.addTranslations(key);
      Get.updateLocale(appLocale!);
    }
    return error;
  }

  void changeLanguage(String localeCode) async {
    LabelInfo? _lf = await _loadTranslationFrom(localeCode);
    LabelInfo? labelInfo = _lf ?? await LabelUtil.shared.getLabelWithLocale(localeCode);
    _appLocale = Locale(localeCode);
    langCode.val = localeCode;
    userPreferLocaleCode.val = localeCode;
    AppLanguage.key[localeCode] = labelInfo!.map;
    Get.updateLocale(appLocale!);
    return;
  }

  static Future<void> _loadFromLocaleFile() async {
    List<LabelInfo?> labelInfoList = await Future.wait(_supportLocale!.map((langCode) {
      return LabelUtil.shared.getLabelWithLocale(langCode);
    }).toList());
    List<Map<String, Map<String, String>>> mapList = labelInfoList.map((e) => {e!.locale: e.map}).toList();
    if (mapList.isNotEmpty) {
      for (var element in mapList) {
        AppLanguage.key.addAll(element);
      }
    }
    return;
  }

  Future<List<LabelInfo?>> getAllLabelInfo() async {
    return await Future.wait(_supportLocale!.map((langCode) {
      return LabelUtil.shared.getLabelWithLocale(langCode);
    }).toList());
  }

  static Future<LabelHandleError<T>> _loadAllTranslations<T>(bool isDefault) async {
    var res = shared.getDefaultLabel();
    if (!isDefault) {
      res = await shared.getAllLabel((code, msg, {tryAgain}) async {
        print('Error:\ncode: $code,\nmsg: $msg');
        return true;
      });
    }
    LabelSupport? labelSupport = res.data;
    bool haveResult = labelSupport != null;
    if (haveResult) {
      await Future.forEach(
          labelSupport.labelInfoList, (LabelInfo labelInfo) async => await LabelUtil.shared.writeLabelInto(labelInfo));
    }
    return LabelHandleError<T>((haveResult ? labelSupport.supportedLocale : []) as T, haveResult ? null : res.error);
  }

  /*static Future<LabelInfo?> _loadTranslationFrom(String locale) async {
    ResponseData<LabelInfo>? res = await shared.getLabelWith<LabelInfo>(locale, (code, msg, {tryAgain}) async {
      print('Error: code: $code,\nmsg: $msg');
      return true;
    });
    if (res.data != null) {
      LabelInfo labelInfo = res.data!;
      labelInfo.locale = locale;
      await LabelUtil.shared.writeLabelInto(labelInfo);
      return labelInfo;
    } else {
      return null;
    }
  }*/

  static Future<LabelInfo?> _loadTranslationFrom(String locale) async {
    LabelInfo? labelInfo = await LabelUtil.shared.getLabelWithLocale(locale);
    return labelInfo;
  }
}
