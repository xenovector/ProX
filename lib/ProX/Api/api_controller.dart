import 'http_client.dart';
import 'response.dart';
import '../model/preload.dart';


// Example
//`
Future<ResponseData<RData>?> getData(OnFail onFail) async {
  final urlPath = '';
  var request = RequestTask.set(urlPath, headerType: HeaderType.standard);
  try {
    ResponseData<RData> response = await requestFilter<RData>(request, HttpMethod.get);
    return response;
  } catch (e) {
    onObjectException(e, onFail);
    return null;
  }
}
//`

Future<Preload?> getPreload(OnFail onFail) async {
  final urlPath = '/preload';
  var request = RequestTask.set(urlPath, headerType: HeaderType.standard);
  try {
    ResponseData<Preload> response = await requestFilter<Preload>(request, HttpMethod.post);
    return response.data;
  } catch (e) {
    onObjectException(e, onFail);
    return null;
  }
}

/*Future<UserItem> getLogin(String email, String pw, OnFail onFail, Function() tryAgain) async {
  final urlPath = '/login';
  Map<String, String> body = {
    'email': email,
    'password': pw,
  };
  var request = RequestTask.set(urlPath, body, HeaderType.standard);
  try {
    ResponseData<UserJson> response = await requestFilter<UserJson>(request, HttpMethod.post);
    accessToken.val = response.data.accessToken;
    return response.data.user;
  } catch (e) {
    onFail(e.code, e.errorMessage, tryAgain: tryAgain);
    return null;
  }
}*/
