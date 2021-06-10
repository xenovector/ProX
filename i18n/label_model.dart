import 'languages.dart';
import '../Api/http_client.dart';
import '../Api/response.dart';

class LabelHandleError<T> {
  final T data;
  final RequestException? error;
  LabelHandleError(this.data, this.error);
}

class LabelSupport extends RData {
  final List<String> supportedLocale;
  final List<LabelInfo> labelInfoList;

  LabelSupport({required this.supportedLocale, required this.labelInfoList});

  static LabelSupport? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    var _supportedLocalJson = json[AppLanguage.Label_Support_JsonKey];
    List<String> _supportLocal = [];
    if (_supportedLocalJson is List) {
      for (var _locale in _supportedLocalJson) {
        _supportLocal.add(_locale);
      }
    }
    List<LabelInfo> _labelInfoList = [];
    for (String langCode in _supportLocal) {
      LabelInfo? label = LabelInfo.fromJson(langCode, json[langCode]);
      if (label != null) _labelInfoList.add(label);
    }
    return LabelSupport(
      supportedLocale: _supportLocal,
      labelInfoList: _labelInfoList,
    );
  }
}

class LabelInfo extends RData {
  String locale;
  final String name;
  final String imgUrl;
  final String version;
  final Map<String, dynamic> data;
  final Map<String, String> map;
  bool isSelected;

  LabelInfo(
      {this.locale = '',
      required this.name,
      required this.imgUrl,
      required this.version,
      required this.data,
      required this.map,
      this.isSelected = false});

  static LabelInfo? fromJson(String key, Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    Map<String, dynamic> _map = json[AppLanguage.Label_MapData_JsonKey];
    return LabelInfo(
      locale: key,
      name: json[AppLanguage.Label_Language_Name],
      imgUrl: json[AppLanguage.Label_Locale_Image],
      version: json[AppLanguage.Label_Version_JsonKey],
      data: json,
      map: _map.toMapString(),
      isSelected: false,
    );
  }
}


