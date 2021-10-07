import 'http_client.dart';
import 'response.dart';

// Example
//`
Future<RData?> getExample(OnFail onFail) async {
  final urlPath = '';
  var request = RequestTask.set(urlPath, headerType: HeaderType.standard);
  try {
    ResponseData<RData> response = await requestFilter<RData>(request);
    return response.data;
  } catch (e) {
    onObjectException(e, onFail);
    return null;
  }
}
//`

