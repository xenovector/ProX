// You can set your api network setting and custom error code here.
import 'package:flutter/foundation.dart';

const ConnectErr = 'You may experiencing connection issue';

//General Error Code
const ForceUpdate = 999; //end with
const LabelUpdate = 998; // end with
const ForceLogout = 996; // end with
const SessionExpired = 61; // end with
const ServerError = 500;
const InternalError = 0;
const HtmlError = 500500;
const NoInternet = 12029;
const RequestTimeout = 408;
const Maintenance = 503;

// To get the endpoint for staging and production environment
const deadPoint = '';

// API config
String get endPoint {
  if (kReleaseMode) {
    // Live endpoint
    return 'https://domes-packaging.elitelab101.com/api';
  } else {
    // Stag endpoint
    return 'https://domes-packaging.elitelab101.com/api';
  }
}
const apiVersion = '/v1';
const encrypt_response = "1";
const acceptHeader = "application/json";
const contentHeader = 'application/x-www-form-urlencoded';
const multipartHeader = 'multipart/form-data';
const versionType = 'app';
