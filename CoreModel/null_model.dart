import '../Api/response.dart';

class NullModel extends RData {
  final int? id;
  static final shared = NullModel();

  NullModel({this.id});

  factory NullModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('id')) {
      return NullModel(id: json['id']);
    } else {
      return NullModel();
    }
  }

  @override
  NullModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return NullModel.fromJson(json);
  }

  @override
  List<NullModel> listFromJson(List? json) {
    if (json == null) return [];
    List<NullModel> list = [];
    for (var item in json) {
      list.add(NullModel.fromJson(item));
    }
    return list;
  }
}

class StringModel extends RData {
  static final shared = StringModel();

  StringModel();

  factory StringModel.fromJson(Map<String, dynamic> json) {
    return StringModel();
  }

  @override
  StringModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return StringModel.fromJson(json);
  }

  @override
  List<String> listFromJson(List? json) {
    if (json == null) return [];
    List<String> list = [];
    for (var item in json) {
      if (item is String) {
        list.add(item);
      }
    }
    return list;
  }
}
