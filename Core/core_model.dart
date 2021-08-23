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

class ImageURLs extends RData {
  final String? tn;
  final String? fs;
  final String? og;

  ImageURLs({this.tn, this.fs, this.og});

  static ImageURLs? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    Map<String, dynamic> thumbnail = json['thumbnail'];
    Map<String, dynamic> fullsize = json['fullsize'];
    Map<String, dynamic> original = json['original'];

    return ImageURLs(
      tn: thumbnail['image_with_full_url'], //['tn'],
      fs: fullsize['image_with_full_url'], //['fs'],
      og: original['image_with_full_url'], //['og'],
    );
  }

  static List<ImageURLs> listFromJson(List? json) {
    if (json == null) return [];
    List<ImageURLs> list = [];
    for (var item in json) {
      list.add(ImageURLs.fromJson(item)!);
    }
    return list;
  }
}
