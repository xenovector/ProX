import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//import 'package:linkedin_login/linkedin_login.dart';
//import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//import 'package:twitter_login/twitter_login.dart';
import '../Core/pro_x.dart';
import '../Helper/hotkey.dart';
import '../Helper/sizer.dart';

class SocialLogin {
  /*static Future<void> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        print('x: ${account.email}');
      }
    } catch (error) {
      print(error);
    }
    return;
  }*/

  /*static Future<void> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
// or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      // final AccessToken accessToken = result.accessToken!;
      final Map<String, dynamic> data = await FacebookAuth.i.getUserData();

      print('email: ${data['email']}');
    } else {
      print('error.status: ${result.status}');
      print('error.message: ${result.message}');
    }
    return;
  }*/

  /*static Future<void> signInWithApple() async {
    if (Platform.isAndroid) {
      U.show.toast('Android is currently not supported Apple Login.');
      return;
    }
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    print('email: ${credential.email}');
    return;
  }*/

  /*static Future<void> signInWithTwitter() async {
    final twitterLogin = TwitterLogin(
      apiKey: 'jhHHnTlIyedRcseIxbCxdhlK8',
      apiSecretKey: 'QhwIJyTydq30w7kUw18sTW5sb7tO6jKcaJbO8V9Ti2PP7jiWea',
      redirectURI: 'stiauth://',
    );
    final authResult = await twitterLogin.loginV2();
    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        print('twitter:success');
        print('id: ${authResult.user?.id}');
        print('name: ${authResult.user?.name}');
        break;
      case TwitterLoginStatus.cancelledByUser:
         print('twitter:cancel');
        break;
      case TwitterLoginStatus.error:
         print('twitter:error: ${authResult.errorMessage}');
        break;
      default:
        break;
    }
    return;
  }*/

  /*static Future<void> signInWithLinkedin() async {
    Get.dialog(
        useSafeArea: false,
        Material(
            color: Colors.transparent,
            child: MediaQuery(
                data: Get.mediaQuery.copyWith(textScaleFactor: Sizer.textFactor),
                child: InkWell(
                    onTap: Get.back,
                    child: Center(
                      child: Container(
                        width: Get.width * 0.8,
                        height: Get.height * 0.7,
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: proXShadow),
                        child: LinkedInUserWidget(
                          destroySession: true,
                          redirectUrl: 'https://sti.elitelab404.com',
                          clientId: '86vrojrbfkzqsv',
                          clientSecret: 'ayqJHM1mWkRgje0M',
                          projection: const [
                            ProjectionParameters.id,
                            ProjectionParameters.localizedFirstName,
                            ProjectionParameters.localizedLastName,
                            ProjectionParameters.firstName,
                            ProjectionParameters.lastName,
                            ProjectionParameters.profilePicture,
                          ],
                          onError: (final UserFailedAction e) {
                            print('Error: ${e.toString()}');
                            print('Error: ${e.stackTrace.toString()}');
                          },
                          onGetUserProfile: (final UserSucceededAction linkedInUser) {
                            print(
                              'Access token ${linkedInUser.user.token.accessToken}',
                            );

                            print('User id: ${linkedInUser.user.userId}');

                            var firstName = linkedInUser.user.firstName?.localized?.label;
                            var lastName = linkedInUser.user.lastName?.localized?.label;
                            var email = linkedInUser.user.email?.elements?[0].handleDeep?.emailAddress;
                            var profileImageUrl = linkedInUser
                                .user.profilePicture?.displayImageContent?.elements?[0].identifiers?[0].identifier;
                            print('firstName: $firstName');
                            print('lastName: $lastName');
                            print('email: $email');
                            print('profileImageUrl: $profileImageUrl');

                            // setState(() {
                            //   logoutUser = false;
                            // });

                            //Navigator.pop(context);
                            Get.back();
                          },
                        ),
                      ),
                    )))));
    return;
  }*/

  static Future<void> signInWithWeChat() async {
    //
    return;
  }
}
