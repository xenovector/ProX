import 'http_client.dart';
import '../i18n/label_model.dart';
import '../model/preload.dart';
import '../model/user.dart';


class ResponseData<R extends RData> {
  final bool status;
  final int code;
  final String message;
  final R? data;
  final List<R>? datas;
  final int? total;
  final RequestException? error;

  const ResponseData({this.status = false, this.code = 0, this.message = '', this.data, this.datas, this.total, this.error});

  factory ResponseData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ResponseData<R>();
    //print('Response.json: $json');

    var jsonData = json['data'];
    if (jsonData is List && jsonData.length == 0) jsonData = null;

    R? mData;
    List<R>? mDatas;
    switch (R) {
      case AccessToken:
        mData = AccessToken.fromJson(jsonData) as R;
        break;
      case BoolResponse:
        mData = BoolResponse.fromJson(jsonData) as R;
        break;
      case LabelSupport:
        mData = LabelSupport.fromJson(jsonData) as R;
        break;
      case LabelInfo:
        mData = LabelInfo.fromJson('', jsonData) as R;
        break;
      case UserJson:
        mData = UserJson.fromJson(jsonData) as R;
        break;
      case UserItem:
        mData = UserItem.fromJson(jsonData) as R;
        break;
      case Preload:
        mData = Preload.fromJson(jsonData) as R;
        break;
      default:
        break;
    }
    return ResponseData<R>(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      data: mData,
      datas: mDatas,
      //total: json['total'] ?? 0,
    );
  }
}

abstract class RData {
  //const RData();
}

class AccessToken {
  final String accessToken;

  AccessToken(this.accessToken);

  factory AccessToken.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AccessToken('');
    return AccessToken(json['access_token']);
  }
}

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
