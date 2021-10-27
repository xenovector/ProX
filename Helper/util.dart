import 'dart:async';
import 'dart:io';
import 'date_time.dart';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prox/ProX/Controller/notification_controller.dart';
import '../export.dart';

void showFlash(String title, String message, {NotificationData? data}) {
  Get.snackbar(title, message,
  titleText: Padding(padding: EdgeInsets.only(top: 10), child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w600))),
  messageText: Padding(padding: EdgeInsets.only(bottom: 10), child: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12))),
      snackPosition: SnackPosition.TOP,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.easeOut,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      padding: EdgeInsets.symmetric(horizontal: 20),
      borderRadius: 8,
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          blurRadius: 7,
          offset: Offset(2, 2),
        ),
      ],
      duration: Duration(seconds: 5),
      onTap: (_) {
    print('id: ${data?.id ?? 'null'}');
  });
}

void showToast(String msg, {BuildContext? context}) {
  final scaffold = ScaffoldMessenger.of(context == null ? Get.context! : context);
  scaffold.showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: 2000),
      content: Text(msg),
      action: SnackBarAction(label: "OK", textColor: ThemeColor.main, onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

Future<bool?> showBlockClose(BuildContext context) async {
  return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Notice'),
            content: Text('Do you want to exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () {
                  // Navigator.of(context).pop(true);
                  exitApp();
                },
                child: new Text('Yes'),
              ),
            ],
          );
        },
      );
}

Future<bool?> showConfirmation(
  String message, {
  VoidCallback? confirm,
  actionLabel = 'OK',
}) async {
  return Get.defaultDialog<bool>(
    barrierDismissible: false,
    content: Text(message),
    actions: <Widget>[
      // usually buttons at the bottom of the dialog
      TextButton(
        child: new Text(actionLabel),
        onPressed: () {
          Get.back(result: true);
          if (confirm != null) {
            confirm();
          }
        },
      ),
    ],
  );
}

Future<int?> showCupertinoActionSheet(BuildContext context, List<String> list, {String? title}) {
  var listWidget = <Widget>[];
  for (var i = 0; i < list.length; i++) {
    listWidget.add(CupertinoActionSheetAction(
      child: Text(list[i]),
      onPressed: () {
        Get.back(result: i);
      },
    ));
  }

  CupertinoActionSheet dialog = CupertinoActionSheet(
    title: title != null && title != '' ? Text(title) : null,
    actions: listWidget,
    cancelButton: CupertinoActionSheetAction(
      child: Text('Cancel'),
      onPressed: () {
        Get.back();
      },
    ),
  );

  return showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return dialog;
          });
}

Future<List<WeekDay>?> showWeekDayPicker({List<WeekDay>? initialWeekDay, String title = ''}) {
  if (initialWeekDay == null) {
    initialWeekDay = WeekDay.getFullWorkDays();
  }

  List<WeekDay> list = WeekDay.getFullWorkDays();
  for (int i = 0; i < initialWeekDay.length; i++) {
    for (int j = 0; j < list.length; j++) {
      if (list[j].weekday == initialWeekDay[i].weekday) {
        list[i].selected = initialWeekDay[j].selected;
        break;
      }
    }
  }

  return Get.defaultDialog(
    title: title,
    actions: <Widget>[
      // usually buttons at the bottom of the dialog
      TextButton(
        child: new Text('CANCEL'),
        onPressed: () {
          Get.back();
        },
      ),
      TextButton(
        child: new Text(
          'OK',
        ),
        onPressed: () {
          Get.back(result: list);
        },
      ),
    ],
    content: StatefulBuilder(builder: (context, setState) {
      return Container(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              title: Text(list[index].name),
              value: list[index].selected,
              onChanged: (value) {
                setState(() {
                  list[index].selected = value ?? false;
                });
              },
            );
          },
        ),
      );
    }),
  );
}

void vibrate() async {
  var canVibrate = await Vibration.hasVibrator();
  if (canVibrate ?? false) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      Vibration.vibrate(duration: 300);
    } else {
      Vibration.vibrate(duration: 300);
    }
  }
}

Future<void> playSound(String name) async {
  AudioCache cache = new AudioCache();
  await cache.play(name);
}

void openMap(double latitude, double longitude) async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    var mapSchema = 'geo:$latitude,$longitude?q=$latitude,$longitude';
    /*if (await canLaunch('google.navigation:'))
        launch('google.navigation:q=$latitude,$longitude');*/
    if (await canLaunch('geo:'))
      launch(mapSchema);
    else
      showConfirmation('Please install waze or google map to start navigator');
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    bool canMap = await canLaunch('waze://');
    if (!canMap) {
      bool canGoogleMap = await canLaunch('comgooglemaps://');
      if (canGoogleMap)
        launch(
            // ignore: unnecessary_brace_in_string_interps
            'comgooglemaps://?saddr=&daddr=${latitude},${longitude}&directionsmode=driving');
      else if (await canLaunch('https://maps.apple.com/')) {
        // ignore: unnecessary_brace_in_string_interps
        launch('https://maps.apple.com/?q=${latitude},${longitude}');
      } else
        showConfirmation('Please install waze or google map to start navigator');
    } else
      // ignore: unnecessary_brace_in_string_interps
      launch('waze://?ll=${latitude},${longitude}&navigate=yes&zoom=17');
  }
}

bool get isiPhoneX => Platform.isIOS && Get.mediaQuery.viewPadding.top > 0;

Future<dynamic> showInAppBrowser(String url, {String? appBarTitle, Map<String, String>? header}) async {
  Get.to(InAppBrowserPage(url, appBarTitle: appBarTitle, header: header), binding: InAppBrowerBinding());
}

void dismissKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(new FocusNode());
}

void openForceUpdateDialog({String? title, String? message}) async {
  if (title == null || title == '') {
    title = 'New Version Available';
  }
  if (message == null || message == '') {
    message = 'There is a newer version available for download! Please update the app by visiting the ';
    if (Platform.isAndroid) {
      message += 'Play Store';
    } else {
      message += 'App Store';
    }
  }

  showConfirmDialog(title, message, actionLabel: 'Update', touchToDismiss: false, confirm: openAppStore);
}

/// ### Note:
///
/// If you do not have set `ProX.iosAppID` or `ProX.hmsAppID`,
/// you are required to pass the id for iOS (App Store) or HMS (App Gallery).
///
/// Both iOS and HMS id should be different.
///
/// -Passing it corresponding to your use case.-
///
void openAppStore({String? id}) async {
  String url;
  if (Platform.isAndroid) {
    bool isHMS = await ProX.isHMS();
    //if (isHMS && (ProX.hmsAppID != null && ProX.hmsAppID != '')) {
    if (isHMS) {
      String _id = id ?? ProX.hmsAppID;
      if (_id.isEmptyOrNull) {
        showConfirmDialog('Application Error', 'StoreID not found on HMS.', touchToDismiss: true);
        return;
      } else {
        // ignore: unnecessary_brace_in_string_interps
        url = 'https://appgallery.cloud.huawei.com/marketshare/app/C${_id}';
      }
    } else {
      url = 'https://play.google.com/store/apps/details?id=${DevicePreferences.packageName}';
    }
  } else {
    String _id = id ?? ProX.iosAppID;
    if (_id.isEmptyOrNull) {
      showConfirmDialog('Application Error', 'StoreID not found on HMS.', touchToDismiss: true);
      return;
    } else {
      // ignore: unnecessary_brace_in_string_interps
      url = 'https://itunes.apple.com/us/app/id${_id}?mt=8';
    }
  }
  if (await canLaunch(url)) {
    print('opening: $url');
    await launch(url);
  }
}

Future openURL(String? url, {bool pop = false}) async {
  if (url == null || url == '') {
    return;
  } else if (await canLaunch(url)) {
    if (pop) Get.back();
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void openEmail({required String email, required String title, String? body}) async {
  var link = 'mailto:$email?subject=$title';
  if (body != null) link += '&body=$body';
  link.replaceAll(' ', '%20');
  await openURL(link);
}

void openWhatsapp({required String number, required String text}) async {
  await openURL('https://wa.me/$number?text=$text');
}

void openCall({required String phone}) async {
  //phone = phone.replaceAll(' ', '');
  if (Platform.isAndroid) {
    // ignore: unnecessary_brace_in_string_interps
    launch('tel:${phone}');
  } else {
    launch('tel://${phone.replaceAll(' ', '').getEmptyOrNull ?? phone}');
  }
}

Future<File> downloadFile(String url, String filename) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  String path = '$dir/$filename';
  bool isExist = await File(path).exists();
  if (isExist) return File(path);
  var httpClient = new HttpClient();
  var request = await httpClient.getUrl(Uri.parse(url));
  var response = await request.close();
  var bytes = await consolidateHttpClientResponseBytes(response);
  File file = new File(path);
  await file.writeAsBytes(bytes);
  return file;
}

void exitApp() async {
  await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
}

bool isValidEmail(String email) {
  return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

class CirclePainter extends CustomPainter {
  ui.Image? imageToDraw;
  final Color _color;

  CirclePainter(this._color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = _color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, 120), 60, paint1);
    // canvas.drawImage(imageToDraw!, Offset(size.width / 2, 0), paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}





