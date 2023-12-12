// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../Api/api_error.dart';
import 'languages.dart';
import '../Api/dio_client.dart';
import '../Core/prox_locker.dart';

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
  static const String KEY_LANGUAGE_NAME = 'language_name';
  static const String KEY_USER_PREFER_LOCALE_CODE = 'user_prefer_locale_code';

  // default locale.
  static Locale get defaultLocale {
    String localeName = Platform.localeName;
    int index = localeName.indexOf('_');
    String name = localeName.substring(0, index);
    //print('-- system-default-locale: $name --');
    return Locale(name, '');
  }

  // main translation key for i18n.
  static Map<String, Map<String, String>> key = {
    "en": {"app_name": "App Name"}
  };

  static Locale? _appLocale;
  static List<String> _supportLocale = [];
  static Locale? get appLocale => _appLocale;
  static List<String> get supportLocale => _supportLocale;
  static bool get isChinese => _appLocale?.languageCode == 'zh';

  static ReadWriteValue<String> langCode = ReadWriteValue<String>(KEY_LANGUAGE_CODE, '', ProXLocker.box);
  static ReadWriteValue<String> langName = ReadWriteValue<String>(KEY_LANGUAGE_NAME, '', ProXLocker.box);

  static ReadWriteValue<List<dynamic>> suppCodes =
      ReadWriteValue<List<dynamic>>(KEY_SUPPORTED_CODES, <String>[], ProXLocker.box);
  static ReadWriteValue<String> userPreferLocaleCode =
      ReadWriteValue<String>(KEY_USER_PREFER_LOCALE_CODE, '', ProXLocker.box);

  // Initializer.
  static Future<RequestException?> init({bool isDefault = false}) async {
    RequestException? error;
    bool noInternetion = !(await checkInternetConnection());
    if (noInternetion) {
      var szCodesList = suppCodes.val.map((e) => e.toString()).toList();
      _supportLocale = suppCodes.val != [''] ? szCodesList : ['en'];
      _appLocale = supportLocale.contains(Get.deviceLocale?.languageCode)
          ? Get.deviceLocale
          : langCode.val != ''
              ? Locale(langCode.val)
              : Locale('en');
    } else {
      var labelHandleError = await _loadAllTranslations<List<String>>(isDefault);
      if (labelHandleError.error == null) {
        _supportLocale = labelHandleError.data;
        if (userPreferLocaleCode.val == '') {
          print('supportLocale: $supportLocale');
          print('Get.deviceLocale?.languageCode: ${Get.deviceLocale?.languageCode}');
          _appLocale = supportLocale.contains(Get.deviceLocale?.languageCode) ? Get.deviceLocale : Locale('en');
        } else {
          _appLocale =
              supportLocale.contains(userPreferLocaleCode.val) ? Locale(userPreferLocaleCode.val) : Locale('en');
        }
        langCode.val = _appLocale!.languageCode;
        suppCodes.val = supportLocale;
      } else {
        error = labelHandleError.error;
        var szCodesList = suppCodes.val.map((e) => e.toString()).toList();
        _supportLocale = suppCodes.val != [''] ? szCodesList : ['en'];
        _appLocale = supportLocale.contains(Get.deviceLocale?.languageCode)
            ? Get.deviceLocale
            : langCode.val != ''
                ? Locale(langCode.val)
                : Locale('en');
      }
    }
    //if (error == null) {
    await _loadFromLocaleFile();
    Get.addTranslations(key);
    Get.updateLocale(appLocale!);
    //}
    return error;
  }

  static Future<LabelInfo?> get localeInfo async {
    LabelInfo? labelInfo = await LabelUtil.shared.getLabelWithLocale(appLocale?.languageCode ?? '');
    return labelInfo;
  }

  Future<void> changeLanguage(String localeCode) async {
    LabelInfo? lf = await _loadTranslationFrom(localeCode);
    LabelInfo? labelInfo = lf ?? await LabelUtil.shared.getLabelWithLocale(localeCode);
    _appLocale = Locale(localeCode);
    langCode.val = localeCode;
    userPreferLocaleCode.val = localeCode;
    AppLanguage.key[localeCode] = labelInfo!.map;
    await Get.updateLocale(appLocale!);
    return;
  }

  static Future<void> _loadFromLocaleFile() async {
    List<LabelInfo?> labelInfoList = await Future.wait(_supportLocale.map((langCode) {
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

  Future<List<LabelInfo>> getAllLabelInfo() async {
    var list = await Future.wait(_supportLocale.map((langCode) {
      return LabelUtil.shared.getLabelWithLocale(langCode);
    }).toList());
    List<LabelInfo> returnList = [];
    for (var item in list) {
      if (item != null) {
        returnList.add(item);
      }
    }
    return returnList;
  }

  static Future<LabelHandleError<T>> _loadAllTranslations<T>(bool isDefault) async {
    var res = shared.getDefaultLabel();
    if (!isDefault) {
      res = await shared.getAllLabel((code, title, msg, {data, tryAgain}) async {
        if (kDebugMode) print('Error:\ncode: $code,\nmsg: $msg');
        return true;
      });
    }
    LabelSupport? labelSupport = res.data;
    bool haveResult = labelSupport != null;
    if (haveResult) {
      await Future.forEach(
          labelSupport.labelInfoList, (LabelInfo labelInfo) async => await LabelUtil.shared.writeLabelInto(labelInfo));
    }
    return LabelHandleError<T>(
        (haveResult ? labelSupport.supportedLocale : <String>[]) as T, haveResult ? null : res.error);
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
