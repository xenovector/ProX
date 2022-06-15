import 'package:prox/ProX/Helper/device.dart';

/// ```dart
/// // Note:
/// %s - String
/// %d - Integres
/// %f - Float
/// ```
class L {
  static var defaultKeyValue = {
    "status": true,
    "code": 100010,
    "message": "Ok",
    "data": {
      "supported_locale": ["en"],
      "en": {
        "name": "English",
        "label_version": "1.0.1",
        "labels": {
          "APP_NAME": DevicePreferences.appName,
          "GENERAL_OK": "OK",
          "GENERAL_DONE": "Done",
          "GENERAL_CONTINUE": "Continue",
          "GENERAL_CONFIRM": "Confirm",
          "GENERAL_CANCEL": "Cancel",
          "GENERAL_YES": "Yes",
          "GENERAL_NO": "No",
          "GENERAL_OH_NO": "Oh No!",
          "GENERAL_ALERT": "Alert",
          "GENERAL_TRY_AGAIN": "Try Again",
          "GENERAL_RECORD_NOT_FOUND": "Records not found",
          "GENERAL_UPDATE": "Update",
          "GENERAL_SUCCESS": "Success",
          "GENERAL_FAILED": "Failed",
          "GENERAL_ERROR": "Error",
          "GENERAL_ERROR_CODE_COLON_MSG": "Error %d: %s",
          "GENERAL_ERROR_CODE_BR_MSG": "Error %d\\n%s",
          "GENERAL_INVALID_PASSWORD_FORMAT": "Invalid Password Format.",
          "GENERAL_PASSWORD_NOT_MATCH": "Password Not Match.",
          "GENERAL_INVALID_PHONE_NUMBER": "Invalid Phone Number.",
          "GENERAL_EXIT_APP": "Please click back again to exit the app.",
          "GENERAL_EXIT_APP_DIALOG_TITLE": "Quit App",
          "GENERAL_EXIT_APP_DIALOG_MESSAGE": "Are you sure to exit the app?",
          "GENERAL_PERMISSION_TURN_ON": "Turn On",
          "GENERAL_PERMISSION_OPEN_SETTING": "Open Setting",
          "GENERAL_PERMISSION_TITLE": "Permission Needed.",
          "GENERAL_PERMISSION_GRANTED_TITLE": "Permission Granted.",
          "GENERAL_PERMISSION_DENIED_TITLE": "Permission Denied.",
          "PERMISSION_CAMERA_MESSAGE": "${DevicePreferences.appName} required camera permission in order to take picture.",
          "PERMISSION_LOCATION_MESSAGE": "${DevicePreferences.appName} required location permission in order to target your current position.",
          "ERROR_FORCE_UPDATE_TITLE_OPTIONAL": "New Version Available",
          "ERROR_FORCE_UPDATE_TITLE_REQUIRED": "Update Required",
          "ERROR_FORCE_UPDATE_DES_GOOGLE": "There is a newer version available for download! Please update the app by visiting the Play Store.",
          "ERROR_FORCE_UPDATE_DES_APPLE": "There is a newer version available for download! Please update the app by visiting the App Store.",
          "ERROR_FORCE_UPDATE_DES_HUAWEI": "There is a newer version available for download! Please update the app by visiting the App Gallery.",
          "ERROR_LABEL_UPDATE": "Label Outdated.",
          "ERROR_FORCE_LOGOUT": "Force Logout.",
          "ERROR_FORCE_VERIFY_PHONE": "You are required to verify your phone number in order to continue.",
          "ERROR_SESSION_EXPIRED_TITLE": "Session Expired",
          "ERROR_SESSION_EXPIRED_MESSAGE": "Your seesion has expired, please login again.",
          "ERROR_INTERNAL_ERROR": "Internal Error.",
          "ERROR_SERVER_ERROR": "Server Error.",
          "ERROR_MAINTENANCE_TITLE": "Maintenance In Progress",
          "ERROR_MAINTENANCE_MESSAGE": "Server is under maintenance, please come back later.",
          "ERROR_REQUEST_TIMEOUT": "Connection Timeout. Please check your internet connection.",
          "ERROR_NO_CONNECTION": "No internet connection. Please check your network connection and try again later.",
          "ERROR_SLOW_CONNECTION": "You may experience slow internet issue, sorry for keep you waiting…",
          "ERROR_TYPE_PARSING": "Parsing error. Please try again after some time.",
          "Language_Title": "Language",
          "Language_Btn_Confirm": "Confirm",
        }
      }
    }
  };

  // G. - General purpose use case and permission, capable to clone for other project.
  static const APP_NAME = 'APP_NAME';
  static const GENERAL_OK = 'GENERAL_OK';
  static const GENERAL_DONE = 'GENERAL_DONE';
  static const GENERAL_CONTINUE = 'GENERAL_CONTINUE';
  static const GENERAL_CONFIRM = 'GENERAL_CONFIRM';
  static const GENERAL_CANCEL = 'GENERAL_CANCEL';
  static const GENERAL_YES = 'GENERAL_YES';
  static const GENERAL_NO = 'GENERAL_NO';
  static const GENERAL_OH_NO = 'GENERAL_OH_NO';
  static const GENERAL_ALERT = 'GENERAL_ALERT';
  static const GENERAL_TRY_AGAIN = 'GENERAL_TRY_AGAIN';
  static const GENERAL_RECORD_NOT_FOUND = 'GENERAL_RECORD_NOT_FOUND';
  static const GENERAL_UPDATE = 'GENERAL_UPDATE';
  static const GENERAL_SUCCESS = 'GENERAL_SUCCESS';
  static const GENERAL_FAILED = 'GENERAL_FAILED';
  static const GENERAL_ERROR = 'GENERAL_ERROR';
  static const GENERAL_ERROR_CODE_COLON_MSG = 'GENERAL_ERROR_CODE_COLON_MSG';
  static const GENERAL_ERROR_CODE_BR_MSG = 'GENERAL_ERROR_CODE_BR_MSG';
  static const GENERAL_INVALID_PASSWORD_FORMAT = 'GENERAL_INVALID_PASSWORD_FORMAT';
  static const GENERAL_PASSWORD_NOT_MATCH = 'GENERAL_PASSWORD_NOT_MATCH';
  static const GENERAL_INVALID_PHONE_NUMBER = 'GENERAL_INVALID_PHONE_NUMBER';
  static const GENERAL_EXIT_APP = 'GENERAL_EXIT_APP';
  static const GENERAL_EXIT_APP_DIALOG_TITLE = 'GENERAL_EXIT_APP_DIALOG_TITLE';
  static const GENERAL_EXIT_APP_DIALOG_MESSAGE = 'GENERAL_EXIT_APP_DIALOG_MESSAGE';
  static const GENERAL_PERMISSION_TURN_ON = 'GENERAL_PERMISSION_TURN_ON';
  static const GENERAL_PERMISSION_OPEN_SETTING = 'GENERAL_PERMISSION_OPEN_SETTING';
  static const GENERAL_PERMISSION_TITLE = 'GENERAL_PERMISSION_TITLE';
  static const GENERAL_PERMISSION_GRANTED_TITLE = 'GENERAL_PERMISSION_GRANTED_TITLE';
  static const GENERAL_PERMISSION_DENIED_TITLE = 'GENERAL_PERMISSION_DENIED_TITLE';
  static const PERMISSION_CAMERA_MESSAGE = 'PERMISSION_CAMERA_MESSAGE';
  static const PERMISSION_LOCATION_MESSAGE = 'PERMISSION_LOCATION_MESSAGE';

  // E.a - Error description. (General)
  static const ERROR_FORCE_UPDATE_TITLE_OPTIONAL = 'ERROR_FORCE_UPDATE_TITLE_OPTIONAL';
  static const ERROR_FORCE_UPDATE_TITLE_REQUIRED = 'ERROR_FORCE_UPDATE_TITLE_REQUIRED';
  static const ERROR_FORCE_UPDATE_DES_GOOGLE = 'ERROR_FORCE_UPDATE_DES_GOOGLE';
  static const ERROR_FORCE_UPDATE_DES_APPLE = 'ERROR_FORCE_UPDATE_DES_APPLE';
  static const ERROR_FORCE_UPDATE_DES_HUAWEI = 'ERROR_FORCE_UPDATE_DES_HUAWEI';
  static const ERROR_LABEL_UPDATE = 'ERROR_LABEL_UPDATE';
  static const ERROR_FORCE_LOGOUT = 'ERROR_FORCE_LOGOUT';
  static const ERROR_FORCE_VERIFY_PHONE = 'ERROR_FORCE_VERIFY_PHONE';

  // E.b - Error description. (Networking)
  static const ERROR_SESSION_EXPIRED_TITLE = 'ERROR_SESSION_EXPIRED_TITLE';
  static const ERROR_SESSION_EXPIRED_MESSAGE = 'ERROR_SESSION_EXPIRED_MESSAGE';
  static const ERROR_INTERNAL_ERROR = 'ERROR_INTERNAL_ERROR';
  static const ERROR_SERVER_ERROR = 'ERROR_SERVER_ERROR';
  static const ERROR_MAINTENANCE_TITLE = 'ERROR_MAINTENANCE_TITLE';
  static const ERROR_MAINTENANCE_MESSAGE = 'ERROR_MAINTENANCE_MESSAGE';
  static const ERROR_REQUEST_TIMEOUT = 'ERROR_REQUEST_TIMEOUT';
  static const ERROR_NO_CONNECTION = 'ERROR_NO_CONNECTION';
  static const ERROR_SLOW_CONNECTION = 'ERROR_SLOW_CONNECTION';
  static const ERROR_TYPE_PARSING = 'ERROR_TYPE_PARSING';

  // Project based, follow with the format: <Page_Name/Section_Name>/<Sub_Section_If_Any>/<Label_Name>.
  static const Language_Title = 'Language_Title';
  static const Language_Btn_Confirm = 'Language_Btn_Confirm';
}
