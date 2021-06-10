# ProX
`[Supported Null Safety]`<br/>
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

### Example
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ProX/Core/export.dart';
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
      theme: ThemeData(primarySwatch: ThemeColor.swatch, accentColor: ThemeColor.main),
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
    this.fadeVisible = true;
    update();
  }

  void checkCredential() async {
    await DevicePreferences.init();
    RequestException error = await AppLanguage.init();
    if (error != null) {
      print('AppLanguage.init Error: ${error.errorMessage}');
      await showConfirmationWithTitle('Error: ${error.code}', error.errorMessage, confirm: checkCredential);
      return;
    }
    // ResponseData<PreloadData> res = await getPreload((code, msg) async {
    //   return true;
    // });
    // preload = res.data;
    moveToEntryPage();
  }

  void moveToEntryPage() async {
    if (!didInit) didInit = true;
    else {
      bool didSetLocale = AppLanguage.didSetLocale.val;
      print('didSetLocale: $didSetLocale');
      if (!didSetLocale && AppLanguage.supportLocale.length > 1) {
        //Get.offAll(LanguagePage(), binding: LanguageBinding());
      } else {
        //Get.offAll(LoginPage(), binding: LoginBinding());
      }
    }
  }
}

class LoadingPage extends StatelessWidget {
  Widget splashScreen() {
    return Container(
      color: ThemeColor.background,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // --- Decline all your widget here.
          Expanded(child: Center(), flex: 9),
          Image.asset('assets/app_logo.png', width: 220),
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
                            color: Colors.white,
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

```
<br />

### Usage Guide
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
ProX.setStatusBarTextColor(isWhite: false);
// Set Status Bar Background Color, usually I don use it because I most of the widget I defined are safeArea top = false.
ProX.setStatusBarBackground(Colors.blue);
// Set Allowed Orientation.
ProX.setAllowedOrientation([DeviceOrientation.portraitUp]);
// bool, check device service is running on HMS (huawei service) or not.
bool isHMS = await ProX.isHMS():
// bool, check device service is running on GMS (google service) or not.
bool isGMS = await ProX.isGMS():
```
<br />

### Error Hanlding
```dart
@override
Future<bool> onFailed(int code, String msg, {Function() tryAgain}) async {
  isLoading(false);
  bool handlePrivately = await super.onFailed(code, msg, tryAgain: yourTryAgainFunction);
  if (handlePrivately) await showConfirmationWithTitle('Error: $code', msg);
  return handlePrivately;
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
  package_info:
  device_info:
  sprintf:
  lottie:
  connectivity:
  http:
  http:
  dio:
  event_bus:
  path_provider:
  url_launcher:
  app_settings:
  # huawei_hmsavailability:
  flutter_statusbarcolor_ns:
  flutter_inappwebview:
  flutter_keyboard_visibility:
  extended_image:
  auto_size_text: ^3.0.0-nullsafety.0
  vibration: ^1.7.4-nullsafety.0
  version:
  permission_handler: ^8.0.1 # visit the site to setup for each platform.

  # --- listing use ---
  pull_to_refresh:
  flutter_slidable:
  # --- ------- --- ---

  # --- camera use ---
  camera: #^0.8.1
    git:
      url: https://github.com/bottlepay/plugins.git
      path: packages/camera/camera
      ref: android-rework
  pinch_zoom: ^0.1.0
  native_device_orientation: ^1.0.0
  align_positioned: ^2.0.0
  image: ^3.0.2
  image_editor: ^1.0.0
  # --- ------ --- ---

  # --- location use ---
  location:
  huawei_location:
  geocoding:
  google_maps_flutter: ^2.0.3
  huawei_map:
    path: lib/ProX/Download/hms/huawei_map
  # --- -------- --- ---

  # --- notification use ---
  # onesignal_flutter: ^2.6.3
  firebase_core: ^1.2.1
  firebase_messaging: ^10.0.1
  huawei_push: ^5.1.1+301
  flutter_fgbg:
  # --- ------------ --- ---

  # list project base plugin here:

  # flutter_html:
  # open_file:
  # flutter_swiper: ^1.1.6
  # smooth_page_indicator: ^0.2.1
  # qr_flutter: ^4.0.0
  # menu_button: ^1.4.2+1
  # pin_code_fields: ^7.0.0
  # flutter_xlider:
  # qr_code_scanner:
```
```yaml
assets:
    - lib/ProX/assets/
    - lib/ProX/assets/lottie/
```
<br />

</details>

<details><summary><strong>Include asset files and custom font example</strong></summary>

```yaml
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  # assets:
  assets:
    - assets/
    - assets/country/
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
    ext.kotlin_version = '1.3.50'
    repositories {
        google()
        jcenter()
  //*   maven { url 'https://developer.huawei.com/repo/' }
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:4.1.2'
        classpath 'org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version'
  //*   classpath 'com.huawei.agconnect:agcp:1.4.1.300'
  //*   classpath 'com.google.gms:google-services:4.3.3'
    }
}

allprojects {
    repositories {
        google()
        jcenter()
  //*   maven { url 'https://developer.huawei.com/repo/' }
    }
}
```

in `/android/app/build.gradle`, add:

```swift

// include this if u want to support for hms service.
apply plugin: 'com.huawei.agconnect'

apply plugin: 'com.google.gms.google-services'

def keystorePropertiesFile = rootProject.file("key.properties")
def keystoreProperties = new Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
   defaultConfig {
     minSdkVersion 21
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
import com.google.android.gms.common.GoogleApiAvailability
import io.flutter.plugins.GeneratedPluginRegistrant


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

> **Huawei:** An additional setup if your application is using hms with ProX.

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
  <key>UIUserInterfaceStyle</key>
	<string>Light</string>
	<key>UIViewControllerBasedStatusBarAppearance</key>
	<false/>
	<key>io.flutter.embedded_views_preview</key>
	<true/>
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
<uses-permission android:name="android.permission.ACCESS_COARES_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
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
<string>$(PRODUCT_NAME) would like to request the permission to getting your current location for pre initialise the services location or add it for favourite location.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>$(PRODUCT_NAME) would like to request the permission to getting your current location for pre initialise the services location or add it for favourite location.</string>
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
````
</details>
<br />

## Reminder
Remember to include flutter `.gitignore` at your project level, you can pull out one from ProX project level to your project level if you doesn't have one.

<br />

## Requirements

Current Flutter & Dart compatibility breakdown:

| Flutter Version | Dart Version |
| --------------- | ------------ |
| 2.x	            | 2.12.x       |

<br />

Make sure you uncomment `platform :ios` at Podfile and change to version to the noted version.
| Android | iOS |
| ---------- | ---- |
| Min Sdk	21 | 10.0 |

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

Copyright (c) 2021 Dexter Gold

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