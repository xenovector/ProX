import 'dart:async';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';

import '../Core/export.dart';

Future<bool?> showConfirmDialog(String? title,
  String message, {
  VoidCallback? confirm,
  actionLabel = 'OK',
  actionColor = ThemeColor.main,
  bool touchToDismiss = true,
  Widget? imageWidget,
  bool forSetting = false}) async {
    return Get.dialog(
        WillPopScope(
          onWillPop: () async => touchToDismiss,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    imageWidget == null ? SizedBox(height: 10) : imageWidget,
                    title == null ? Center() : Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ThemeColor.main)),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Text(message,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 5, bottom: 20),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            constraints: BoxConstraints(minHeight: 44),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: actionColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23))),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(actionLabel,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500)),
                              ),
                              onPressed: () {
                                Get.back(result: true);
                                if (confirm != null) confirm();
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: touchToDismiss,
      );
}

Future<bool?> showCancelableDialog(
  String? title,
  String message, {
  VoidCallback? confirm,
  actionLabel = 'OK',
  actionColor = ThemeColor.main,
  cancelLabel = 'Cancel',
  cancelColor = ThemeColor.main,
  bool touchToDismiss = true,
  Widget? imageWidget,
  bool forSetting = false,
}) async {
  final textGroup = AutoSizeGroup();

  Widget cancelButton = Container(
                          margin: EdgeInsets.only(top: 5, bottom: 10),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          constraints: BoxConstraints(minHeight: 44),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: ThemeColor.main,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: AutoSizeText(cancelLabel,
                                  group: textGroup,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                            ),
                            onPressed: () {
                              Get.back(result: false);
                            },
                          ),
                        );

  return Get.dialog(
    Material(
      color: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            padding: imageWidget == null ? EdgeInsets.all(20) : EdgeInsets.fromLTRB(20, 25, 20, 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              imageWidget == null ? SizedBox(height: 10) : imageWidget,
              title == null ? Center() : Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ThemeColor.main)),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ),
              Row(
                children: [
                  forSetting
                      ? cancelButton
                      : Expanded(
                          child: cancelButton,
                        ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 5, bottom: 8),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      constraints: BoxConstraints(minHeight: 44),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: ThemeColor.main,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))),
                        child: Container(
                          child: AutoSizeText(actionLabel,
                              group: textGroup,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                        ),
                        onPressed: () {
                          Get.back(result: true);
                          if (confirm != null) confirm();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    ),
    barrierDismissible: touchToDismiss,
  );
}
