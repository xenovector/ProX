import 'dart:ui';
import 'package:flutter/material.dart';
import '../export.dart';

Future<String> showProXDialog(String title, List<String> szList, {String? btnLabel, int? selectedIndex}) async {
  ProXDialogController ctrl = Get.put(ProXDialogController());
  ctrl.itemList = szList;
  ctrl.selectedIndex = null;
  return await Get.dialog(ProXDialogPage(ctrl, title, btnLabel ?? L.GENERAL_OK.tr));
}

class ProXDialogController extends GetxController {
  List<String> itemList = [];
  int? selectedIndex;

  @override
  void onInit() {
    super.onInit();
  }

  void onDone() {
    Get.back(result: this.itemList[selectedIndex!]);
  }
}

class ProXDialogPage extends StatelessWidget {
  final ProXDialogController ctrl;
  final String title;
  final String btnLabel;

  ProXDialogPage(this.ctrl, this.title, this.btnLabel);

  Widget listView({ScrollPhysics? scrollPhysics}) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: scrollPhysics,
      itemCount: ctrl.itemList.length,
      itemBuilder: (context, index) => TextButton(
          style: TextButton.styleFrom(
              //primary: ctrl.selectedIndex == index ? Colors.black : Colors.white,
              //backgroundColor: ctrl.selectedIndex == index ? ThemeColor.main : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0))),
          child: Container(
              height: 44,
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 36),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: ctrl.selectedIndex == index ? Border.all(color: S.color.main, width: 1.5) : null
                ),
              child: Center(
                child: Text(ctrl.itemList[index],
                    textAlign: TextAlign.center, style: TextStyle(color: S.color.text, fontWeight: FontWeight.w400),),
              )),
          onPressed: () {
            ctrl.selectedIndex = ctrl.selectedIndex == index ? null : index;
            ctrl.update();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProXDialogController>(
        builder: (ctrl) => Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                    margin: EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 0,
                          blurRadius: 7,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(maxHeight: Get.height * 0.7),
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 75,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(title,
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: S.color.main, fontSize: 20, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          ((ctrl.itemList.length * 68) > ((Get.height * 0.7) - (75 + 55 + 16)))
                              ? Expanded(child: listView())
                              : listView(scrollPhysics: NeverScrollableScrollPhysics()),
                          TextButton(
                              child: Container(
                                  height: 55,
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(btnLabel,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: ctrl.selectedIndex == null ? S.color.disable : S.color.main,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                  )),
                              onPressed: () {
                                if (ctrl.selectedIndex != null) {
                                  ctrl.onDone();
                                }
                              })
                        ],
                      ),
                    )),
              ),
            ));
  }
}
