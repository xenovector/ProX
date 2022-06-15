import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:version/version.dart';
import 'languages.dart';

class LabelUtil {
  static LabelUtil shared = LabelUtil();

  LabelUtil();

  // find label value based on key
  String? findValue(String key) {
    List<LabelInfo> _labels = [];
    return _labels.firstWhere((item) => item.map.containsKey(key)).map[key];
  }

  // write data into .txt
  Future<File?> writeLabelInto(LabelInfo labelInfo) async {
    LabelInfo? info = await getLabelWithLocale(labelInfo.locale);
    if (info == null || Version.parse(labelInfo.version) > Version.parse(info.version)) {
      File file = await _labelFile(labelInfo.locale);
      String szData = jsonEncode(labelInfo.data);
      final completeFile = await file.writeAsString(szData);
      return completeFile;
    } else {
      return null;
    }
  }

  // get label from .txt
  Future<LabelInfo?> getLabelWithLocale(String langCode) async {
    try {
      final file = await _labelFile(langCode);

      // Read the file.
      String contents = await file.readAsString();
      final Map<String, dynamic> parsed = jsonDecode(contents);
      final String name = parsed[AppLanguage.Label_Language_Name] ?? '';
      final String imgUrl = parsed.containsKey(AppLanguage.Label_Locale_Image) ? parsed[AppLanguage.Label_Locale_Image] ?? '' : '';
      final String version = (parsed.containsKey(AppLanguage.Label_Version_Long_JsonKey) ? parsed[AppLanguage.Label_Version_Long_JsonKey] : parsed[AppLanguage.Label_Version_Short_JsonKey]) ?? '1.0.0';
      final Map<String, dynamic> map = parsed[AppLanguage.Label_MapData_JsonKey] ?? {};
      return LabelInfo(
          locale: langCode,
          name: name,
          imgUrl: imgUrl,
          version: version,
          data: parsed,
          map: map.toMapString(),
          isSelected: false);
    } catch (e) {
      print('Error_getLabelWithLocale: $e');
      return null;
    }
  }

  // get document path
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // get the label file
  Future<File> _labelFile(String langCode) async {
    final path = await _localPath;
    return File('$path/label_$langCode.txt');
  }
}
