import '../Api/response.dart';

class NullModel extends RData {
  static final shared = NullModel();

  NullModel();

  factory NullModel.fromJson(Map<String, dynamic> json) {
    return NullModel();
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
