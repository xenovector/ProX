import 'dart:async';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';

import '../export.dart';

Future<bool?> showConfirmDialog(String? title, String message,
    {VoidCallback? confirm,
    String actionLabel = 'OK',
    Color? actionColor,
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
                imageWidget ??= SizedBox(height: 12),
                title == null
                    ? Center()
                    : Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: S.color.main)),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  child: Text(message,
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 12),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        constraints: BoxConstraints(minHeight: 44),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: actionColor ?? S.color.main,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))),
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
  String actionLabel = 'OK',
  Color? actionColor,
  String cancelLabel = 'Cancel',
  Color? cancelColor,
  bool touchToDismiss = true,
  Widget? imageWidget,
  bool forSetting = false,
}) async {
  final textGroup = AutoSizeGroup();

  Widget cancelButton = Container(
    margin: EdgeInsets.symmetric(vertical: 12),
    padding: EdgeInsets.symmetric(horizontal: 10),
    constraints: BoxConstraints(minHeight: 44, minWidth: 108),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: S.color.main, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))),
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
    BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            imageWidget ??= SizedBox(height: 12),
            title == null
                ? Center()
                : Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: S.color.main)),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              child: Text(message,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
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
                    margin: EdgeInsets.symmetric(vertical: 12),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    constraints: BoxConstraints(minHeight: 44),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: S.color.main,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))),
                      child: AutoSizeText(actionLabel,
                          group: textGroup,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
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
    barrierDismissible: touchToDismiss,
  );
}
