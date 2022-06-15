// API config
// You can set your api network setting and custom error code here.

class ApiSetting {
  // Deadly fixed endpoint.
  static const deadPoint = '';

// Endpoint based on environment.
  static String endPoint = '';

// API version, e.g. 'v1'.
  static const defaultApiVersion = '/v1';

//General Error Code
  static const RequestTimeout = 408;
  static const Maintenance = 503;
  static const ServerError = 500;
  static const InternalError = 12004;

// ----- ----- ----- -----

  static const SessionExpired = 995; // end with
  static const ForceVerifyPhone = 997; // end with
  static const ForceLogout = 996; // end with
  static const LabelUpdate = 998; // end with
  static const ForceUpdate = 999; //end with

  /*String get endPoint {
    if (kReleaseMode) {
      // Live endpoint
      return 'https://put-your-live-endpoint-here.com/api';
    } else {
      // Stag endpoint
      return 'https://put-your-stag-endpoint-here.com/api';
    }
  }*/
}
