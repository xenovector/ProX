import 'api_error.dart';

class ResponseData<R extends RData> {
  final bool status;
  final int code;
  final String title;
  final String message;
  final R? data;
  final List<R>? datas;
  final int? total;
  final dynamic rawData;
  final RequestException? error;

  const ResponseData(
      {this.status = false,
      this.code = 0,
      this.title = '',
      this.message = '',
      this.data,
      this.datas,
      this.total,
      this.rawData,
      this.error});

  factory ResponseData.fromJson(R item, Map<String, dynamic>? json, {bool forceError = false}) {
    if (json == null) return ResponseData<R>();
    //print('Response.json: $json');

    var mCode = json.containsKey('code') ? json['code'] : 0;
    var mTitle = json.containsKey('title') ? json['title'] : '';
    var mMessage = json.containsKey('message') ? json['message'] : '';

    var jsonData = json['data'];
    if (jsonData is List && jsonData.isEmpty) jsonData = null;

    bool returnStatus = json.containsKey('status')
        ? json['status']
        : json.containsKey('success')
            ? json['success']
            : true;

    R? mData;
    List<R>? mDatas;
    if (returnStatus) {
      if (jsonData is List) {
        mDatas = item.listFromJson(jsonData);
      } else {
        mData = item.fromJson(jsonData);
      }
    }

     RequestException? mError;

    if (json.containsKey('error') || forceError) {
      dynamic jsonUnknown = json.containsKey('error') ? json['error'] : json['data'];
      print('Response.dart.error: $jsonUnknown');
      Map<String, dynamic>? jsonError = {};
      if (jsonUnknown is List) {
        jsonError = jsonUnknown[0];
      } else {
        jsonError = jsonUnknown;
      }
      if (jsonError != null) {
        var firstValue = '';
        jsonError.forEach((key, value) {
          if (firstValue == '') {
            if (value is List) {
              firstValue = value.first.toString();
            } else {
              firstValue = value.toString();
            }
          }
        });
        mError = RequestException(mCode, firstValue);
      } else {
        mError = RequestException(mCode, mMessage);
      }
    }

    return ResponseData<R>(
      status: returnStatus,
      code: mCode,
      title: mTitle,
      message: mMessage,
      data: mData,
      datas: mDatas,
      error: mError,
      //total: json['total'] ?? 0,
    );
  }
}

abstract class RData {
  const RData();

  fromJson(Map<String, dynamic>? json);

  listFromJson(List? json);
}

/*
class BoolResponse {
  final bool isTrue;

  BoolResponse(this.isTrue);

  factory BoolResponse.fromJson(Map<String, dynamic>? json, {String key = 'is_true'}) {
    if (json == null) return BoolResponse(false);

    if (json[key] is bool) {
      return BoolResponse(json[key]);
    } else if (json[key] is int) {
      final value = json[key];
      if (value > 0) {
        return BoolResponse(true);
      } else {
        return BoolResponse(false);
      }
    } else {
      return BoolResponse(false);
    }
  }
}
*/