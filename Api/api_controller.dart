import '../model/preload.dart';
import '../CoreModel/core_model.dart';
import 'api_error.dart';
import 'dio_client.dart';

///
/// ### Api Naming Tips:
///
/// Action[get/update/delete] + PurposeObject[Login/UserProfile/Order]
///
/// #### For example:
/// 1) getLogin
/// 2) updateUserProfile
/// 3) deleteOrder
///
class Api {

  // Example
  static Future<NullModel?> getExample(OnFail onFail) async {
    const urlPath = '_YOUR_URL_HERE_';
    var request = RequestTask.set(urlPath, headerType: HeaderType.standard);
    try {
      var response = await requestFilter<NullModel>(NullModel(), request);
      return response.data;
    } catch (e) {
      onObjectException(e, onFail);
      return null;
    }
  }

  // Declare Your Api Here...

  //
  static Future<Preload?> getPreload(OnFail onFail) async {
    const urlPath = '/preload';
    var request = RequestTask.set(urlPath, headerType: HeaderType.standard);
    try {
      var response = await requestFilter<Preload>(Preload(), request);
      return response.data;
    } catch (e) {
      onObjectException(e, onFail);
      return null;
    }
  }



}