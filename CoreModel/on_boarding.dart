import 'package:prox/ProX/Api/response.dart';

class OnBoardingModel extends RData {
  final String imgName;
  final String title;
  final String message;

  static final shared = OnBoardingModel();

  OnBoardingModel({this.imgName = '', this.title = '', this.message = ''});

  factory OnBoardingModel.fromJson(Map<String, dynamic> json) {
    return OnBoardingModel(imgName: json['imgName'] ?? '', title: json['title'] ?? '', message: json['message'] ?? '');
  }

  @override
  OnBoardingModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return OnBoardingModel.fromJson(json);
  }

  @override
  List<OnBoardingModel> listFromJson(List? json) {
    if (json == null) return [];
    List<OnBoardingModel> list = [];
    for (var item in json) {
      list.add(OnBoardingModel.fromJson(item));
    }
    return list;
  }
}