import '../Api/response.dart';

class IdNameModel extends RData {
  final String id;
  final String name;

  static final shared = IdNameModel();

  IdNameModel({this.id = '', this.name = ''});

  factory IdNameModel.fromJson(Map<String, dynamic> json) {
    return IdNameModel(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  @override
  IdNameModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return IdNameModel.fromJson(json);
  }

  @override
  List<IdNameModel> listFromJson(List? json) {
    if (json == null) return [];
    List<IdNameModel> list = [];
    for (var item in json) {
      list.add(IdNameModel.fromJson(item));
    }

    return list;
  }
}