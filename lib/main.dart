import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prox/login_page.dart';
import 'ProX/export.dart';
// Location
//import 'ProX/Controller/location_controller.dart';
// Notification
//import 'ProX/Controller/notification_controller.dart' as NC;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  //NC.init();
  ProXStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = ProX.customErrorWidget;
    return GetMaterialApp(
      title: 'App Name',
      theme: ThemeData(fontFamily: 'Poppins', primarySwatch: ThemeColor.swatch, accentColor: ThemeColor.main),
      initialBinding: LoadingBinding(),
      home: LoadingPage(),
    );
  }
}

class LoadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoadingController());
  }
}

class LoadingController extends GetxController {
  bool fadeVisible = false;
  bool didInit = false;
  bool showLoading = false;

  @override
  void onInit() async {
    super.onInit();
    ProX.defaultBackgroundColor = ThemeColor.background;
    ProX.setStatusBarTextColor(isWhite: false);
    ProX.setAllowedOrientation([DeviceOrientation.portraitUp]);
    ProX.onFailed = ((code, msg, {tryAgain}) async {
      if (code == ServerError) {
        //showInAppBrowser(msg, appBarTitle: L.G_ERROR.tr);
        return false;
      } else if (code == HtmlError) {
        //showInAppBrowser(msg, appBarTitle: L.G_ERROR.tr);
        return false;
      } else if (code == RequestTimeout) {
        if (tryAgain == null) {
          await showConfirmation('Error: $code, You may experience slow internet issue, please try again later.');
        } else {
          // bool res = await showConfirmCancel('Error: $code', 'You may experience slow internet issue, try again?');
          // if (res) tryAgain();
        }
        return false;
      } else if (code.endsWith(SessionExpired)) {
        await showConfirmation('Your seesion has expired, please login again.');
        //Get.offAll(LoginPage(), binding: LoginBinding());
        return false;
      } else if (code.endsWith(ForceUpdate)) {
        openForceUpdateDialog();
        return false;
      } else if (code == Maintenance) {
        //
        return false;
      }
      return true;
    });
    this.checkCredential();
  }

  @override
  void onReady() {
    super.onReady();
    this.fadeVisible = true;
    update();
  }

  void checkCredential() async {
    await DevicePreferences.init();
    //RequestException? error = await AppLanguage.init();
    //if (error != null) {
      //print('AppLanguage.init Error: ${error.errorMessage}');
      //await showConfirmationWithTitle('Error: ${error.code}', error.errorMessage, confirm: checkCredential);
      //return;
    //}
    // Preload _preload = await getPreload((code, msg, {tryAgain}) async {
    //   return true;
    // });
    // preload = _preload;
    moveToEntryPage();
  }

  void moveToEntryPage() async {
    if (!didInit)
      didInit = true;
    else {
      bool didSetLocale = AppLanguage.didSetLocale.val;
      print('didSetLocale: $didSetLocale');
      //bool isHMS = await ProX.isHMS();
      //print('isHMS: $isHMS');
      //if (!didSetLocale && AppLanguage.supportLocale!.length > 1) {
        //Get.offAll(LanguagePage(), binding: LanguageBinding());
      //} else {
        //Get.offAll(LoginPage(), binding: LoginBinding());
      //}
      Get.offAll(LoginPage(), binding: LoginPageBinding());
    }
  }
}

class LoadingPage extends StatelessWidget {
  Widget splashScreen() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // --- Decline all your widget here.
          Expanded(child: Center(), flex: 9),
          //Image.asset('assets/app_logo.png', width: 220),
          //Expanded(child: Image.asset(ProX.defaultBackgroundImageAssetsPath ?? '', fit: BoxFit.cover)),
          Expanded(child: Center(), flex: 10),
          // --- .
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: GetBuilder<LoadingController>(
            builder: (ctrl) => Stack(
                  children: [
                    // Main Loaidng Screen with fade effect.
                    Positioned.fill(
                      child: AnimatedOpacity(
                        opacity: ctrl.fadeVisible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 1200),
                        onEnd: () => ctrl.moveToEntryPage(),
                        child: Container(
                            color: ThemeColor.background,
                            height: double.infinity,
                            width: double.infinity,
                            child: splashScreen()),
                      ),
                    ),
                    // Loading Widget for initialize purpose.
                    Positioned.fill(
                        child: ctrl.showLoading
                            ? Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.black26,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ))
                            : Center()),
                  ],
                )));
  }
}
