import '../Helper/device.dart';

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
      "supported_locale": ["en", "zh"],
      "en": {
        "name": "English",
        "label_version": "1.0.0",
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
          "GENERAL_OOPS": "Oops!",
          "GENERAL_ALERT": "Alert",
          "GENERAL_TRY_AGAIN": "Try Again",
          "GENERAL_RECORD_NOT_FOUND": "Records not found",
          "GENERAL_UPDATE": "Update",
          "GENERAL_LOADING": "Loading",
          "GENERAL_SUCCESS": "Success",
          "GENERAL_FAILED": "Failed",
          "GENERAL_ERROR": "Error",
          "GENERAL_ERROR_CODE_COLON_MSG": "Error %d: %s",
          "GENERAL_ERROR_CODE_BR_MSG": "Error %d\\n%s",
          "GENERAL_INVALID_PASSWORD_FORMAT": "Invalid Password Format.",
          "GENERAL_PASSWORD_NOT_MATCH": "Password Not Match.",
          "GENERAL_INVALID_PHONE_NUMBER": "Invalid Phone Number.",
          "GENERAL_EXIT_APP": "Please press back again to exit the app.",
          "GENERAL_EXIT_APP_DIALOG_TITLE": "Quit App",
          "GENERAL_EXIT_APP_DIALOG_MESSAGE": "Are you sure to exit the app?",
          "GENERAL_PERMISSION_TURN_ON": "Turn On",
          "GENERAL_PERMISSION_OPEN_SETTING": "Open Setting",
          "GENERAL_PERMISSION_TITLE": "Permission Needed.",
          "GENERAL_PERMISSION_GRANTED_TITLE": "Permission Granted.",
          "GENERAL_PERMISSION_DENIED_TITLE": "Permission Denied.",
          "GENERAL_OTP_HAS_BEEN_SENT": "Verification code has been sent.",
          "ERROR_FORCE_UPDATE_TITLE_OPTIONAL": "New Version Available",
          "ERROR_FORCE_UPDATE_TITLE_REQUIRED": "Update Required",
          "ERROR_FORCE_UPDATE_DES_GOOGLE":
              "There is a newer version available for download! Please update the app by visiting the Play Store.",
          "ERROR_FORCE_UPDATE_DES_APPLE":
              "There is a newer version available for download! Please update the app by visiting the App Store.",
          "ERROR_FORCE_UPDATE_DES_HUAWEI":
              "There is a newer version available for download! Please update the app by visiting the App Gallery.",
          "ERROR_FORCE_LOGOUT": "Force Logout.",
          "ERROR_FORCE_VERIFY_PHONE": "You are required to verify your phone number in order to continue.",
          "ERROR_LABEL_OUTDATED": "Label Outdated.",
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
          "PERMISSION_CAMERA_MESSAGE":
              "${DevicePreferences.appName} required camera permission in order to take picture.",
          "PERMISSION_LOCATION_MESSAGE":
              "${DevicePreferences.appName} required location permission in order to target your current position.",
          "CALENDAR_DIALOG_TITLE": "Choose Date",
          "CALENDAR_JAN": "Jan",
          "CALENDAR_FEB": "Feb",
          "CALENDAR_MAR": "Mar",
          "CALENDAR_APR": "Apr",
          "CALENDAR_MAY": "May",
          "CALENDAR_JUN": "Jun",
          "CALENDAR_JUL": "Jul",
          "CALENDAR_AUG": "Aug",
          "CALENDAR_SEP": "Sep",
          "CALENDAR_OCT": "Oct",
          "CALENDAR_NOV": "Nov",
          "CALENDAR_DEC": "Dec",
          "Language_Title": "Language",
          "Language_Version": "Language Pack Version: %s",
          "Language_Dialog_Title": "Switch Language",
          "Language_Dialog_Message": "Are you sure to swtich to selected language?"
        },
      },
      "zh": {
        "name": "Chinese",
        "label_version": "1.0.0",
        "labels": {
          "APP_NAME": DevicePreferences.appName,
          "GENERAL_OK": "好的",
          "GENERAL_DONE": "完成",
          "GENERAL_CONTINUE": "继续",
          "GENERAL_CONFIRM": "确认",
          "GENERAL_CANCEL": "取消",
          "GENERAL_YES": "是",
          "GENERAL_NO": "不",
          "GENERAL_OH_NO": "不好了！",
          "GENERAL_OOPS": "糟糕!",
          "GENERAL_ALERT": "警戒",
          "GENERAL_TRY_AGAIN": "再试一次",
          "GENERAL_RECORD_NOT_FOUND": "未查到有关记录",
          "GENERAL_UPDATE": "更新",
          "GENERAL_SUCCESS": "成功",
          "GENERAL_FAILED": "失败",
          "GENERAL_ERROR": "错误",
          "GENERAL_ERROR_CODE_COLON_MSG": "错误 %d: %s",
          "GENERAL_ERROR_CODE_BR_MSG": "错误 %d\\n%s",
          "GENERAL_INVALID_PASSWORD_FORMAT": "密码无效。",
          "GENERAL_PASSWORD_NOT_MATCH": "密码不匹配。",
          "GENERAL_INVALID_PHONE_NUMBER": "手机号无效",
          "GENERAL_EXIT_APP": "请再次按返回以退出应用程序。",
          "GENERAL_EXIT_APP_DIALOG_TITLE": "退出应用程序",
          "GENERAL_EXIT_APP_DIALOG_MESSAGE": "您确定要退出应用程序吗？",
          "GENERAL_PERMISSION_TURN_ON": "打开",
          "GENERAL_PERMISSION_OPEN_SETTING": "前往设置",
          "GENERAL_PERMISSION_TITLE": "权限许可",
          "GENERAL_PERMISSION_GRANTED_TITLE": "许可授予。",
          "GENERAL_PERMISSION_DENIED_TITLE": "没有权限。",
          "GENERAL_OTP_HAS_BEEN_SENT": "",
          "ERROR_FORCE_UPDATE_TITLE_OPTIONAL": "新版本已发布",
          "ERROR_FORCE_UPDATE_TITLE_REQUIRED": "需要更新",
          "ERROR_FORCE_UPDATE_DES_GOOGLE": "有更新的版本可供下载！ 请访问 Play 商店更新应用程序。",
          "ERROR_FORCE_UPDATE_DES_APPLE": "有更新的版本可供下载！ 请访问 App Store 更新应用程序.",
          "ERROR_FORCE_UPDATE_DES_HUAWEI": "有更新的版本可供下载！ 请访问 App Gallery 更新应用程序。",
          "ERROR_FORCE_LOGOUT": "强制登出",
          "ERROR_FORCE_VERIFY_PHONE": "您需要验证您的电话号码才能继续。",
          "ERROR_LABEL_OUTDATED": "语言包过期了.",
          "ERROR_SESSION_EXPIRED_TITLE": "浏览已过期",
          "ERROR_SESSION_EXPIRED_MESSAGE": "您的浏览已过期，请重新登录。",
          "ERROR_INTERNAL_ERROR": "内部错误。",
          "ERROR_SERVER_ERROR": "服务器错误。",
          "ERROR_MAINTENANCE_TITLE": "维护进行中",
          "ERROR_MAINTENANCE_MESSAGE": "服务器正在维护中，请稍后再来。",
          "ERROR_REQUEST_TIMEOUT": "连接超时。 请检查您的互联网连接。",
          "ERROR_NO_CONNECTION": "没有网络连接。 请检查您的网络连接并稍后重试。",
          "ERROR_SLOW_CONNECTION": "您可能会遇到网速慢的问题，抱歉让您久等了……",
          "ERROR_TYPE_PARSING": "系统解析错误。 请稍后再试。",
          "PERMISSION_CAMERA_MESSAGE": "${DevicePreferences.appName} 需要相机权限许可才能拍照。",
          "PERMISSION_LOCATION_MESSAGE": "${DevicePreferences.appName} 需要位置权限许可才能定位您当前的位置。",
          "CALENDAR_DIALOG_TITLE": "选择日期",
          "CALENDAR_JAN": "一月",
          "CALENDAR_FEB": "二月",
          "CALENDAR_MAR": "三月",
          "CALENDAR_APR": "四月",
          "CALENDAR_MAY": "五月",
          "CALENDAR_JUN": "六月",
          "CALENDAR_JUL": "七月",
          "CALENDAR_AUG": "八月",
          "CALENDAR_SEP": "九月",
          "CALENDAR_OCT": "十月",
          "CALENDAR_NOV": "十一月",
          "CALENDAR_DEC": "十二月",
          "Language_Title": "语言",
          "Language_Version": "语言包版本：%s",
          "Language_Dialog_Title": "切换语言",
          "Language_Dialog_Message": "确定要切换到所选语言？"
        },
      }
    }
  };

  // G. - General purpose use case and permission, capable to clone for other project.
  static const APP_NAME = "APP_NAME";
  static const GENERAL_OK = "GENERAL_OK";
  static const GENERAL_DONE = "GENERAL_DONE";
  static const GENERAL_CONTINUE = "GENERAL_CONTINUE";
  static const GENERAL_CONFIRM = "GENERAL_CONFIRM";
  static const GENERAL_CANCEL = "GENERAL_CANCEL";
  static const GENERAL_YES = "GENERAL_YES";
  static const GENERAL_NO = "GENERAL_NO";
  static const GENERAL_OH_NO = "GENERAL_OH_NO";
  static const GENERAL_OOPS = "GENERAL_OOPS";
  static const GENERAL_ALERT = "GENERAL_ALERT";
  static const GENERAL_TRY_AGAIN = "GENERAL_TRY_AGAIN";
  static const GENERAL_RECORD_NOT_FOUND = "GENERAL_RECORD_NOT_FOUND";
  static const GENERAL_UPDATE = "GENERAL_UPDATE";
  static const GENERAL_LOADING = "GENERAL_LOADING";
  static const GENERAL_SUCCESS = "GENERAL_SUCCESS";
  static const GENERAL_FAILED = "GENERAL_FAILED";
  static const GENERAL_ERROR = "GENERAL_ERROR";
  static const GENERAL_ERROR_CODE_COLON_MSG = "GENERAL_ERROR_CODE_COLON_MSG";
  static const GENERAL_ERROR_CODE_BR_MSG = "GENERAL_ERROR_CODE_BR_MSG";
  static const GENERAL_INVALID_PASSWORD_FORMAT = "GENERAL_INVALID_PASSWORD_FORMAT";
  static const GENERAL_PASSWORD_NOT_MATCH = "GENERAL_PASSWORD_NOT_MATCH";
  static const GENERAL_INVALID_PHONE_NUMBER = "GENERAL_INVALID_PHONE_NUMBER";
  static const GENERAL_EXIT_APP = "GENERAL_EXIT_APP";
  static const GENERAL_EXIT_APP_DIALOG_TITLE = "GENERAL_EXIT_APP_DIALOG_TITLE";
  static const GENERAL_EXIT_APP_DIALOG_MESSAGE = "GENERAL_EXIT_APP_DIALOG_MESSAGE";
  static const GENERAL_PERMISSION_TURN_ON = "GENERAL_PERMISSION_TURN_ON";
  static const GENERAL_PERMISSION_OPEN_SETTING = "GENERAL_PERMISSION_OPEN_SETTING";
  static const GENERAL_PERMISSION_TITLE = "GENERAL_PERMISSION_TITLE";
  static const GENERAL_PERMISSION_GRANTED_TITLE = "GENERAL_PERMISSION_GRANTED_TITLE";
  static const GENERAL_PERMISSION_DENIED_TITLE = "GENERAL_PERMISSION_DENIED_TITLE";
  static const GENERAL_OTP_HAS_BEEN_SENT = "GENERAL_OTP_HAS_BEEN_SENT";

  // E.a - Error description. (General)
  static const ERROR_FORCE_UPDATE_TITLE_OPTIONAL = 'ERROR_FORCE_UPDATE_TITLE_OPTIONAL';
  static const ERROR_FORCE_UPDATE_TITLE_REQUIRED = 'ERROR_FORCE_UPDATE_TITLE_REQUIRED';
  static const ERROR_FORCE_UPDATE_DES_GOOGLE = 'ERROR_FORCE_UPDATE_DES_GOOGLE';
  static const ERROR_FORCE_UPDATE_DES_APPLE = 'ERROR_FORCE_UPDATE_DES_APPLE';
  static const ERROR_FORCE_UPDATE_DES_HUAWEI = 'ERROR_FORCE_UPDATE_DES_HUAWEI';
  static const ERROR_FORCE_LOGOUT = 'ERROR_FORCE_LOGOUT';
  static const ERROR_FORCE_VERIFY_PHONE = 'ERROR_FORCE_VERIFY_PHONE';
  static const ERROR_LABEL_OUTDATED = 'ERROR_LABEL_OUTDATED';

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

  // P - Permission, particular custom permission dialog message.
  static const PERMISSION_CAMERA_MESSAGE = 'PERMISSION_CAMERA_MESSAGE';
  static const PERMISSION_LOCATION_MESSAGE = 'PERMISSION_LOCATION_MESSAGE';

  // C - Calendar Dialog.
  static const CALENDAR_DIALOG_TITLE = 'CALENDAR_DIALOG_TITLE';
  static const CALENDAR_JAN = 'CALENDAR_JAN';
  static const CALENDAR_FEB = 'CALENDAR_FEB';
  static const CALENDAR_MAR = 'CALENDAR_MAR';
  static const CALENDAR_APR = 'CALENDAR_APR';
  static const CALENDAR_MAY = 'CALENDAR_MAY';
  static const CALENDAR_JUN = 'CALENDAR_JUN';
  static const CALENDAR_JUL = 'CALENDAR_JUL';
  static const CALENDAR_AUG = 'CALENDAR_AUG';
  static const CALENDAR_SEP = 'CALENDAR_SEP';
  static const CALENDAR_OCT = 'CALENDAR_OCT';
  static const CALENDAR_NOV = 'CALENDAR_NOV';
  static const CALENDAR_DEC = 'CALENDAR_DEC';

  // Below all are project based, follow with the format: <Page_Name/Section_Name>/<Sub_Section_If_Any>/<Label_Name/Action>.
  static const Language_Title = 'Language_Title';
  static const Language_Version = 'Language_Version';
  static const Language_Dialog_Title = 'Language_Dialog_Title';
  static const Language_Dialog_Message = 'Language_Dialog_Message';

  //
}


