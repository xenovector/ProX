import 'languages.dart';
import '../Api/response.dart';
import '../Api/api_error.dart';

class LabelHandleError<T> {
  final T data;
  final RequestException? error;
  LabelHandleError(this.data, this.error);
}

class LabelSupport extends RData {
  final List<String> supportedLocale;
  final List<LabelInfo> labelInfoList;

  LabelSupport({required this.supportedLocale, required this.labelInfoList});

  @override
  LabelSupport? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    var localSupportedLocalJson = json[AppLanguage.Label_Support_JsonKey];

    List<String> localSupportLocal = [];
    List<LabelInfo> localLabelInfoList = [];

    if (localSupportedLocalJson is List) {
      for (var locale in localSupportedLocalJson) {
        Map<String, dynamic> localeJson = json[locale];

        var langMap = localeJson[AppLanguage.Label_MapData_JsonKey];

        if (langMap is List) {
          print("-- locale: '$locale', have empty labels --");
        } else {
          localSupportLocal.add(locale);
          LabelInfo? label = LabelInfo.fromJson(locale, localeJson.checkIsArrayEmpty);
          if (label != null) localLabelInfoList.add(label);
        }
      }
    }

    return LabelSupport(
      supportedLocale: localSupportLocal,
      labelInfoList: localLabelInfoList,
    );
  }

  @override
  listFromJson(List? json) {
    throw UnimplementedError();
  }
}

class LabelInfo {
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
    //Map<dynamic, dynamic> _mapX = json[AppLanguage.Label_MapData_JsonKey];
    //_mapX.forEach((key, value) { print('key: $key, value: $value'); });
    //print(' --- | ---');
    Map<String, dynamic> langMap = json[AppLanguage.Label_MapData_JsonKey];
    return LabelInfo(
      locale: key,
      name: json[AppLanguage.Label_Language_Name],
      imgUrl: json.containsKey(AppLanguage.Label_Locale_Image) ? json[AppLanguage.Label_Locale_Image] : '',
      version: json.containsKey(AppLanguage.Label_Version_Long_JsonKey)
          ? json[AppLanguage.Label_Version_Long_JsonKey]
          : json[AppLanguage.Label_Version_Short_JsonKey],
      data: json,
      map: langMap.toMapString(),
      isSelected: false,
    );
  }
}
