import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import '../Core/app_config.dart';
import '../Core/extension.dart';
import '../Core/pro_x.dart';
import '../Controller/notification_controller.dart';
import '../ReuseableWidget/confirmation_dialog.dart';
import '../Helper/device.dart';
import '../Helper/in_app_browser.dart';
import '../i18n/app_language.dart';
import '../i18n/language_key.dart';
import '../Helper/hotkey.dart';

class UtilsShow {
  // Flash.
  void flash(String title, String message, {NotificationData? data}) {
    Get.snackbar(title, message,
        titleText: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(title,
                maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w600))),
        messageText: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12))),
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
        duration: Duration(seconds: 5), onTap: (_) {
      print('id: ${data?.id ?? 'null'}');
    });
  }

  // Toast
  void toast(String msg, {BuildContext? context, Color? textColor, int milliseconds = 1400}) {
    final scaffold = ScaffoldMessenger.of(context ?? Get.context!);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: milliseconds),
        padding: EdgeInsets.zero,
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Container(
            margin: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -1),
                blurRadius: 2,
              )
              ]
            ),
            child: Row(
              children: [
                SizedBox(width: 18),
                Expanded(child: Text(msg, style: TextStyle(color: textColor ?? Colors.black))),
                InkWell(
                  onTap: () {
                    //
                  },
                  child: SizedBox(
                    height: 45,
                    width: 80,
                    child: Center(child: Text('OK', style: TextStyle(
                      color: S.color.main,
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                    )))
                  )
                )
              ],
            )
          ),
        //action: SnackBarAction(label: "OK", textColor: S.color.main, onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  /// Exit App Feature.
  void _exitApp() {
    if (Platform.isIOS) {
      exit(0);
    } else {
      SystemNavigator.pop();
    }
    //await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  }

  // Exit App Dialog.
  Future<bool?> exitDialog({bool useCupertino = false}) async {
    if (useCupertino) {
      return await cupertinoDialog(Get.context!, L.GENERAL_EXIT_APP_DIALOG_TITLE.tr,
      L.GENERAL_EXIT_APP_DIALOG_MESSAGE.tr,
      needCancel: true,
      cancelText: L.GENERAL_NO.tr,
      cancelColor: S.color.alertSecondaryColor,
      confirmText: L.GENERAL_YES.tr,
      confirmColor: S.color.alertPrimaryColor,
      confirmAction: _exitApp
      );
    } else {
      return await confirmDialog(
        Get.context!,
        L.GENERAL_EXIT_APP_DIALOG_TITLE.tr,
        L.GENERAL_EXIT_APP_DIALOG_MESSAGE.tr,
        needCancel: true,
        cancelText: L.GENERAL_NO.tr,
        cancelColor: S.color.alertSecondaryColor,
        confirmText: L.GENERAL_YES.tr,
        confirmColor: S.color.alertPrimaryColor,
        confirmAction: _exitApp
      );
    }
  }

  Future<bool> nativeDialog(String title, String message,
      {String actionText = 'OK',
      bool needCancel = false,
      String cancelText = 'Cancel',
      Function()? onDone,
      bool barrierDismissible = false}) async {
    return await showPlatformDialog(
      context: Get.context!,
      androidBarrierDismissible: barrierDismissible,
      builder: (_) => BasicDialogAlert(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          BasicDialogAction(
            title: Text(actionText, style: TextStyle(fontSize: 15)),
            onPressed: () {
              if (onDone != null) onDone();
              Get.back(result: true);
            },
          ),
          if (needCancel)
            BasicDialogAction(
              title: Text(cancelText, style: TextStyle(fontSize: 15)),
              onPressed: () => Get.back(result: false),
            ),
        ],
      ),
    );
  }

  /// Provide action to both cancel or ok, else return true or false for the action user perform.
  Future<bool?> confirmDialog(BuildContext context, String title, String message,
      {bool needCancel = false,
      String cancelText = '',
      String confirmText = '',
      Color cancelColor = Colors.black,
      Color confirmColor = Colors.black,
      VoidCallback? cancelAction,
      VoidCallback? confirmAction}) async {
    return Get.defaultDialog<bool>(
      barrierDismissible: true,
      title: title,
      titlePadding: EdgeInsets.only(top: 25, bottom: 10),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      contentPadding: EdgeInsets.fromLTRB(15, 8, 15, 12),
      radius: 12,
      actions: <Widget>[
        if (needCancel)
          SizedBox(
            width: Get.width / 3.9,
            child: ElevatedButton(
              onPressed: cancelAction ??= () => Get.back(result: false),
              style: ElevatedButton.styleFrom(backgroundColor: cancelColor),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 11),
                child: Text(cancelText.isEmpty ? L.GENERAL_CANCEL.tr : cancelText,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        if (needCancel) SizedBox(width: 12),
        SizedBox(
            width: needCancel ? Get.width / 3.9 : double.infinity,
            child: ElevatedButton(
              onPressed: confirmAction ??= () => Get.back(result: true),
              style: ElevatedButton.styleFrom(backgroundColor: confirmColor),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: needCancel ? 11 : 12),
                child: Text(confirmText.isEmpty ? L.GENERAL_OK.tr : confirmText,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
              ),
            )),
      ],
    );
  }

  Future<void> bottomActionSheet(BuildContext context, {String? title, required List<ListTile> items}) async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: <Widget>[
              if (title != null && title != '')
                Container(
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 18),
                  child: Text(title, style: TextStyle(fontSize: 15)),
                ),
              if (title != null && title != '')
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  width: double.infinity,
                  height: 1,
                  color: Colors.black26,
                ),
              ...items,
              Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                width: double.infinity,
                height: 1,
                color: Colors.black26,
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                minLeadingWidth: 20,
                title: Text(L.GENERAL_CANCEL.tr),
                onTap: Get.back,
              ),
            ],
          );
        });
  }

  /// Provide action to both cancel or ok, else return true or false for the action user perform.
  Future<bool?> cupertinoDialog(BuildContext context, String title, String message,
      {bool needCancel = false,
      String cancelText = '',
      String confirmText = '',
      Color? cancelColor,
      Color? confirmColor,
      VoidCallback? cancelAction,
      VoidCallback? confirmAction}) {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: title != '' ? Text(title) : null,
            content: Text(message),
            actions: <Widget>[
              if (needCancel)
                CupertinoButton(
                  onPressed: cancelAction ??= () => Get.back(result: false),
                  child: Text(cancelText.isEmpty ? L.GENERAL_CANCEL.tr : cancelText,
                      style: TextStyle(
                        color: cancelColor ?? S.color.alertSecondaryColor,
                        fontSize: 16,
                        //fontWeight: FontWeight.w500,
                        letterSpacing: AppLanguage.isChinese ? 0.05 : null,
                      )),
                ),
              CupertinoButton(
                onPressed: confirmAction ??= () => Get.back(result: true),
                child: Text(confirmText.isEmpty ? L.GENERAL_OK.tr : confirmText,
                    style: TextStyle(
                      color: confirmColor ?? S.color.alertPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: AppLanguage.isChinese ? 0.05 : null,
                    )),
              ),
            ],
          );
        });
  }

  Future<void> cupertinoActionSheet(BuildContext context,
      {String? title, required List<CupertinoActionSheetAction> items}) async {
    var dialog = CupertinoActionSheet(
      title: title != null && title != '' ? Text(title) : null,
      actions: items,
      cancelButton: CupertinoActionSheetAction(
        child: Text(L.GENERAL_CANCEL.tr),
        onPressed: () {
          Get.back();
        },
      ),
    );

    return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: dialog,
          );
        });
  }

  Future<dynamic> inAppBrowser(String url, {String? appBarTitle, Map<String, String>? header}) async {
    Get.to(InAppBrowserPage(url, appBarTitle: appBarTitle, header: header), binding: InAppBrowerBinding());
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
  void forceUpdateDialog({bool isForce = false}) async {
    String title = '';
    String message = '';

    if (isForce) {
      title = L.ERROR_FORCE_UPDATE_TITLE_REQUIRED.tr;
    } else {
      title = L.ERROR_FORCE_UPDATE_TITLE_OPTIONAL.tr;
    }

    if (Platform.isAndroid) {
      bool isHMS = await ProX.isHMS();
      if (isHMS) {
        message = L.ERROR_FORCE_UPDATE_DES_HUAWEI.tr;
      } else {
        message = L.ERROR_FORCE_UPDATE_DES_GOOGLE.tr;
      }
    } else {
      message = L.ERROR_FORCE_UPDATE_DES_APPLE.tr;
    }

    showConfirmDialog(title, message, actionLabel: L.GENERAL_UPDATE.tr, touchToDismiss: !isForce, confirm: _openStore);
  }

  void _openStore({String? id}) async {
    String url;
    if (Platform.isAndroid) {
      bool isHMS = await ProX.isHMS();
      //if (isHMS && (ProX.hmsAppID != null && ProX.hmsAppID != '')) {
      if (isHMS) {
        String _id = id ?? AppConfig.hmsAppID;
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
      String _id = id ?? AppConfig.iosAppID;
      if (_id.isEmptyOrNull) {
        showConfirmDialog('Application Error', 'StoreID not found on HMS.', touchToDismiss: true);
        return;
      } else {
        // ignore: unnecessary_brace_in_string_interps
        url = 'https://itunes.apple.com/us/app/id${_id}?mt=8';
      }
    }
    if (await canLaunchUrlString(url)) {
      print('opening: $url');
      await launchUrlString(url);
    }
  }
}
