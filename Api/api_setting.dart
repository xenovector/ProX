// You can set your api network setting and custom error code here.
import 'package:flutter/foundation.dart';


//General Error Code
const RequestTimeout = 408;
const Maintenance = 503;
const ServerError = 500;
const InternalError = 12004;

// ----- ----- ----- -----

const SessionExpired =  995; // end with
const ForceVerifyPhone = 997; // end with
const ForceLogout = 996; // end with
const LabelUpdate = 998; // end with
const ForceUpdate = 999; //end with


// To get the endpoint for staging and production environment
const deadPoint = '';

const ConnectErr = 'You may experiencing network connection issue';

// API config
String get endPoint {
  if (kReleaseMode) {
    // Live endpoint
    return 'https://put-your-live-endpoint-here.com/api';
  } else {
    // Stag endpoint
    return 'https://put-your-stag-endpoint-here.com/api';
  }
}
const apiVersion = '/v1';
const encrypt_response = "1";
const acceptHeader = "application/json";
const contentHeader = 'application/x-www-form-urlencoded';
const multipartHeader = 'multipart/form-data';
const versionType = 'app';
