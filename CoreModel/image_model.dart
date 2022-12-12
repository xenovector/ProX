import '../Api/response.dart';

class ImageModel extends RData {
  final String tn;
  final String fs;
  final String og;

  static final shared = ImageModel();

  ImageModel({this.tn = '', this.fs = '', this.og = ''});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    //Map<String, dynamic> thumbnail = json['thumbnail'];
    //Map<String, dynamic> fullsize = json['fullsize'];
    //Map<String, dynamic> original = json['original'];

    return ImageModel(
      tn: json['tn'] ?? '',
      fs: json['fs'] ?? '',
      og: json['og'] ?? '',
    );
  }

  @override
  ImageModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return ImageModel.fromJson(json);
  }

  @override
  List<ImageModel> listFromJson(List? json) {
    if (json == null) return [];
    List<ImageModel> list = [];
    for (var item in json) {
      list.add(ImageModel.fromJson(item));
    }
    return list;
  }
}
