import 'dart:async';
import 'package:dio/dio.dart';
import '../Core/prox_constant.dart';
import '../CoreModel/null_model.dart';
import '../Helper/hotkey.dart';
import 'api_setting.dart';
import 'dio_client.dart';
import '../Core/prox_locker.dart';
import '../Helper/device.dart';
import '../i18n/app_language.dart';

// RequestTaskException
class RequestException implements Exception {
  final int code;
  final dynamic data;

  Map<String, String>? get errorJson {
    bool dataIsJson = data is Map;
    //print('data: $data');
    Map<String, dynamic> json = dataIsJson ? data : {'message': data.toString()};
    Map<String, String> map = {};
    var message = json['message'];
    //print('message: $message');
    if (message != null) {
      map['message'] = message;
    }
    var error = json['error'];
    if (error != null) {
      map['error'] = error.toString();
    }
    if (map == {}) return null;
    return map;
  }

  String get errorMessage {
    return errorJson?['message'] ?? 'Message: ${data.toString()}';
  }

  RequestException(this.code, this.data);
}

// onObjectException
RequestException onObjectException(Object e, OnFail onFail) {
  if (e is RequestException) {
    onFail(e.code, 'ObjectException', e.errorMessage);
    return e;
  } else if (e is TypeError) {
    String stack = e.stackTrace?.toString() ?? '';
    stack = stack.split('#')[1].substring(1).trim();
    onFail(ApiSetting.InternalError, 'ObjectException', '${e.toString()}\n\nThrowExpression\n$stack');
    print('${e.toString()}\n\nThrowExpression\n$stack');
    return RequestException(ApiSetting.InternalError, e.toString());
  } else {
    onFail(ApiSetting.InternalError, 'ObjectException', e.toString());
    return RequestException(ApiSetting.InternalError, e.toString());
  }
}

// onErrorCatched
Future<Response<dynamic>> onErrorCatched(dynamic onError) async {
  requestList.removeAt(0);
  if (onError is DioError && onError.response != null) {
    return onError.response!;
  } else {
    throw RequestException(-1, onError.toString());
  }
}

Future<int?> sendErrorReport(String title, String message, OnFail onFail) async {
    const urlPath = '/log/error';
    var localeInfo = await AppLanguage.localeInfo;
    Map<String, dynamic> body = {
      'description': """
═════ Mobile App Error Report ═════
    appName: ${DevicePreferences.appName}
    packageName: ${DevicePreferences.packageName}
    version: ${DevicePreferences.appVersion}
    environmentName: ${environmentName.val}
    deviceID: ${DevicePreferences.deviceId}
    platform: ${DevicePreferences.platform}
    osVersion: ${DevicePreferences.osVersion}
    model: ${DevicePreferences.model}

    localeLanguage: ${localeInfo?.name}
    localeCode: ${localeInfo?.locale}
    localeVersion: ${localeInfo?.version}

    userFirstName: ${userItem?.firstName}
    userLastName: ${userItem?.lastName}
    userID: ${userItem?.uuid}

    Date: ${U.date.getCurrentDateForLog()}
    Time: ${U.date.getCurrentTimeForLog()}

    Error message:
    $title

    Stack Trace:
    $message
═════════════════════════════════
"""
    };
    var request = RequestTask.set(urlPath, body: body, headerType: HeaderType.standard);
    try {
      var response = await requestFilter<NullModel>(NullModel(), request);
      return response.data?.id;
    } catch (e) {
      onObjectException(e, onFail);
      return null;
    }
  }

  Future<int?> sendBugReport(String title, String message, OnFail onFail) async {
    const urlPath = '/log/bug';
    var localeInfo = await AppLanguage.localeInfo;
    Map<String, dynamic> body = {
      'description': """
═════ Mobile App Bug Report ═════
    appName: ${DevicePreferences.appName}
    packageName: ${DevicePreferences.packageName}
    version: ${DevicePreferences.appVersion}
    environmentName: ${environmentName.val}
    deviceID: ${DevicePreferences.deviceId}
    platform: ${DevicePreferences.platform}
    osVersion: ${DevicePreferences.osVersion}
    model: ${DevicePreferences.model}

    localeLanguage: ${localeInfo?.name}
    localeCode: ${localeInfo?.locale}
    localeVersion: ${localeInfo?.version}

    userFirstName: ${userItem?.firstName}
    userLastName: ${userItem?.lastName}
    userID: ${userItem?.uuid}

    Date: ${U.date.getCurrentDateForLog()}
    Time: ${U.date.getCurrentTimeForLog()}

    Error message:
    $title

    Stack Trace:
    $message
═════════════════════════════════
"""
    };
    var request = RequestTask.set(urlPath, body: body, headerType: HeaderType.standard);
    try {
      var response = await requestFilter<NullModel>(NullModel(), request);
      return response.data?.id;
    } catch (e) {
      onObjectException(e, onFail);
      return null;
    }
  }