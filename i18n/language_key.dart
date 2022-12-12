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
          "GENERAL_EXIT_APP": "Please press back again to exit the app.",
          "GENERAL_EXIT_APP_DIALOG_TITLE": "Quit App",
          "GENERAL_EXIT_APP_DIALOG_MESSAGE": "Are you sure to exit the app?",
          "GENERAL_PERMISSION_TURN_ON": "Turn On",
          "GENERAL_PERMISSION_OPEN_SETTING": "Open Setting",
          "GENERAL_PERMISSION_TITLE": "Permission Needed.",
          "GENERAL_PERMISSION_GRANTED_TITLE": "Permission Granted.",
          "GENERAL_PERMISSION_DENIED_TITLE": "Permission Denied.",
          "ERROR_FORCE_UPDATE_TITLE_OPTIONAL": "New Version Available",
          "ERROR_FORCE_UPDATE_TITLE_REQUIRED": "Update Required",
          "ERROR_FORCE_UPDATE_DES_GOOGLE": "There is a newer version available for download! Please update the app by visiting the Play Store.",
          "ERROR_FORCE_UPDATE_DES_APPLE": "There is a newer version available for download! Please update the app by visiting the App Store.",
          "ERROR_FORCE_UPDATE_DES_HUAWEI": "There is a newer version available for download! Please update the app by visiting the App Gallery.",
          "ERROR_LABEL_OUTDATED": "Label Outdated.",
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
          "PERMISSION_CAMERA_MESSAGE": "${DevicePreferences.appName} required camera permission in order to take picture.",
          "PERMISSION_LOCATION_MESSAGE": "${DevicePreferences.appName} required location permission in order to target your current position.",
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
          "ERROR_FORCE_UPDATE_TITLE_OPTIONAL": "新版本已发布",
          "ERROR_FORCE_UPDATE_TITLE_REQUIRED": "需要更新",
          "ERROR_FORCE_UPDATE_DES_GOOGLE":
              "有更新的版本可供下载！ 请访问 Play 商店更新应用程序。",
          "ERROR_FORCE_UPDATE_DES_APPLE":
              "有更新的版本可供下载！ 请访问 App Store 更新应用程序.",
          "ERROR_FORCE_UPDATE_DES_HUAWEI":
              "有更新的版本可供下载！ 请访问 App Gallery 更新应用程序。",
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
          "PERMISSION_CAMERA_MESSAGE":
              "${DevicePreferences.appName} 需要相机权限许可才能拍照。",
          "PERMISSION_LOCATION_MESSAGE":
              "${DevicePreferences.appName} 需要位置权限许可才能定位您当前的位置。",
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
  static const GENERAL_ALERT = "GENERAL_ALERT";
  static const GENERAL_TRY_AGAIN = "GENERAL_TRY_AGAIN";
  static const GENERAL_RECORD_NOT_FOUND = "GENERAL_RECORD_NOT_FOUND";
  static const GENERAL_UPDATE = "GENERAL_UPDATE";
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
  static const Language_Dialog_Title = 'Language_Dialog_Title';
  static const Language_Dialog_Message = 'Language_Dialog_Message';
  static const Currency_Value = 'Currency_Value';
  static const Intro_Skip_Button = 'Intro_Skip_Button';
  static const Intro_Next_Button = 'Intro_Next_Button';
  static const Intro_Start_Button = 'Intro_Start_Button';
  static const Survey_Title = 'Survey_Title';
  static const Survey_Message = 'Survey_Message';
  static const Survey_Skip_Button = 'Survey_Skip_Button';
  static const Survey_Start_Button = 'Survey_Start_Button';
  static const Suggest_Listing_Top_Title = 'Suggest_Listing_Top_Title';
  static const Suggest_Listing_Button = 'Suggest_Listing_Button';
  static const Suggest_Plan_Top_Title = 'Suggest_Plan_Top_Title';
  static const Suggest_Plan_Title = 'Suggest_Plan_Title';
  static const Suggest_Plan_Item_Title = 'Suggest_Plan_Item_Title';
  static const Suggest_Plan_Item_Description = 'Suggest_Plan_Item_Description';
  static const Suggest_Plan_Item_Button = 'Suggest_Plan_Item_Button';
  static const Suggest_Plan_Person_Bought = 'Suggest_Plan_Person_Bought';
  static const Plan_Details_Top_Title = 'Plan_Details_Top_Title';
  static const Plan_Details_Info_Title = 'Plan_Details_Info_Title';
  static const Plan_Details_Cancel_Button = 'Plan_Details_Cancel_Button';
  static const Plan_Details_Buy_Button = 'Plan_Details_Buy_Button';
  static const Level_Test_Try_Test_Button = 'Level_Test_Try_Test_Button';
  static const Level_Test_Intro_Title = 'Level_Test_Intro_Title';
  static const Level_Test_Intro_Message = 'Level_Test_Intro_Message';
  static const Level_Test_Intro_Start_Button = 'Level_Test_Intro_Start_Button';
  static const Level_Test_Intro_Dialog_Title = 'Level_Test_Intro_Dialog_Title';
  static const Question_Skip_Button = 'Question_Skip_Button';
  static const Question_Submit_Button = 'Question_Submit_Button';
  static const Question_Display_Setting_Title = 'Question_Display_Setting_Title';
  static const Question_Display_Text_Title = 'Question_Display_Text_Title';
  static const Question_Display_Pinyin_Only = 'Question_Display_Pinyin_Only';
  static const Question_Display_Text_Only = 'Question_Display_Text_Only';
  static const Question_Display_Pinyin_Text = 'Question_Display_Pinyin_Text';
  static const Question_Display_Media_Title = 'Question_Display_Media_Title';
  static const Question_Display_Media_Sound = 'Question_Display_Media_Sound';
  static const Question_Display_Media_Translate = 'Question_Display_Media_Translate';
  static const Question_Tap_To_Speak = 'Question_Tap_To_Speak';
  static const Question_Bravo = 'Question_Bravo';
  static const Question_Almost_There = 'Question_Almost_There';
  static const Question_Title_Single_Choice = 'Question_Title_Single_Choice';
  static const Question_Title_Multiple_Choice = 'Question_Title_Multiple_Choice';
  static const Question_Title_True_False = 'Question_Title_True_False';
  static const Question_Ordering_Your_Answer = 'Question_Ordering_Your_Answer';
  static const Question_Explanation_Button = 'Question_Explanation_Button';
  static const Level_Test_Result_Complete_Title = 'Level_Test_Result_Complete_Title';
  static const Level_Test_Result_Level_Result = 'Level_Test_Result_Level_Result';
  static const Level_Test_Result_Above_Standard = 'Level_Test_Result_Above_Standard';
  static const Level_Test_Result_Below_Standard = 'Level_Test_Result_Below_Standard';
  static const Level_Test_Result_Cancel_Continue = 'Level_Test_Result_Cancel_Continue';
  static const Level_Test_Result_Proceed_Continue = 'Level_Test_Result_Proceed_Continue';
  static const OTP_Request_Title = 'OTP_Request_Title';
  static const OTP_Time_Unit_Title = 'OTP_Time_Unit_Title';
  static const OTP_Dialog_Message = 'OTP_Dialog_Message';
  static const OTP_Email_Title = 'OTP_Email_Title';
  static const OTP_Email_Placeholder = 'OTP_Email_Placeholder';
  static const OTP_Email_OTP_Title = 'OTP_Email_OTP_Title';
  static const OTP_Email_Error_No_Input = 'OTP_Email_Error_No_Input';
  static const OTP_Email_Error_Invalid = 'OTP_Email_Error_Invalid';
  static const OTP_Email_Error_OTP = 'OTP_Email_Error_OTP';
  static const OTP_Mobile_Title = 'OTP_Mobile_Title';
  static const OTP_Mobile_Placeholder = 'OTP_Mobile_Placeholder';
  static const OTP_Mobile_OTP_Title = 'OTP_Mobile_OTP_Title';
  static const OTP_Mobile_Error_No_Input = 'OTP_Mobile_Error_No_Input';
  static const OTP_Mobile_Error_OTP = 'OTP_Mobile_Error_OTP';
  static const Register_Main_Title = 'Register_Main_Title';
  static const Register_Login_Button = 'Register_Login_Button';
  static const Register_Next_Step_Button = 'Register_Next_Step_Button';
  static const Register_Password_Top_Title = 'Register_Password_Top_Title';
  static const Register_Password_Main_Title = 'Register_Password_Main_Title';
  static const Register_Password_Create_Title = 'Register_Password_Create_Title';
  static const Register_Password_Create_Placeholder = 'Register_Password_Create_Placeholder';
  static const Register_Password_Confirm_Title = 'Register_Password_Confirm_Title';
  static const Register_Password_Confirm_Placeholder = 'Register_Password_Confirm_Placeholder';
  static const Register_Password_Next_Step_button = 'Register_Password_Next_Step_button';
  static const Register_Profile_Top_Title = 'Register_Profile_Top_Title';
  static const Register_Profile_Main_Title = 'Register_Profile_Main_Title';
  static const Register_Profile_Full_Name = 'Register_Profile_Full_Name';
  static const Register_Profile_Nick_Name = 'Register_Profile_Nick_Name';
  static const Register_Profile_Email = 'Register_Profile_Email';
  static const Register_Profile_Mobile = 'Register_Profile_Mobile';
  static const Register_Profile_Refer_Code = 'Register_Profile_Refer_Code';
  static const Register_Profile_Birthday = 'Register_Profile_Birthday';
  static const Register_Profile_Gender = 'Register_Profile_Gender';
  static const Register_Profile_Gender_Male = 'Register_Profile_Gender_Male';
  static const Register_Profile_Gender_Female = 'Register_Profile_Gender_Female';
  static const Register_Profile_Complete_Button = 'Register_Profile_Complete_Button';
  static const Register_Full_Complete_Title = 'Register_Full_Complete_Title';
  static const Country_Code_Placeholder = 'Country_Code_Placeholder';
  static const Country_Code_Frequent_Search_Title = 'Country_Code_Frequent_Search_Title';
  static const Login_Main_Title = 'Login_Main_Title';
  static const Login_Register_Title = 'Login_Register_Title';
  static const Login_Use_Email_Login = 'Login_Use_Email_Login';
  static const Login_Use_Mobile_Login = 'Login_Use_Mobile_Login';
  static const Login_Login_Button = 'Login_Login_Button';
  static const Login_Forget_Password_Button = 'Login_Forget_Password_Button';
  static const Login_Third_Party_Seperator = 'Login_Third_Party_Seperator';
  static const Login_Third_Party_Full_Complete_Title = 'Login_Third_Party_Full_Complete_Title';
  static const Forget_Password_Top_Title = 'Forget_Password_Top_Title';
  static const Forget_Password_Main_Title = 'Forget_Password_Main_Title';
  static const Forget_Password_Email_Title = 'Forget_Password_Email_Title';
  static const Forget_Password_Email_Placeholder = 'Forget_Password_Email_Placeholder';
  static const Forget_Password_Sent_Button = 'Forget_Password_Sent_Button';
  static const Cancel_Purchase_Top_Title = 'Cancel_Purchase_Top_Title';
  static const Cancel_Purchase_Main_Title = 'Cancel_Purchase_Main_Title';
  static const Cancel_Purcahse_Submit_Title = 'Cancel_Purcahse_Submit_Title';
  static const Cancel_Purchase_Full_Complete_Title = 'Cancel_Purchase_Full_Complete_Title';
  static const Cancel_Purchase_Full_Complete_Button = 'Cancel_Purchase_Full_Complete_Button';
  static const Confirm_Purchase_Top_Title = 'Confirm_Purchase_Top_Title';
  static const Confirm_Purchase_Payment_Title = 'Confirm_Purchase_Payment_Title';
  static const Confirm_Purchase_Method_Title = 'Confirm_Purchase_Method_Title';
  static const Confirm_Purchase_Method_Select = 'Confirm_Purchase_Method_Select';
  static const Confirm_Purchase_Method_Credit = 'Confirm_Purchase_Method_Credit';
  static const Confirm_Purchase_Method_Mix = 'Confirm_Purchase_Method_Mix';
  static const Confirm_Purchase_Method_Cash = 'Confirm_Purchase_Method_Cash';
  static const Confirm_Purchase_Voucher_Title = 'Confirm_Purchase_Voucher_Title';
  static const Confirm_Purchase_Voucher_Select = 'Confirm_Purchase_Voucher_Select';
  static const Confirm_Purchase_Voucher_Deduct = 'Confirm_Purchase_Voucher_Deduct';
  static const Confirm_Purchase_Voucher_Credit = 'Confirm_Purchase_Voucher_Credit';
  static const Confirm_Purchase_Total = 'Confirm_Purchase_Total';
  static const Confirm_Purchase_Pay_Button = 'Confirm_Purchase_Pay_Button';
  static const Confirm_Purchase_Full_Complete_Title = 'Confirm_Purchase_Full_Complete_Title';
  static const Voucher_Top_Title = 'Voucher_Top_Title';
  static const Voucher_Available_Title = 'Voucher_Available_Title';
  static const Voucher_Expired_Title = 'Voucher_Expired_Title';
  static const Voucher_Discount_Title = 'Voucher_Discount_Title';
  static const Voucher_Cash_Title = 'Voucher_Cash_Title';
  static const Voucher_Minimal_Amount = 'Voucher_Minimal_Amount';
  static const Voucher_Expired_Date = 'Voucher_Expired_Date';
  static const Voucher_Terms_And_Condition = 'Voucher_Terms_And_Condition';
  static const Voucher_Use_Button = 'Voucher_Use_Button';
  static const Tabbar_Home_Learn_Title = 'Tabbar_Home_Learn_Title';
  static const Tabbar_All_Course_Title = 'Tabbar_All_Course_Title';
  static const Tabbar_Go_Live_Title = 'Tabbar_Go_Live_Title';
  static const Tabbar_Challenge_Title = 'Tabbar_Challenge_Title';
  static const Tabbar_My_Profile_Title = 'Tabbar_My_Profile_Title';
  static const Learn_Welcome_Back_Title = 'Learn_Welcome_Back_Title';
  static const Learn_Level_Test_Title = 'Learn_Level_Test_Title';
  static const Learn_Level_Test_Message = 'Learn_Level_Test_Message';
  static const Learn_Level_Test_Action_Button = 'Learn_Level_Test_Action_Button';
  static const Learn_Bundle_Check_Button = 'Learn_Bundle_Check_Button';
  static const Learn_Bundle_Leftover_Bold_Title = 'Learn_Bundle_Leftover_Bold_Title';
  static const Learn_Bundle_Leftover_Regular_Title = 'Learn_Bundle_Leftover_Regular_Title';
  static const Learn_Bundle_New_User_Dialog_Title = 'Learn_Bundle_New_User_Dialog_Title';
  static const Learn_Bundle_New_User_Dialog_Main_Title = 'Learn_Bundle_New_User_Dialog_Main_Title';
  static const Learn_Bundle_New_User_Dialog_Leftover_Bold_Title = 'Learn_Bundle_New_User_Dialog_Leftover_Bold_Title';
  static const Learn_Bundle_New_User_Dialog_Leftover_Regular_Title = 'Learn_Bundle_New_User_Dialog_Leftover_Regular_Title';
  static const Learn_Bundle_New_User_Dialog_Reject_Button = 'Learn_Bundle_New_User_Dialog_Reject_Button';
  static const Learn_Bundle_New_User_Dialog_Accept_Button = 'Learn_Bundle_New_User_Dialog_Accept_Button';
  static const Learn_Bundle_New_User_Reject_Top_Title = 'Learn_Bundle_New_User_Reject_Top_Title';
  static const Learn_Bundle_New_User_Reject_Main_Title = 'Learn_Bundle_New_User_Reject_Main_Title';
  static const Learn_Bundle_New_User_Reject_Submit_Button = 'Learn_Bundle_New_User_Reject_Submit_Button';
  static const Learn_On_Going_Courses_Title = 'Learn_On_Going_Courses_Title';
  static const Learn_Homework_Title = 'Learn_Homework_Title';
  static const Learn_Homework_Button = 'Learn_Homework_Button';
  static const Learn_Purchased_Courses_Title = 'Learn_Purchased_Courses_Title';
  static const Learn_Purchased_Courses_View_All = 'Learn_Purchased_Courses_View_All';
  static const Learn_Dialog_Purchased_Success_Title = 'Learn_Dialog_Purchased_Success_Title';
  static const Learn_Dialog_Purchased_Success_Study_Later = 'Learn_Dialog_Purchased_Success_Study_Later';
  static const Learn_Dialog_Purchased_Success_Study_Now = 'Learn_Dialog_Purchased_Success_Study_Now';
  static const Learn_Dialog_Experience_Course_Title = 'Learn_Dialog_Experience_Course_Title';
  static const Learn_Dialog_Experience_Course_Giveup_Button = 'Learn_Dialog_Experience_Course_Giveup_Button';
  static const All_Course_Top_Title = 'All_Course_Top_Title';
  static const All_Course_Level_Test_Title = 'All_Course_Level_Test_Title';
  static const All_Course_Level_Test_Sub_Title = 'All_Course_Level_Test_Sub_Title';
  static const All_Course_Level_Test_View_All = 'All_Course_Level_Test_View_All';
  static const Course_Intro_Title = 'Course_Intro_Title';
  static const Course_Intro_Total_Classes = 'Course_Intro_Total_Classes';
  static const Course_Intro_Total_Level = 'Course_Intro_Total_Level';
  static const Course_Intro_Total_Live = 'Course_Intro_Total_Live';
  static const Course_Intro_All_Courses = 'Course_Intro_All_Courses';
  static const Course_Intro_Purchase_All_Button = 'Course_Intro_Purchase_All_Button';
  static const Module_Available_Date = 'Module_Available_Date';
  static const Module_Last_Update = 'Module_Last_Update';
  static const Module_Total_Class = 'Module_Total_Class';
  static const Module_Total_Duration = 'Module_Total_Duration';
  static const Module_Total_Live = 'Module_Total_Live';
  static const Module_Tab_Class_Intro_Title = 'Module_Tab_Class_Intro_Title';
  static const Module_Tab_Class_Syllabus_Title = 'Module_Tab_Class_Syllabus_Title';
  static const Module_Tab_Live_Class_Title = 'Module_Tab_Live_Class_Title';
  static const Module_Class_Intro_Content = 'Module_Class_Intro_Content';
  static const Module_Class_Intro_Suitable = 'Module_Class_Intro_Suitable';
  static const Module_Class_Intro_Info = 'Module_Class_Intro_Info';
  static const Module_Class_Intro_FAQ = 'Module_Class_Intro_FAQ';
  static const Module_Syllabus_Topic_Title = 'Module_Syllabus_Topic_Title';
  static const Module_Syllabus_Topic_Test = 'Module_Syllabus_Topic_Test';
  static const Module_Live_Topic_Title = 'Module_Live_Topic_Title';
  static const Module_Start_Study_Button = 'Module_Start_Study_Button';
  static const Module_Purchase_Button = 'Module_Purchase_Button';
  static const Module_Purchase_Dialog_Main_Title = 'Module_Purchase_Dialog_Main_Title';
  static const Module_Purchase_Dialog_Class_Type_Title = 'Module_Purchase_Dialog_Class_Type_Title';
  static const Module_Purchase_Dialog_Class_Type_Class_Only = 'Module_Purchase_Dialog_Class_Type_Class_Only';
  static const Module_Purchase_Dialog_Class_Type_Class_And_Live = 'Module_Purchase_Dialog_Class_Type_Class_And_Live';
  static const Module_Purchase_Dialog_Price_Type_Title = 'Module_Purchase_Dialog_Price_Type_Title';
  static const Module_Purchase_Dialog_Price_Type_Mix = 'Module_Purchase_Dialog_Price_Type_Mix';
  static const Module_Purchase_Dialog_Price_Type_Credit = 'Module_Purchase_Dialog_Price_Type_Credit';
  static const Module_Purchase_Dialog_Purchase_Button = 'Module_Purchase_Dialog_Purchase_Button';
  static const Module_Download_Extra_Learning_Material_Button = 'Module_Download_Extra_Learning_Material_Button';
  static const Module_Download_Extra_Learning_Material_Top_Title = 'Module_Download_Extra_Learning_Material_Top_Title';
  static const Module_Download_Extra_Learning_Material_Description = 'Module_Download_Extra_Learning_Material_Description';
  static const Module_Download_Extra_Learning_Material_Purchase_Button = 'Module_Download_Extra_Learning_Material_Purchase_Button';
  static const Module_Download_Extra_Learning_Material_Download_Button = 'Module_Download_Extra_Learning_Material_Download_Button';
  static const Topic_Unit_Main_Title = 'Topic_Unit_Main_Title';
  static const Topic_Unit_Title = 'Topic_Unit_Title';
  static const Unit_Bookmark_Dialog_Main_Title = 'Unit_Bookmark_Dialog_Main_Title';
  static const Unit_Bookmark_Dialog_Sub_Title = 'Unit_Bookmark_Dialog_Sub_Title';
  static const Unit_Bookmark_Dialog_Removed = 'Unit_Bookmark_Dialog_Removed';
  static const Unit_Bookmark_Dialog_Added = 'Unit_Bookmark_Dialog_Added';
  static const Unit_Display_Dialog_Main_Title = 'Unit_Display_Dialog_Main_Title';
  static const Unit_Display_Dialog_Sub_Title = 'Unit_Display_Dialog_Sub_Title';
  static const Unit_Display_Dialog_Choose = 'Unit_Display_Dialog_Choose';
  static const Unit_Display_Dialog_Result = 'Unit_Display_Dialog_Result';
  static const Unit_Start_Experience_Course_Button = 'Unit_Start_Experience_Course_Button';
  static const Unit_Section_Vocabulary = 'Unit_Section_Vocabulary';
  static const Unit_Section_Text = 'Unit_Section_Text';
  static const Unit_Section_Culture = 'Unit_Section_Culture';
  static const Unit_Section_Writing = 'Unit_Section_Writing';
  static const Unit_Section_Sentences = 'Unit_Section_Sentences';
  static const Unit_Section_Live = 'Unit_Section_Live';
  static const Unit_Section_Clip = 'Unit_Section_Clip';
  static const Unit_Section_Quiz = 'Unit_Section_Quiz';
  static const Unit_Section_Block_Dialog_Main_Title = 'Unit_Section_Block_Dialog_Main_Title';
  static const Unit_Section_Block_Dialog_Reject_Button = 'Unit_Section_Block_Dialog_Reject_Button';
  static const Unit_Section_Block_Dialog_Purchase_Button = 'Unit_Section_Block_Dialog_Purchase_Button';
  static const Unit_Rating_Dialog_Main_Title = 'Unit_Rating_Dialog_Main_Title';
  static const Unit_Rating_Dialog_Sub_Title = 'Unit_Rating_Dialog_Sub_Title';
  static const Unit_Rating_Dialog_Next_Time = 'Unit_Rating_Dialog_Next_Time';
  static const Unit_Rating_Dialog_Go_Rate = 'Unit_Rating_Dialog_Go_Rate';
  static const Unit_Rating_Dialog_No_Next_Time = 'Unit_Rating_Dialog_No_Next_Time';
  static const Section_Example = 'Section_Example';
  static const Section_Explanation = 'Section_Explanation';
  static const Section_Bookmark_Added = 'Section_Bookmark_Added';
  static const Section_Bookmark_Removed = 'Section_Bookmark_Removed';
  static const Section_Complete_Title = 'Section_Complete_Title';
  static const Section_Later_Button = 'Section_Later_Button';
  static const Section_Continue_Button = 'Section_Continue_Button';
  static const Section_Unlock_Dialog_Title_Coma = 'Section_Unlock_Dialog_Title_Coma';
  static const Section_Unlock_Dialog_Title_And = 'Section_Unlock_Dialog_Title_And';
  static const Section_Unlock_Dialog_Title_Main = 'Section_Unlock_Dialog_Title_Main';
  static const Section_Unlock_Dialog_Action_Button = 'Section_Unlock_Dialog_Action_Button';
  static const Section_Quiz_Complete_Title = 'Section_Quiz_Complete_Title';
  static const Section_Quiz_Complete_Close = 'Section_Quiz_Complete_Close';
  static const Section_Quiz_Complete_Check = 'Section_Quiz_Complete_Check';
  static const Section_Quiz_Complete_Recorrect = 'Section_Quiz_Complete_Recorrect';
  static const Section_Quiz_Complete_Redo = 'Section_Quiz_Complete_Redo';
  static const Pinyin_Top_Title = 'Pinyin_Top_Title';
  static const Pinyin_Main_Title = 'Pinyin_Main_Title';
  static const Pinyin_Sub_Title = 'Pinyin_Sub_Title';

  //
}


