import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:huawei_push/huawei_push.dart' as hms;
import '../Utilities/utils.dart';
import '../export.dart';

class NotificationData {
  final String title;
  final String message;
  final String id;
  final Map<String, dynamic>? payload;

  NotificationData(this.title, this.message, this.id, {this.payload});
}

// Notification Center.
class NC {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static NC shared = NC();
  static bool isForeground = true;
  static String pushToken = '';
  static StreamSubscription? stream;

  static void stopListeningToFgBgEvent() {
    stream?.cancel();
  }

  static void init() async {
    stream = FGBGEvents.stream.listen((event) {
      isForeground = event.index == 0;
    });

    bool isHMS = await ProX.isHMS();

    if (isHMS) {
      await hms.Push.registerBackgroundMessageHandler(onHMSBackgroundMessageReceived);
      hms.Push.getTokenStream.listen((String event) {
        pushToken = event;
        print("pushToken: " + pushToken);
      }, onError: (Object error) {
        PlatformException e = error as PlatformException;
        print("HmsTokenErrorEvent: " + (e.message ?? ''));
      });
      hms.Push.onMessageReceivedStream.listen(onHMSMessageReceived, onError: (Object error) {
        // Called when an error occurs while receiving the data message
      });
      hms.Push.getToken('');

      hms.Push.onNotificationOpenedApp.listen((event) async {
        printSuperLongText('onTap event: ${event.toString()}');
        Map<String, dynamic> data = event['extras'];
        String quarantine = data['quarantine'];
        String id = data['notification_id'];
        if (int.parse(quarantine) == 1) {
          /*if (home.user.healthStatus.geofence) {
          await showConfirmationWithTitle(L.G_ALERT.tr, L.Home_Covid_Detected.tr);
          Get.to(QuarantineInfoPage(), binding: QuarantineInfoBinding());
        }*/
        } else {
          U.show.flash(data['title'], data['body'],
              data: NotificationData(data['title'], data['body'], id, payload: data));
        }
      });

      var initialNotification = await hms.Push.getInitialNotification();
      print("getInitialNotification: " + initialNotification.toString());
    } else {
      await Firebase.initializeApp();

      FirebaseMessaging.onBackgroundMessage(onGMSBackgroundMessageReceived);

      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      messaging.onTokenRefresh.listen((String token) {
        pushToken = token;
        /*if (userID != null) {
        getSetupNotification((int code, String message) async {
          print('onFcmRefreshToken.Error: $code, $message');
          return true;
        });
      }*/
      });

      FirebaseMessaging.onMessage.listen(onGMSMessageReceived);

      pushToken = await messaging.getToken() ?? '';
      print('pushToken: $pushToken');
    }
  }
}

void onGMSMessageReceived(RemoteMessage message) async {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');
  var title = message.notification?.title ?? '';
  var msg = message.notification?.body ?? '';

  String quarantine = message.data['quarantine'];
  String id = message.data['notification_id'];
  if (int.parse(quarantine) == 1) {
    /*if (home.user.healthStatus.geofence) {
        await showConfirmationWithTitle(L.G_ALERT.tr, L.Home_Covid_Detected.tr);
        Get.to(QuarantineInfoPage(), binding: QuarantineInfoBinding());
      }*/
  } else {
    U.show.flash(title, msg, data: NotificationData(title, msg, id, payload: message.data));
  }
}

Future<void> onGMSBackgroundMessageReceived(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

  // var title = message.notification.title ?? '';
  // var msg = message.notification.body ?? '';

  //if (message.data != null) {
    var id = message.data['notification_id'];

    //if (int.parse(quarantine) == 1) {
      /*if (home.user.healthStatus.geofence) {
        await showConfirmationWithTitle(L.G_ALERT.tr, L.Home_Covid_Detected.tr);
        Get.to(QuarantineInfoPage(), binding: QuarantineInfoBinding());
      }*/
    //} else {
      //eventBus.fire(NotificationData(title, msg, id, payload: message.data));
      //await Get.to(MessageDetailsPage(), binding: MessageDetailsBinding(null, id: id));
    //}
  //}
}

void onHMSMessageReceived(hms.RemoteMessage message) async {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.toMap().toString()}');

  if (NC.isForeground) {
    /*dynamic x = await hms.Push.getInitialNotification();
    if (x.length > 0) {
      print('x: $x');
    }*/
    //hms.Push.cancelNotificationsWithTag(tag)
    Map<String, dynamic> data = jsonDecode(message.data ?? '');
    int quarantine = data['quarantine'];
    int id = data['notification_id'];
    if (quarantine == 1) {
      /*if (home.user.healthStatus.geofence) {
        await showConfirmationWithTitle(L.G_ALERT.tr, L.Home_Covid_Detected.tr);
        Get.to(QuarantineInfoPage(), binding: QuarantineInfoBinding());
      }*/
    } else {
      U.show.flash(data['title'], data['body'],
          data: NotificationData(data['title'], data['body'], id.toString(), payload: data));
    }
  } else {
    hms.Push.localNotification({
      hms.HMSLocalNotificationAttr.TITLE: '[Headless] DataMessage Received',
      hms.HMSLocalNotificationAttr.MESSAGE: message.data
    });
  }
}

void onHMSBackgroundMessageReceived(hms.RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");

  hms.Push.localNotification({
    hms.HMSLocalNotificationAttr.TITLE: '[Headless] DataMessage Received',
    hms.HMSLocalNotificationAttr.MESSAGE: message.data
  });
}
