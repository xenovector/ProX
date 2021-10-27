import 'app_language.dart';
import '../Api/http_client.dart';
import '../Api/response.dart';

/* Sample json that should be return by serverside.
{
    "status": true,
    "code": 100010,
    "message": "Ok",
    "data": {
        "supported_locale": [
            "en"
        ],
        "en": {
            "name": "English",
            "version": "1.0.1",
            "labels": {
                "APP_NAME": "Bizboo",
                "GENERAL_OK": "OK",
                "GENERAL_DONE": "Done",
                "GENERAL_CONTINUE": "Continue",
                "GENERAL_CONFIRM": "Confirm",
                "GENERAL_CANCEL": "Cancel",
                "GENERAL_YES": "Yes",
                "GENERAL_NO": "No",
                "GENERAL_ALERT": "Alert",
                "GENERAL_TRY_AGAIN": "Try Again",
                "GENERAL_RECORD_NOT_FOUND": "No records found",
                "GENERAL_SUCCESS": "Success",
                "GENERAL_FAILED": "Failed",
                "GENERAL_ERROR": "Error",
                "GENERAL_ERROR_CODE_COLON_MSG": "Error %d: %s ",
                "GENERAL_ERROR_CODE_BR_MSG": "Error %d\\n%s",
                "GENERAL_INVALID_PASSWORD_FORMAT": "Invalid Password Format.",
                "GENERAL_PASSWORD_NOT_MATCH": "Password Not Match.",
                "GENERAL_INVALID_PHONE_NUMBER": "Invalid Phone Number.",
                "GENERAL_EXIT_APP": "Please click back again to exit the app.",
                "GENERAL_PERMISSION_TURN_ON": "Turn On",
                "GENERAL_PERMISSION_OPEN_SETTING": "Open Setting",
                "GENERAL_PERMISSION_TITLE": "Permission Needed.",
                "GENERAL_PERMISSION_GRANTED_TITLE": "Permission Granted.",
                "GENERAL_PERMISSION_DENIED_TITLE": "Permission Denied.",
                "PERMISSION_CAMERA_MESSAGE": "=B2&\" required camera permission in order to take picture.\"",
                "PERMISSION_LOCATION_MESSAGE": "=B2&\" required location permission in order to target your current position.\"",
                "ERROR_FORCE_UPDATE_TITLE": "Update Required",
                "ERROR_FORCE_UPDATE_DES_GOOGLE": "There is a newer version available for download! Please update the app by visiting the Play Store.",
                "ERROR_FORCE_UPDATE_DES_APPLE": "There is a newer version available for download! Please update the app by visiting the App Store.",
                "ERROR_LABEL_UPDATE": "Label Outdated.",
                "ERROR_FORCE_LOGOUT": "Force Logout.",
                "ERROR_FORCE_VERIFY_PHONE": "You are required to verify your phone number in order to continue.",
                "ERROR_SESSION_EXPIRED": "Session Expired",
                "ERROR_INTERNAL_ERROR": "Internal Error.",
                "ERROR_SERVER_ERROR": "Server Error.",
                "ERROR_MAINTENANCE": "Server Maintenance, please come back later.",
                "ERROR_REQUEST_TIMEOUT": "Connection TimeOut. Please check your internet connection.",
                "ERROR_NO_CONNECTION": "No internet connection. Please check your network connection and try again later.",
                "ERROR_SLOW_CONNECTION": "You may experience slow internet issue, sorry for keep you waiting…",
                "ERROR_TYPE_PARSING": "Parsing error. Please try again after some time."
            }
        }
    }
}
*/

extension LanguageApi on AppLanguage {
  // Fetch All Supported Language Json.
  Future<ResponseData<T>> getAllLabel<T extends RData>(OnFail onFail) async {
    final urlPath = '/languages';
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
