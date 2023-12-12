import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uuid/uuid.dart';
import '../Core/prox_constant.dart';
import 'api_error.dart';
import 'api_setting.dart';
import 'response.dart';
import '../i18n/app_language.dart';
import '../Helper/device.dart';
import '../Core/prox_locker.dart' as locker;
import '../Core/extension.dart';

typedef OnSuccess = void Function(String message);
typedef OnFail = Future<bool> Function(int code, String title, String msg, {dynamic data, Function()? tryAgain});
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

class DioContentType {
  static const x_www_form_url_encoded = 'application/x-www-form-urlencoded';
  static const json = 'application/json';
  static const multipart = 'multipart/form-data';
}

const acceptHeader = 'application/json';
const contentHeader = 'application/x-www-form-urlencoded';
const multipartHeader = 'multipart/form-data';

// RequestTask Object
class RequestTask {
  final String uuid;
  final String urlPath;
  final Map<String, dynamic>? parameter;
  final Map<String, File>? filesField;
  final HeaderType headerType;
  final Map<String, String>? extraHeader;
  final HttpMethod requestMethod;
  final String? contentType;
  final String apiVersion;
  final bool ignoreHtmlErrorHandling;
  final String? preAccessToken;
  final bool usingRawURL;
  final bool getRawData;
  final bool isRequestingEndpoint;
  final bool showDebugResponse;

  const RequestTask(
      {required this.uuid,
      required this.urlPath,
      required this.parameter,
      required this.headerType,
      required this.filesField,
      required this.extraHeader,
      required this.requestMethod,
      required this.contentType,
      required this.apiVersion,
      required this.ignoreHtmlErrorHandling,
      required this.preAccessToken,
      required this.usingRawURL,
      required this.getRawData,
      required this.isRequestingEndpoint,
      required this.showDebugResponse});

  factory RequestTask.set(String path,
      {Map<String, dynamic>? body,
      HeaderType headerType = HeaderType.none,
      Map<String, String>? extraHeader,
      Map<String, File>? filesField,
      HttpMethod requestMethod = HttpMethod.post,
      String? contentType,
      String apiVersion = ApiSetting.defaultApiVersion,
      bool ignoreHtmlErrorHandling = false,
      String? preAccessToken,
      bool usingRawURL = false,
      bool getRawData = false,
      bool isRequestingEndpoint = false,
      bool showDebugResponse = false}) {
    return RequestTask(
      uuid: Uuid().v4(),
        urlPath: path,
        parameter: body,
        headerType: headerType,
        extraHeader: extraHeader,
        filesField: filesField,
        requestMethod: requestMethod,
        contentType: contentType,
        apiVersion: apiVersion,
        ignoreHtmlErrorHandling: ignoreHtmlErrorHandling,
        preAccessToken: preAccessToken,
        usingRawURL: usingRawURL,
        getRawData: getRawData,
        isRequestingEndpoint: isRequestingEndpoint,
        showDebugResponse: showDebugResponse);
  }
}

// Request Queue Lisst
List<String> requestList = [];

// Request Body Filter
Future<ResponseData<R>> requestFilter<R extends RData>(R item, RequestTask request) async {
  requestList.add(request.uuid);

  while (requestList[0] != request.uuid) {
    //print('request.uuid: ${request.uuid}, request.url: ${request.urlPath}');
    await Future.delayed(Duration(milliseconds: 200));
  }

  bool noInternetion = !(await checkInternetConnection());

  if (noInternetion) {
    throw RequestException(
        ApiSetting.InternalError, 'No Internet Connection, Please check your network and try again.');
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
              HttpHeaders.authorizationHeader: "Bearer ${request.preAccessToken ?? locker.accessToken.val}",
              HttpHeaders.acceptHeader: acceptHeader,
              HttpHeaders.contentTypeHeader: request.contentType ??
                  (request.requestMethod == HttpMethod.multipart ? multipartHeader : contentHeader),
              'Device-OS': DevicePreferences.platform,
              'Device-ID': DevicePreferences.deviceId,
              'App-Version': DevicePreferences.appVersion,
              'App-Locale': AppLanguage.appLocale?.languageCode.getEmptyOrNull ?? 'en',
            }
          : {
              HttpHeaders.acceptHeader: acceptHeader,
              HttpHeaders.contentTypeHeader: request.contentType ?? contentHeader,
              'Device-OS': DevicePreferences.platform,
              'Device-ID': DevicePreferences.deviceId,
              'App-Version': DevicePreferences.appVersion,
              'App-Locale': AppLanguage.appLocale?.languageCode.getEmptyOrNull ?? 'en',
            };
  if (request.extraHeader != null) {
    request.extraHeader!.forEach((key, value) {
      header[key] = value;
    });
  }

  final Dio dio = Dio(BaseOptions(
    connectTimeout: Duration(seconds: 60),
    headers: header,
  ));

  // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
  //   client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  //   return client;
  // };

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
      Map<String, dynamic> multipartRequestBody = {};
      if (body != null) {
        body.forEach((key, value) => multipartRequestBody.addAll({key: value}));
      }
      if (request.filesField != null) {
        request.filesField!.forEach((key, file) async {
          multipartRequestBody.addAll({
            key: MultipartFile.fromFileSync(file.path, filename: basename(file.path)),
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
          print('uploading file total size of: $sent/$total bytes');
        },
      ).catchError(onErrorCatched);
      break;
    default:
      response = null;
      break;
  }
  print('<--- Request Backed [$szUrl]');
  requestList.removeAt(0);
  if (response != null) {
    print('done request with statusCode: ${response.statusCode} [$szUrl]');
    if (response.statusCode == 200) {
      // dio body check
      if (request.showDebugResponse) {
        printSuperLongText('response[$szUrl]:\n${response.data}');
      }

      //var rawData = request.ignoreHtmlErrorHandling ? response.data : jsonDecode(response.data);
      if (request.getRawData) {
        return ResponseData<R>(code: response.statusCode ?? 0, rawData: response.data);
      } else {
        var res = ResponseData<R>.fromJson(item, response.data);
        //print('res.status: $res');
        if (res.status) {
          return res;
        } else {
          throw RequestException(res.code, res.message);
        }
      }
    } else {
      // Handle onError
      print('Error ${response.statusCode} [$szUrl], message: ${response.statusMessage}, data: ${response.data}');
      if (response.data.toString().startsWith('<html>') || response.data.toString().startsWith('<!DOCTYPE')) {
        throw RequestException(response.statusCode ?? 0, response.data);
      } else {
        var res = ResponseData<R>.fromJson(item, response.data, forceError: true);
        throw res.error ?? RequestException(response.statusCode ?? 0, response.data);
      }
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
