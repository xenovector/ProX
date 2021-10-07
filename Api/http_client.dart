import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:connectivity/connectivity.dart';
import 'response.dart';
import 'api_setting.dart';
import '../i18n/app_language.dart';
import '../Helper/device.dart';
import '../Core/pro_x_storage.dart' as ProXStorage;
import '../Core/extension.dart';
import '../Core/pro_x.dart';

typedef OnSuccess = void Function(String message);
typedef OnFail = Future<bool> Function(int code, String message, {Function()? tryAgain});
typedef OnGenericCallBack = void Function(String message, dynamic result);

enum STATUS { FAILED, SUCCESS }

class SocialData {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  //google or facebook
  final bool isFacebook;
  final bool isApple;

  SocialData(this.id, this.name, this.email, this.imageUrl, this.isFacebook, this.isApple);
}

// HttpMethod Enum
enum HttpMethod { get, post, put, patch, delete, multipart }

// HttpHeaderType Enum
enum HeaderType { none, standard, authorized }

// RequestTask Object
class RequestTask {
  final String urlPath;
  final Map<String, String>? parameter;
  final HeaderType headerType;
  final List<File> files;
  final String? fileField;
  final bool forceFileArray;
  final Map<String, String>? extraHeader;
  final Map<String, File>? customFileField;
  final bool ignoreHTMLerrorHandling;
  final String? preAccessToken;

  const RequestTask(
      {required this.urlPath,
      required this.parameter,
      required this.headerType,
      required this.files,
      required this.fileField,
      required this.forceFileArray,
      required this.extraHeader,
      required this.customFileField,
      required this.ignoreHTMLerrorHandling,
      required this.preAccessToken});

  factory RequestTask.set(String path,
      {Map<String, String>? body,
      HeaderType headerType = HeaderType.none,
      List<File>? files,
      String? fileField,
      bool forceFileArray = false,
      Map<String, String>? extraHeader,
      Map<String, File>? customFileField,
      bool ignoreHTMLerrorHandling = false,
      String? preAccessToken}) {
    return RequestTask(
        urlPath: path,
        parameter: body,
        headerType: headerType,
        files: files ?? [],
        fileField: fileField,
        forceFileArray: forceFileArray,
        extraHeader: extraHeader,
        customFileField: customFileField,
        ignoreHTMLerrorHandling: ignoreHTMLerrorHandling,
        preAccessToken: preAccessToken);
  }
}

// RequestTaskException
class RequestException implements Exception {
  final int code;
  final String errorMessage;

  RequestException(this.code, this.errorMessage);
}

RequestException onObjectException(Object e, OnFail onFail) {
  if (e is RequestException) {
    onFail(e.code, e.errorMessage);
    return e;
  } else if (e is TypeError) {
    String stack = e.stackTrace?.toString() ?? '';
    stack = stack.split('#')[1].substring(1).trim();
    onFail(InternalError, e.toString() + '\n\nThrowExpression\n$stack');
    return RequestException(InternalError, e.toString());
  } else {
    onFail(InternalError, e.toString());
    return RequestException(InternalError, e.toString());
  }
}

// Request Body Engine
Future<ResponseData<T>> requestFilter<T extends RData>(RequestTask request,
    {HttpMethod requestMethod = HttpMethod.post,
    bool requestRaw = false,
    bool getRawData = false,
    bool requestEndpointUrl = false}) async {
  bool noInternetion = !(await checkInternetConnection());

  if (noInternetion) {
    throw RequestException(InternalError, 'No Internet Connection, Please check your network and try again.');
  }

  var szUrl = requestRaw
      ? request.urlPath
      : requestEndpointUrl
          ? deadPoint
          : "$endPoint$apiVersion" + request.urlPath;
  //: "$endPoint" + request.urlPath;
  var body = request.parameter;
  Map<String, String> header = request.headerType == HeaderType.none
      ? {}
      : request.headerType == HeaderType.authorized
          ? {
              HttpHeaders.authorizationHeader: "Bearer ${request.preAccessToken ?? ProXStorage.accessToken.val}",
              HttpHeaders.acceptHeader: acceptHeader,
              HttpHeaders.contentTypeHeader: requestMethod == HttpMethod.multipart ? multipartHeader : contentHeader,
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

  final timeoutDuration = Duration(seconds: 60);

  Response? response;
  print('----- Request Info');
  print('url: $szUrl');
  printSuperLongText('header: $header');
  print('parameter: $body');
  print('----- End Info');
  print('Request Send --->');
  switch (requestMethod) {
    case HttpMethod.post:
      response =
          await post(Uri.parse(szUrl), body: body, headers: header).timeout(timeoutDuration).catchError((onError) {
        print('onError: $onError');
        //throw RequestException(-1, Constant.ConnectErr);
        throw RequestException(-1, onError.toString());
      });
      break;
    case HttpMethod.get:
      response = await get(Uri.parse(szUrl), headers: header).timeout(timeoutDuration).catchError((onError) {
        //throw RequestException(-1, Constant.ConnectErr);
      });
      break;
    case HttpMethod.put:
      response = await put(Uri.parse(szUrl), headers: header).timeout(timeoutDuration).catchError((onError) {
        //throw RequestException(-1, Constant.ConnectErr);
      });
      break;
    case HttpMethod.delete:
      response = await delete(Uri.parse(szUrl), headers: header).timeout(timeoutDuration).catchError((onError) {
        //throw RequestException(-1, Constant.ConnectErr);
      });
      break;
    case HttpMethod.multipart:
      final multipartRequest = MultipartRequest('POST', Uri.parse(szUrl));
      multipartRequest.headers.addAll(header);
      if (body != null) multipartRequest.fields.addAll(body);
      if (request.customFileField != null) {
        request.customFileField!.forEach((key, file) async {
          int length = await file.length();
          multipartRequest.files.add(MultipartFile(
            key,
            file.openRead(),
            length,
            filename: basename(file.path),
          ));
        });
      } else {
        if (request.files.length > 0) {
          if (request.files.length > 1 || request.forceFileArray) {
            for (int i = 0; i < request.files.length; i++) {
              File file = request.files[i];
              int length = await file.length();
              multipartRequest.files.add(MultipartFile(
                (request.fileField ?? '') + '[$i]',
                file.openRead(),
                length,
                filename: basename(file.path),
              ));
            }
          } else {
            File file = request.files[0];
            int length = await file.length();
            multipartRequest.files.add(MultipartFile(
              request.fileField ?? basename(file.path),
              file.openRead(),
              length,
              filename: basename(file.path),
            ));
          }
        }
      }
      response = await Response.fromStream(await multipartRequest.send()).catchError((onError) {
        print('multipart.onError $onError');
        throw RequestException(-1, ConnectErr);
      });
      break;
    default:
      response = null;
      break;
  }
  print('<--- Request Backed');
  if (response != null) {
    print('done request with response, statusCode: ${response.statusCode}');
    //print('Response<T>: $T');
    if (response.statusCode != 500) {
      String byteData = String.fromCharCodes(response.bodyBytes);
      //print('byteData: $byteData');
      if (byteData.contains('html>') && !request.ignoreHTMLerrorHandling) {
        throw RequestException(ServerError, byteData);
      }

      var rawData = request.ignoreHTMLerrorHandling ? byteData : jsonDecode(byteData);
      if (getRawData) {
        return ResponseData<T>(code: response.statusCode, rawData: rawData);
      } else {
        ResponseData<T> res = ResponseData<T>.fromJson(rawData);
        print('res.status: $res');
        if (res.status) {
          return res;
        } else {
          throw RequestException(res.code, res.message);
        }
      }
    } else {
      String byteData = String.fromCharCodes(response.bodyBytes);
      print('Error 500, byteData: $byteData');
      throw RequestException(response.statusCode, 'Server Error. Please try again later.');
    }
  } else {
    print('done request without response');
    throw RequestException(-1, ConnectErr);
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
