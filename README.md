# ProX

![](https://img.shields.io/badge/Awesome-Flutter-blue)
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/xenovector/ProX?color=blue&label=tag&logo=v0.0.5&logoColor=orange)
![](https://img.shields.io/badge/-Null%20Safety-red)


### ProX is a ready setup project template rely on GetX.

<br/>

## Setup
With project setup guide, making ProX capable for both big and small project usage. <br />
**But sorry, you have to manually set it up.** <br />
Download and drop `ProX` into `/lib` folder in your project.

 <!-- #### Cocoapods
DexterSwift is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:
```
pod 'DexterSwift'
``` -->
<br />

### Instruction
#### Inside your /lib, create a new folder named 'Environment' and create a new file named 'main_dev.dart'. You may have 'main_uat.dart' or 'main_prod.dart' to manage your project environment.
```dart
import '../ProX/Core/app_config.dart';
import '../app.dart';

void main() {
  var configuredApp = const AppConfig(
    appName: 'Your Project DEV',
    stagName: 'development',
    apiBaseUrl: 'https://dev-api.example.com/',
    child: MyApp(),
  );

  run(configuredApp);
}
```

#### Renamed 'main.dart' into 'app.dart' and overwrite the whole content into below example code.
```dart
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:version/version.dart';
import 'ProX/Core/app_config.dart';
import 'ProX/export.dart';
// Notification
//import 'ProX/Controller/notification_controller.dart';
// Location
//import 'ProX/Controller/location_controller.dart';

void run(Widget app) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ProXStorage.init();
  await DevicePreferences.init();

  if (Platform.isAndroid && Version.parse(DevicePreferences.osVersion) < Version.parse('7.2')) {
    ByteData data = await PlatformAssetBundle().load('lib/ProX/Assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
  }

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: DevicePreferences.androidSdkVersion < 29 ? S.color.main : Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark));
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge).then(
    (_) => runApp(app),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Configuration about App.
    var config = AppConfig.of(context)!;
    ApiSetting.endPoint = config.apiBaseUrl;
    ErrorWidget.builder = ProX.customErrorWidget;

    // MaterialApp.
    return GetMaterialApp(
      title: config.appName,
      theme: S.color.themeData,
      initialBinding: LoadingBinding(config),
      home: LoadingPage(),
    );
  }
}

class LoadingBinding extends Bindings {

  final AppConfig config;

  LoadingBinding(this.config);

  @override
  void dependencies() {
    Get.put(LoadingController(config));
  }
}

class LoadingController extends ProXController {
  final AppConfig config;

  LoadingController(this.config);

  bool fadeVisible = false;
  bool didInit = false;
  bool showLoading = false;

  @override
  void onInit() async {
    super.onInit();

    // Overwrite Your default background color if needed.
    /*ProX.defaultBackgroundColor = S.color.background;*/

    // Overwrite Your default loading screen if needed.
    /*ProX.defaultLoadingWidget = Opacity(
      opacity: 1,
      child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: Center(child: Lottie.asset('assets/lottie/loading.json', width: Get.width * 0.65))),
    );*/

    // And much more to overwrite.
    ProX.setStatusBarTextColor(isWhite: false);
    ProX.setAllowedOrientation([DeviceOrientation.portraitUp]);
    ProX.onFailed = ((code, msg, {tryAgain}) async {
      if (code == ApiSetting.ServerError) {
        //showInAppBrowser(msg, appBarTitle: L.G_ERROR.tr);
        return false;
      } else if (code == ApiSetting.RequestTimeout) {
        await U.show.nativeDialog('Error: $code', 'You may experience slow internet issue, please try again later.');
        if (tryAgain != null) tryAgain();
        return false;
      } else if (code.endsWith(ApiSetting.SessionExpired) || code.endsWith(ApiSetting.ForceLogout)) {
        accessToken.val = '';
        await U.show.nativeDialog(L.ERROR_SESSION_EXPIRED_TITLE.tr, L.ERROR_SESSION_EXPIRED_MESSAGE.tr);
        Get.back();
        return false;
      } else if (code.endsWith(ApiSetting.ForceUpdate)) {
        U.show.forceUpdateDialog(true);
        return false;
      } else if (code == ApiSetting.Maintenance) {
        U.show.nativeDialog(L.ERROR_MAINTENANCE_TITLE.tr, L.ERROR_MAINTENANCE_MESSAGE.tr);
        return false;
      } else if (code == ApiSetting.InternalError) {
        U.show.nativeDialog('Error: $code', msg);
        return false;
      }
      return true;
    });
  }

  @override
  void onReady() async {
    super.onReady();
    Sizer.init();

    bool jailbroken = await FlutterJailbreakDetection.jailbroken;
    print('jailbroken: $jailbroken');

    if (accessToken.val == '' || stagName.val != config.stagName) {
      //var guest = await Api.getGuestData(onFailed);
      /*if (guest != null) {
        accessToken.val = guest.token;
        stagName.val = config.stagName;
      }*/
    }
    checkCredential();
  }

  @override
  Future<bool> onFailed(int code, String msg, {Function()? tryAgain}) async {
    U.show.nativeDialog('Error: $code', msg);
    return true;
  }

  void checkCredential() async {
    var error = await AppLanguage.init(isDefault: true);
    if (error != null) {
      if (kDebugMode) print('-- AppLanguage.init Error: ${error.errorMessage}');
    }

    // await getAppSetting(onFailed); [e.g. phone number prefix, bank name, state list]

    // moveToEntryPage();
  }

}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  Widget splashScreen(LoadingController ctrl) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // --- Decline all your widget here.
        Expanded(child: Center(), flex: 9),
        FlutterLogo(size: 180),
        //Image.asset('assets/app_logo.png', width: 220),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () async {
            print('Hello World!');
            //ctrl.isLoading(true);
            //await Api.getPreload(ctrl.onFailed);
            //ctrl.isLoading(false);
            //Get.to(PresenterPage(), binding: PresenterBinding());
          },
          child: Container(padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6), child: Text('Test')),
        ),
        Expanded(child: Center(), flex: 10),
        // --- .
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProXWidget<LoadingController>(
      customBackgroundColor: S.color.main,
      builder: (ctrl) => Center(
        child: Image.asset('assets/splash.png', fit: BoxFit.contain, width: Get.width * 0.65),
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return ProXWidget<LoadingController>(
          builder: (ctrl) => Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    // Main Loaidng Screen with fade effect.
                    Positioned.fill(
                      child: AnimatedOpacity(
                        opacity: ctrl.fadeVisible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 1200),
                        onEnd: () => ctrl.moveToEntryPage(),
                        child: splashScreen(ctrl),
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
                ),
              ),
    );
  }*/
}

```
<br />

#### flutter run -t /lib/environment/main_Dev.dart, and u are good to go. (Remember flutter pub get for the used packages, kindly refer documents below.)

### Useful Utilities
```dart
// Override the scary red Error Widget
ErrorWidget.builder = ProX.customErrorWidget;
// Override Default Background, default is white.
ProX.defaultBackgroundColor = ThemeColor.background;
// Override Default Loading Widget, there is a default one, is ok to leave it blank.
ProX.defaultLoadingWidget = Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.black26,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                ));
// Set Status Bar Text Color.
ProX.setStatusBarTextColor(isWhite: true);
// Set Status Bar Background Color, usually I don use it because I most of the widget I defined are safeArea top = false.
ProX.setStatusBarBackground(Colors.blue);
// Set Allowed Orientation.
ProX.setAllowedOrientation([DeviceOrientation.portraitUp]);
// bool, check device service is running on HMS (huawei service) or not.
bool isHMS = await ProX.isHMS():
// bool, check device service is running on GMS (google service) or not.
bool isGMS = await ProX.isGMS():
// Setting app id for iOS and HMS would make you effortless to call openAppStore() or openForceUpdateDialog(), which redirect user to the store accordingly.
String iosAppID = 'e.g. 123456789'
String hmsAppID = 'e.g. 123456789'

// U stands for Utilities.
// Anything u want to show just call U.show.
U.show.nativeDialog('Title', 'Message');
U.show.forceUpdateDialog();
```
<br />

### Error Handling
```dart
@override
Future<bool> onFailed(int code, String msg, {Function()? tryAgain}) async {
  isLoading(false);
  bool handlePrivately = await super.onFailed(code, msg, tryAgain: tryAgain);
  if (handlePrivately) await U.show.nativeDialog('Error: $code', msg);
  return handlePrivately;
}
```
<br />

### WillPop Handling
```dart
@override
Future<bool> onHandleWillPop() {
  // Your handling goes here...
  return super.onHandleWillPop();
}
```
<br />

## pubspec.yaml
This project template using not only getx but many other plugin as well, below we listed out all the required plugin used by ProX and also some guideline on how to include asset in your flutter project as well as custom font.

<details><summary><strong>ProX Required</strong></summary>

```yaml
  get:
  get_storage:
  intl:
  path:
  package_info_plus:
  device_info_plus:
  connectivity_plus:
  dio:
  sprintf:
  lottie:
  version:
  event_bus:
  path_provider:
  url_launcher:
  app_settings:
  huawei_hmsavailability:
  flutter_statusbarcolor_ns:
  flutter_inappwebview:
  flutter_keyboard_visibility:
  extended_image:
  audioplayers:
  flutter_vibrate:
  auto_size_text:
  permission_handler:
  flutter_dialogs:
  share_plus:
  uuid:
  carousel_slider:
  flutter_native_splash:
  smooth_page_indicator:
  pin_code_fields:
  uni_links:
  flutter_jailbreak_detection:
  sticky_headers:

  # --- listing use ---
  pull_to_refresh:
  flutter_slidable:
  # --- ------- --- ---

  # --- camera use ---
  camera:
  image_picker:
  file_picker:
  pinch_zoom:
  native_device_orientation:
  align_positioned:
  image:
  image_editor:
  # --- ------ --- ---

  # --- location use ---
  location:
  huawei_location:
  geocoding:
  google_maps_flutter:
  huawei_map:
  # --- -------- --- ---

  # --- push notification and firebase ---
  # onesignal_flutter:
  firebase_core:
  firebase_messaging:
  firebase_crashlytics:
  firebase_analytics:
  huawei_push:
  flutter_fgbg:
  # --- ---- ------------ --- -------- ---

  # --- social media login ---
  # google_sign_in:
  # flutter_facebook_auth:
  # sign_in_with_apple:
  # linkedin_login:
  # twitter_login:
  # --- ------ ----- ----- ---

  # --- Game Development use ---
  # flame:
  # flame_splash_screen:
  # --- ---- ----------- --- ---

  # list project base plugin here:

  # modal_bottom_sheet:
  # smooth_page_indicator:
  # pin_code_fields:
  # qr_code_scanner:
  # qr_flutter:
  # carousel_slider:
  # cool_dropdown:
  # gallery_saver:
  # google_place:
  # menu_button:
  # open_file:
  # flutter_switch:
  # flutter_swiper:
  # flutter_xlider:
  # flutter_html:
  # fl_chart:

# Defined your native splash screen if you have one.
# After defined, run command: "flutter pub run flutter_native_splash:create".
# flutter_native_splash:
    # color: "#2ED876"
    # background_image: "assets/splash_bg.png"
    # image: "assets/splash.png"
    # android_gravity: fill
    # fullscreen: true
```
```yaml
assets:
    - lib/ProX/Assets/
    - lib/ProX/Assets/ca/
    - lib/ProX/Assets/lottie/
```
<br />

</details>

<details><summary><strong>Include asset files and custom font example</strong></summary>

```yaml
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  # assets:
  assets:
    - lib/ProX/Assets/
    - lib/ProX/Assets/ca/
    - lib/ProX/Assets/lottie/
    - assets/
    - assets/images/
    - assets/icon/
    - assets/lottie/
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/assets-and-images/#resolution-aware.

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/assets-and-images/#from-packages

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  fonts:
    - family: Poppins
      fonts:
        - asset: font/Poppins-Regular.otf
        - asset: font/Poppins-Italic.otf
          style: italic
        - asset: font/Poppins-Medium.otf
        - asset: font/Poppins-MediumItalic.otf
          style: italic
        - asset: font/Poppins-SemiBold.otf
        - asset: font/Poppins-SemiBoldItalic.otf
          style: italic
        - asset: font/Poppins-Bold.otf
        - asset: font/Poppins-BoldItalic.otf
          style: italic
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/custom-fonts/#from-packages
```
<br />

</details>
<br />

## Native Side Setup
Make sure you included services file such as <br />

`google-services.json` for Google <br />
`GoogleServices-Info.plist` for Apple <br />
`agconnect-services.json` for Huawei <br />

<br />

> **Android:** follow below steps will do.

<details><summary><strong>Step 1:</strong></summary>

create a `key.properties` file and put at `/android`, and add the following:
```properties
storePassword=ProjectStorePassword
keyPassword=ProjectKeyPassword
keyAlias=ProjectKeyAlias
storeFile=key.jks
```
**Bad Tips but I still did:** Usually ProjectStorePassword & ProjectKeyPassword I will put the same string.
<br />

</details>

<details><summary><strong>Step 2:</strong></summary>

open terminal and execute below commend:
```
keytool -genkey -v -keystore ./android/app/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias <key-name>
```

**Reminder:** Replace `<key-name>` with ProjectKeyAlias.

Once you did that, commend out `key.properties` in the your `/android/.gitgnore` in order commit your key details into your private git.

<br />

</details>

<details><summary><strong>Step 3:</strong></summary>

in `/android/build.gradle` , add those which mark with `*`.

```swift
buildscript {
    ext.kotlin_version = '1.6.10' //<-- change it from '1.3.50'
    repositories {
        google()
        mavenCentral()
  //*   maven { url 'https://developer.huawei.com/repo/' }
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.2.0'
        // START: FlutterFire Configuration
  //*   classpath 'com.google.gms:google-services:4.3.10'
  //*   classpath 'com.google.firebase:firebase-crashlytics-gradle:2.8.1'
        // END: FlutterFire Configuration
        classpath 'org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version'
  //*   classpath 'com.huawei.agconnect:agcp:1.4.1.300'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
  //*   maven { url 'https://developer.huawei.com/repo/' }
    }
}
```

in `/android/app/build.gradle`, add:

```swift

apply plugin: 'com.android.application'
// START: FlutterFire Configuration
// apply plugin: 'com.google.gms.google-services'
// apply plugin: 'com.google.firebase.crashlytics'
// END: FlutterFire Configuration
// apply plugin: 'com.huawei.agconnect'
apply plugin: 'kotlin-android'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"

def keystorePropertiesFile = rootProject.file("key.properties")
def keystoreProperties = new Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {

    compileSdkVersion 33

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
      minSdkVersion 22
    }

    signingConfigs {
        config {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        debug {
            signingConfig signingConfigs.config
        }
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig signingConfigs.config
            minifyEnabled true   // Obfuscate and minify codes
            shrinkResources true // Remove unused resources
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

<br />

</details>

<details><summary><strong>Step 4:</strong></summary>

Replace `MainActivity.kt` with the following.

```kt
package com.package.name

import android.content.Context
import android.graphics.Point
import android.os.Build
import android.view.WindowInsets
import android.view.WindowManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import com.google.android.gms.common.GoogleApiAvailability


class MainActivity: FlutterActivity() {
    private val PROX_CHANNEL = "com.prox.method_channel/prox";
    var concurrentContext = this@MainActivity.context
    var statusBarHeight: Int = 0;
    var navigationBarHeight: Int = 0;

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        statusBarHeight = getStatusBarHeight();
        navigationBarHeight = context.systemNavigationBarHeight;
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PROX_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "isGmsAvailable") {
                result.success(isGmsAvailable());
            } else if (call.method == "statusBarHeight") {
                result.success(statusBarHeight);
            } else if (call.method == "navigationBarHeight") {
                result.success(navigationBarHeight);
            } else {
                result.notImplemented()
            }
        }
    }



    private fun isGmsAvailable(): Boolean {
        var isAvailable = false
        val context: Context = concurrentContext
        if (null != context) {
            val result: Int = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(context)
            isAvailable = com.google.android.gms.common.ConnectionResult.SUCCESS === result
        }
        return isAvailable
    }


    @JvmName("getStatusBarHeight1")
    private fun getStatusBarHeight(): Int {
        var result = 0
        val resourceId = resources.getIdentifier("status_bar_height", "dimen", "android")
        if (resourceId > 0) {
            result = resources.getDimensionPixelSize(resourceId)
        }
        return result
    }

    private val Context.systemNavigationBarHeight: Int
        get() {
            val windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager

            return if (Build.VERSION.SDK_INT >= 30) {
                windowManager
                        .currentWindowMetrics
                        .windowInsets
                        .getInsets(WindowInsets.Type.navigationBars())
                        .bottom

            } else {
                val currentDisplay = try {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                        display
                    } else {
                        windowManager.defaultDisplay
                    }
                } catch (e: NoSuchMethodError) {
                    windowManager.defaultDisplay
                }

                val appUsableSize = Point()
                val realScreenSize = Point()
                currentDisplay?.apply {
                    getSize(appUsableSize)
                    getRealSize(realScreenSize)
                }

                // navigation bar on the side
                if (appUsableSize.x < realScreenSize.x) {
                    return realScreenSize.x - appUsableSize.x
                }

                // navigation bar at the bottom
                return if (appUsableSize.y < realScreenSize.y) {
                    realScreenSize.y - appUsableSize.y
                } else 0
            }
        }

}
```
</details>

<details><summary><strong>Step 5:</strong></summary>

1. Under <br />
`android/app/src/main/res/draweble/launch_background.xml` <br />
`android/app/src/main/res/draweble-v21/launch_background.xml` <br />
change following to:

```xml
<!-- follow device light/dark theme setting-->
<item android:drawable="?android:colorBackground" />

<!-- as your theme, pick either one-->
<item android:drawable="@android:color/white" />
<item android:drawable="@android:color/black" />
```
<br />

2. Replace the following: <br />

`android/app/src/main/res/value/style.xml` <br />
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is off -->
    <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             Flutter draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
        <item name="android:windowDrawsSystemBarBackgrounds">true</item>
        <item name="android:statusBarColor">@android:color/transparent</item>
        <item name="android:navigationBarColor">@android:color/transparent</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.
         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">?android:colorBackground</item>
        <item name="android:windowDrawsSystemBarBackgrounds">true</item>
        <item name="android:statusBarColor">@android:color/transparent</item>
        <item name="android:navigationBarColor">@android:color/transparent</item>
    </style>
</resources>
```

`android/app/src/main/res/value-night/style.xml` <br />
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is off -->
    <style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             Flutter draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
        <item name="android:windowDrawsSystemBarBackgrounds">true</item>
        <item name="android:statusBarColor">@android:color/transparent</item>
        <item name="android:navigationBarColor">@android:color/transparent</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.
         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <item name="android:windowBackground">?android:colorBackground</item>
        <item name="android:windowDrawsSystemBarBackgrounds">true</item>
        <item name="android:statusBarColor">@android:color/transparent</item>
        <item name="android:navigationBarColor">@android:color/transparent</item>
    </style>
</resources>
```
</details>

<br />

> **Huawei:** An additional setup if your application is using **HMS** with ProX.

<details><summary><strong>Step 1:</strong></summary>

Create a `proguard-rules.pro` file and put it at `/android/app`, and copy the below and paste into it.
```pro
-ignorewarnings
-keepattributes *Annotation*
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes Signature
-keep class com.huawei.hianalytics.**{*;}
-keep class com.huawei.updatesdk.**{*;}
-keep class com.huawei.hms.**{*;}
-keep interface com.huawei.hms.analytics.type.HAEventType{*;}
-keep interface com.huawei.hms.analytics.type.HAParamType{*;}
-keep class com.huawei.hms.analytics.HiAnalyticsInstance{*;}
-keep class com.huawei.hms.analytics.HiAnalytics{*;}

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**
-repackageclasses
```

</details>

<details><summary><strong>Step 2:</strong></summary>

If you are using hms push service, create `Application.kt` and put together with `MainActivity.kt`
```kt
package com.package.name

import com.huawei.hms.flutter.push.PushPlugin
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback


class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        PushPlugin.setPluginRegistrant(this)
    }

    override fun registerWith(registry: PluginRegistry) {
        PushPlugin.registerWith(registry.registrarFor("com.huawei.hms.flutter.push.PushPlugin"))
    }
}
```

Also, add `android:name=".Application"` in AndroidManifest.xml.
```xml
<application
       android:name=".Application"
```

</details>
<br />

> **iOS:** add those following in the info.plist file will do.

<details><summary><strong>Step 1:</strong></summary>

```xml
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
	</dict>
  	<key>LSApplicationQueriesSchemes</key>
  	<array>
    	<string>https</string>
    	<string>http</string>
  	</array>
  	<key>UIUserInterfaceStyle</key>
	<string>Light</string>
	<key>UIViewControllerBasedStatusBarAppearance</key>
	<false/>
	<key>io.flutter.embedded_views_preview</key>
	<true/>
```
</details>

<details><summary><strong>Step 2:</strong></summary>
Add those extra setting for permission plugin in your Podfile, and that's all.

```xml
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',

        ## dart: PermissionGroup.camera
        'PERMISSION_CAMERA=1',

        ## dart: PermissionGroup.microphone
        'PERMISSION_MICROPHONE=1',

        ## dart: PermissionGroup.photos
        'PERMISSION_PHOTOS=1',

        ## dart: [PermissionGroup.location, PermissionGroup.locationAlways, PermissionGroup.locationWhenInUse]
        'PERMISSION_LOCATION=1',

        ## dart: PermissionGroup.notification
        'PERMISSION_NOTIFICATIONS=1',
      ]
    end
  end
```
</details>

<br />

### Permissions
There is a lot of permission needed to be add into your project based on use case, and again, there is no guide out there. Hence I provide some guidenace as below.

<details><summary><strong>Android</strong></summary>

````xml
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.VIBRATE"/>
    <!-- <uses-permission android:name="android.permission.RECORD_AUDIO" /> -->
    <!-- <uses-permission android:name="android.permission.FOREGROUND_SERVICE" /> -->
    <!-- <uses-permission android:name="android.permission.ACCESS_COARES_LOCATION" /> -->
    <!-- <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" /> -->
    <!-- <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" /> -->

  <queries>
    <!-- If your app opens https URLs -->
    <intent>
      <action android:name="android.intent.action.VIEW" />
      <data android:scheme="https" />
    </intent>
    <!-- If your app makes calls -->
    <intent>
      <action android:name="android.intent.action.DIAL" />
      <data android:scheme="tel" />
    </intent>
    <!-- If your app emails -->
    <intent>
      <action android:name="android.intent.action.SEND" />
      <data android:mimeType="*/*" />
    </intent>
    <!-- <provider android:authorities="com.facebook.katana.provider.PlatformProvider" /> -->
  </queries>
````
</details>

<details><summary><strong>iOS</strong></summary>

Add the following to your `info.plist` based on your own use case:
````xml
	<key>NSPhotoLibraryUsageDescription</key>
	<string>$(PRODUCT_NAME) would like to request the permission for you to select picture for profile image.</string>
	<key>NSCameraUsageDescription</key>
	<string>$(PRODUCT_NAME) would like to request the permission for you to take picture for profile image.</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>$(PRODUCT_NAME) would like to request the permission to record your voice for video recording.</string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string>$(PRODUCT_NAME) would like to request the permission to getting your current location for pre initialise the services location or add it for  favourite location.</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>$(PRODUCT_NAME) would like to request the permission to getting your current location for pre initialise the services location or add it for  favourite location.</string>
  <key>NSAppleMusicUsageDescription</key>
  <string>$(PRODUCT_NAME) need access your Media to function properly.</string>
  <key>NSCalendarsUsageDescription</key>
  <string>$(PRODUCT_NAME) need access your Calendars to function properly.</string>
  <key>NSContactsUsageDescription</key>
  <string>$(PRODUCT_NAME) requires contacts access to function properly.</string>
  <key>NSMotionUsageDescription</key>
  <string>$(PRODUCT_NAME) requires motion access to function properly.</string>
  <key>NSPhotoLibraryAddUsageDescription</key>
  <string>$(PRODUCT_NAME) need gallery access to upload new profile picture.</string>
  <key>NSSpeechRecognitionUsageDescription</key>
  <string>$(PRODUCT_NAME) requires Speech access to function properly.</string>
  <key>NFCReaderUsageDescription</key>
	<string>$(PRODUCT_NAME) would like to request the permission to read nfc in order to access the data in it.</string>
````
</details>
<br />

## Conveniences
To increase your productivity, copy `/ProX/.vscode` and place it under your project directory.

<br />

## Reminder
Remember to include flutter `.gitignore` at your project level, you can pull out one from ProX project level to your project level if you doesn't have one.

Also, include below rules into your `analysis_options.yaml` file in order to ignore annoying warning.

```
rules:
    # avoid_print: false  # Uncomment to disable the `avoid_print` rule
    # prefer_single_quotes: true  # Uncomment to enable the `prefer_single_quotes` rule
    prefer_const_constructors: false
    use_key_in_widget_constructors: false
    avoid_print: false
```

<br />

## Requirements

Current Flutter & Dart compatibility breakdown:

| Flutter Version | Dart Version |
| --------------- | ------------ |
| ^2.10.x	        | ^2.16.x      |

<br />

Make sure you uncomment `platform :ios` at Podfile and change to version to the noted version.
| Android | iOS |
| ---------- | ---- |
| Min Sdk	21 | 10.0 and above |

<br />

## Authors

* **Dexter** -  [xenovector](https://github.com/xenovector), You can also reach me at dextergold.personal@gmail.com

<br />

## Communication

* If you **found a bug**, open an issue.
* If you **have a feature request**, open a request.

<br />

## License

This project is licensed under the MIT License.

Copyright (c) 2022 Dexter Gold

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.