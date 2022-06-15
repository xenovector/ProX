import 'dio_client.dart';

abstract class RData {
  const RData();

  fromJson(Map<String, dynamic>? json);

  listFromJson(List? json);
}
class ResponseData<R extends RData> {
  final bool status;
  final int code;
  final String message;
  final R? data;
  final List<R>? datas;
  final int? total;
  final dynamic rawData;
  final RequestException? error;

  const ResponseData({this.status = false, this.code = 0, this.message = '', this.data, this.datas, this.total, this.rawData, this.error});

  factory ResponseData.fromJson(R item, Map<String, dynamic>? json) {
    if (json == null) return ResponseData<R>();
    //print('Response.json: $json');

    var jsonData = json['data'];
    if (jsonData is List && jsonData.isEmpty) jsonData = null;

    bool _status = json.containsKey('status')
        ? json['status']
        : json.containsKey('success')
            ? json['success']
            : true;

    R? mData;
    List<R>? mDatas;
    if (_status) {
      if (jsonData is List) {
        mDatas = item.listFromJson(jsonData);
      } else {
        mData = item.fromJson(jsonData);
      }
    }

    return ResponseData<R>(
      status: _status,
      code: json.containsKey('code') ? json['code'] : 0,
      message: json.containsKey('message') ? json['message'] : '',
      data: mData,
      datas: mDatas,
      //total: json['total'] ?? 0,
    );
  }
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