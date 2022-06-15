import 'package:prox/ProX/Api/response.dart';

class AccessTokenModel extends RData {
  final String accessToken;

  static final shared = AccessTokenModel();

  AccessTokenModel({this.accessToken = ''});

  factory AccessTokenModel.fromJson(Map<String, dynamic> json) {
    return AccessTokenModel(accessToken: json['access_token'] ?? '');
  }

  @override
  AccessTokenModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return AccessTokenModel.fromJson(json);
  }

  @override
  List<AccessTokenModel> listFromJson(List? json) {
    if (json == null) return [];
    List<AccessTokenModel> list = [];
    for (var item in json) {
      list.add(AccessTokenModel.fromJson(item));
    }
    return list;
  }
}
