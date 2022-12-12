import 'package:flutter/foundation.dart';

// Testing
bool skipForTest = !kReleaseMode;

//General Message
const Test_Title = 'This is a test Title';
const Test_Message =
    'Lorem test text, this message is a Lorem testing message to test the UI in different length situation.';

// GoogleApiKey for Map API or Cloud API
// var googleApiKey = Platform.isIOS ? 'AIzaSyCbc01f6kjlvBICieUTTQqVwyBDwHxwQsQ' : 'AIzaSyB4GHJE6NOqo7_mquW2wCTVL05PuplUuLA';

// Social Login
/*final FacebookLogin facebookSignIn = new FacebookLogin();
final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);*/

//Preload? preload;
String? accessCode;
//bool useShadow = false;

class RegisterAndLoginMethod {
  static String get none => 'default';
  static String get apple => 'apple';
  static String get facebook => 'facebook';
  static String get google => 'google';
  static String get instagram => 'instagram';
  static String get linkedin => 'linkedin';
  static String get twitter => 'twitter';
  static String get wechat => 'wechat';
  static String get zalo => 'zalo';
}
