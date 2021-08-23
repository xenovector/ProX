import 'app_language.dart';
import '../Api/http_client.dart';
import '../Api/response.dart';

extension LanguageApi on AppLanguage {
  // Fetch All Supported Language Json.
  Future<ResponseData<T>> getAllLabel<T extends RData>(OnFail onFail) async {
    final urlPath = '/language';
    var request = RequestTask.set(urlPath, headerType: HeaderType.standard);
    try {
      ResponseData<T> response = await requestFilter<T>(request);
      return response;
    } catch (e) {
      return ResponseData<T>(error: onObjectException(e, onFail));
    }
  }

  // Fetch Single Language Json base on given Locale.
  /*Future<ResponseData<T>> getLabelWith<T extends RData>(String locale, OnFail onFail) async {
    final urlPath = '/language/libraries';
    Map<String, String> body = {"iso_code": locale};
    var request = RequestTask.set(urlPath, body: body, headerType: HeaderType.standard);
    try {
      ResponseData<T> response = await requestFilter<T>(request);
      return response;
    } catch (e) {
      return ResponseData<T>(error: onObjectException(e, onFail));
    }
  }*/
}
