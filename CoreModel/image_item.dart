import '../Api/response.dart';

class ImageItemModel extends RData {
  final String? tn;
  final String? fs;
  final String? og;

  static final shared = ImageItemModel();

  ImageItemModel({this.tn, this.fs, this.og});

  factory ImageItemModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> thumbnail = json['thumbnail'];
    Map<String, dynamic> fullsize = json['fullsize'];
    Map<String, dynamic> original = json['original'];

    return ImageItemModel(
      tn: thumbnail['image_with_full_url'], //['tn'],
      fs: fullsize['image_with_full_url'], //['fs'],
      og: original['image_with_full_url'], //['og'],
    );
  }

  @override
  ImageItemModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return ImageItemModel.fromJson(json);
  }

  @override
  List<ImageItemModel> listFromJson(List? json) {
    if (json == null) return [];
    List<ImageItemModel> list = [];
    for (var item in json) {
      list.add(ImageItemModel.fromJson(item));
    }
    return list;
  }
}
