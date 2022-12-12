import '../CoreModel/image_model.dart';
import '../Api/response.dart';

class IntroModel extends RData {
  final ImageModel? imgName;
  final String title;
  final String description;

  static final shared = IntroModel();

  IntroModel({this.imgName, this.title = '', this.description = ''});

  factory IntroModel.fromJson(Map<String, dynamic> json) {
    return IntroModel(
        imgName: ImageModel.fromJson(json['images']),
        title: json['title'] ?? '',
        description: json['description'] ?? '');
  }

  @override
  IntroModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return IntroModel.fromJson(json);
  }

  @override
  List<IntroModel> listFromJson(List? json) {
    if (json == null) return [];
    List<IntroModel> list = [];
    for (var item in json) {
      list.add(IntroModel.fromJson(item));
    }
    return list;
  }
}
