import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'api_setting.dart';
import 'response.dart';
import '../i18n/app_language.dart';
import '../Helper/device.dart';
import '../Core/pro_x_storage.dart' as storage;
import '../Core/extension.dart';
import '../Core/pro_x.dart';

typedef OnSuccess = void Function(String message);
typedef OnFail = Future<bool> Function(int code, String message, {Function()? tryAgain});
typedef OnGenericCallBack = void Function(String message, dynamic result);

enum STATUS { FAILED, SUCCESS }

class SocialLoginData {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  //google or facebook
  final bool isFacebook;
  final bool isApple;

  SocialLoginData(this.id, this.name, this.email, this.imageUrl, this.isFacebook, this.isApple);
}

// HttpMethod Enum
enum HttpMethod { get, post, put, patch, delete, multipart }

/// #### HttpHeaderType Enum
/// * **none** = Nothing, Absolute no header declared.
/// * **standard** = with basic acceptHeader, contentType, included app-verison, device-platform, and locale.
/// * **authorized** = included everything in standard, but with authorized header, value of 'Bearer $YOUR_ACCESS_TOKEN'
enum HeaderType { none, standard, authorized }

const acceptHeader = "application/json";
const contentHeader = 'application/x-www-form-urlencoded';
const multipartHeader = 'multipart/form-data';

// RequestTask Object
class RequestTask {
  final String urlPath;
  final Map<String, String>? parameter;
  final Map<String, File>? filesField;
  final HeaderType headerType;
  final Map<String, String>? extraHeader;
  final HttpMethod requestMethod;
  final String apiVersion;
  final bool ignoreHtmlErrorHandling;
  final String? preAccessToken;
  final bool usingRawURL;
  final bool getRawData;
  final bool isRequestingEndpoint;

  const RequestTask(
      {required this.urlPath,
      required this.parameter,
      required this.headerType,
      required this.filesField,
      required this.extraHeader,
      required this.requestMethod,
      required this.apiVersion,
      required this.ignoreHtmlErrorHandling,
      required this.preAccessToken,
      required this.usingRawURL,
      required this.getRawData,
      required this.isRequestingEndpoint});

  factory RequestTask.set(String path,
      {Map<String, String>? body,
      HeaderType headerType = HeaderType.none,
      Map<String, String>? extraHeader,
      Map<String, File>? filesField,
      HttpMethod requestMethod = HttpMethod.post,
      String apiVersion = ApiSetting.defaultApiVersion,
      bool ignoreHtmlErrorHandling = false,
      String? preAccessToken,
      bool usingRawURL = false,
      bool getRawData = false,
      bool isRequestingEndpoint = false}) {
    return RequestTask(
        urlPath: path,
        parameter: body,
        headerType: headerType,
        extraHeader: extraHeader,
        filesField: filesField,
        requestMethod: requestMethod,
        apiVersion: apiVersion,
        ignoreHtmlErrorHandling: ignoreHtmlErrorHandling,
        preAccessToken: preAccessToken,
        usingRawURL: usingRawURL,
        getRawData: getRawData,
        isRequestingEndpoint: isRequestingEndpoint);
  }
}

// RequestTaskException
class RequestException implements Exception {
  final int code;
  final String errorMessage;

  RequestException(this.code, this.errorMessage);
}

// onObjectException
RequestException onObjectException(Object e, OnFail onFail) {
  if (e is RequestException) {
    onFail(e.code, e.errorMessage);
    return e;
  } else if (e is TypeError) {
    String stack = e.stackTrace?.toString() ?? '';
    stack = stack.split('#')[1].substring(1).trim();
    onFail(ApiSetting.InternalError, e.toString() + '\n\nThrowExpression\n$stack');
    return RequestException(ApiSetting.InternalError, e.toString());
  } else {
    onFail(ApiSetting.InternalError, e.toString());
    return RequestException(ApiSetting.InternalError, e.toString());
  }
}

// onErrorCatched
Future<Response<dynamic>> onErrorCatched(dynamic onError) async {
  if (onError is DioError && onError.response != null) {
    return onError.response!;
  } else {
    throw RequestException(-1, onError.toString());
  }
}

// Request Body Filter
Future<ResponseData<R>> requestFilter<R extends RData>(R item, RequestTask request) async {
  bool noInternetion = !(await checkInternetConnection());

  if (noInternetion) {
    throw RequestException(ApiSetting.InternalError, 'No Internet Connection, Please check your network and try again.');
  }

  var szUrl = request.usingRawURL
      ? request.urlPath
      : request.isRequestingEndpoint
          ? ApiSetting.deadPoint
          : ApiSetting.endPoint + request.apiVersion + request.urlPath;
  var body = request.parameter;
  Map<String, String> header = request.headerType == HeaderType.none
      ? {}
      : request.headerType == HeaderType.authorized
          ? {
              HttpHeaders.authorizationHeader: "Bearer ${request.preAccessToken ?? storage.accessToken.val}",
              HttpHeaders.acceptHeader: acceptHeader,
              HttpHeaders.contentTypeHeader: request.requestMethod == HttpMethod.multipart ? multipartHeader : contentHeader,
              'App-Version': DevicePreferences.version,
              'Device': DevicePreferences.platform,
              'locale': AppLanguage.appLocale?.languageCode.getEmptyOrNull ?? 'en',
            }
          : {
              HttpHeaders.acceptHeader: acceptHeader,
              HttpHeaders.contentTypeHeader: contentHeader,
              'App-Version': DevicePreferences.version,
              'Device': DevicePreferences.platform,
              'locale': AppLanguage.appLocale?.languageCode.getEmptyOrNull ?? 'en',
            };
  if (request.extraHeader != null) {
    request.extraHeader!.forEach((key, value) {
      header[key] = value;
    });
  }

  final Dio dio = Dio(BaseOptions(
    connectTimeout: 30000, // 30 seconds,
    headers: header,
  ));
  Response? response;
  print('----- Request Info');
  print('url: $szUrl');
  printSuperLongText('header: $header');
  print('parameter: $body');
  print('----- End Info');
  print('Request Send --->');
  switch (request.requestMethod) {
    case HttpMethod.post:
      response = await dio.post(szUrl, data: body).catchError(onErrorCatched);
      break;
    case HttpMethod.get:
      response = await dio.get(szUrl).catchError(onErrorCatched);
      break;
    case HttpMethod.put:
      response = await dio.put(szUrl).catchError(onErrorCatched);
      break;
    case HttpMethod.delete:
      response = await dio.delete(szUrl).catchError(onErrorCatched);
      break;
    case HttpMethod.multipart:
      Map<String, dynamic> multipartRequestBody = body ??= {};

      if (request.filesField != null) {
        request.filesField!.forEach((key, file) async {
          multipartRequestBody.addAll({
            key: await MultipartFile.fromFile(file.path, filename: basename(file.path)),
          });
        });
      }
      /*
      if (request.files.isNotEmpty) {
        if (request.files.length > 1 || request.forceFileArray) {
          List<MultipartFile> multipartList = [];
          for (var file in request.files) {
            multipartList.add(MultipartFile.fromFileSync(file.path, filename: basename(file.path)));
          }
          multipartRequestBody.addAll({'files': multipartList});
        } else {
          File file = request.files[0];
          multipartRequestBody.addAll({
            'file': await MultipartFile.fromFile(file.path, filename: basename(file.path)),
          });
        }
      }
      */
      response = await dio.post(
        szUrl,
        data: FormData.fromMap(multipartRequestBody),
        onSendProgress: (int sent, int total) {
          print('$sent $total');
        },
      ).catchError(onErrorCatched);
      break;
    default:
      response = null;
      break;
  }
  print('<--- Request Backed');
  if (response != null) {
    print('done request with statusCode: ${response.statusCode}');
    if (response.statusCode == 200) {

      // dio body check
      print('response:\n${response.data}');

      var rawData = request.ignoreHtmlErrorHandling ? response.data : jsonDecode(response.data);
      if (request.getRawData) {
        return ResponseData<R>(code: response.statusCode ?? 0, rawData: rawData);
      } else {
        var res = ResponseData<R>.fromJson(item, rawData);
        print('res.status: $res');
        if (res.status) {
          return res;
        } else {
          throw RequestException(res.code, res.message);
        }
      }
    } else {
      // Handle onError
      print('Error ${response.statusCode}, message: ${response.statusMessage}');
      throw RequestException(response.statusCode ?? 0, response.statusMessage ?? '');
    }
  } else {
    print('done request without response');
    throw RequestException(-1, 'You may experiencing network connection issue');
  }
}

// Internet Connectiontivity
Future<bool> checkInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}
