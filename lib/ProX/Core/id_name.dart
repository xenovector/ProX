import '../Api/response.dart';

class IdName extends RData {
  final String? id;
  final String? name;

  IdName({this.id, this.name});

  static IdName? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return IdName(id: json['id'], name: json['name']);
  }

  /*factory IdName.fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return IdName(id: json['id'], name: json['name']);
  }*/

  static List<IdName> listFromJson(List? json) {
    if (json == null) return [];
    List<IdName> list = [];
    for (var item in json) {
      list.add(IdName.fromJson(item)!);
    }
    return list;
  }
}


