import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import '../Helper/hotkey.dart';
import '../Helper/sizer.dart';
import 'prox_constant.dart';
import 'prox_controller.dart';

class ProXScaffold<T extends ProXController> extends StatelessWidget {
  final Widget? Function(T ctrl)? appBar;
  final Color? appBarColor;
  final Gradient? appBarGradient;
  final bool appBarWithShadow;
  final bool appBarBlockCallBack;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Drawer? drawer;
  final Widget? endDrawer;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  final Widget Function(T ctrl) builder;
  final Color? customBackgroundColor;
  final Color? customBackgroundColor2;
  final String? customBackgroundImage;
  final Widget? overlayChild;
  final bool resizeToAvoidBottomInset;

  const ProXScaffold({
    Key? key,
    this.appBar,
    this.appBarColor,
    this.appBarGradient,
    this.appBarWithShadow = true,
    this.appBarBlockCallBack = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.bottomSheet,
    this.bottomNavigationBar,
    required this.builder,
    this.customBackgroundColor,
    this.customBackgroundColor2,
    this.customBackgroundImage,
    this.overlayChild,
    this.resizeToAvoidBottomInset = true,
  }) : super(key: key);

  Widget getBody(BuildContext context, T ctrl) {
    return KeyboardDismissOnTap(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0, boldText: false),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Stack(
              children: [
                Positioned.fill(
                    child: (customBackgroundImage != null || ProX.defaultBackgroundImageAssetsPath != null)
                        ? Image.asset(customBackgroundImage ?? ProX.defaultBackgroundImageAssetsPath!,
                            fit: BoxFit.cover)
                        : customBackgroundColor2 == null
                            ? Container(color: customBackgroundColor ?? ProX.defaultBackgroundColor)
                            : Column(
                                children: [
                                  Expanded(child: Container(color: customBackgroundColor)),
                                  Expanded(child: Container(color: customBackgroundColor2))
                                ],
                              )),
                Positioned.fill(
                    top: (appBar == null || appBar!(ctrl) == null)
                        ? 0
                        : orientation == Orientation.portrait
                            ? (Sizer.topSafeAreaHeight + kToolbarHeight)
                            : (3 + kToolbarHeight),
                    child: builder(ctrl)),
                appBar == null
                    ? Center()
                    : Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Container(
                            height: Sizer.topSafeAreaHeight + kToolbarHeight,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: appBarGradient == null ? appBarColor ?? Colors.white : null,
                              gradient: appBarGradient,
                              boxShadow: appBarWithShadow
                                  ? [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 7,
                                        offset: Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: Sizer.topSafeAreaHeight),
                                Expanded(child: appBar!(ctrl) ?? SizedBox.shrink())
                                //Container(
                                //color: Colors.deepOrange,
                                //child: SizedBox(height: SizeConfig.topSafeAreaHeight, width: double.infinity)),
                                //Expanded(child: Container(
                                //color: Colors.yellow,
                                //child: appBar!))
                              ],
                            )),
                      ),
                if (overlayChild != null) Positioned.fill(child: overlayChild!),
                Positioned.fill(
                    child: Obx(() => ctrl.showLoading.isTrue
                        ? GestureDetector(
                            child: ProX.defaultLoadingWidget ??
                                Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.black26,
                                    padding: EdgeInsets.symmetric(horizontal: 60),
                                    child: Center(
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 750),
                                        //curve: Curves.easeOutExpo,
                                        padding: EdgeInsets.fromLTRB(15, ctrl.showLoadingText.value == '' ? 15 : 50, 15, 10),
                                        decoration: BoxDecoration(
                                            color: ctrl.showLoadingText.value == ''
                                                ? Colors.white12
                                                : Colors.white.withOpacity(0.85),
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: ctrl.showLoadingText.value == ''
                                                ? null
                                                : [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 1),
                                                      blurRadius: 2,
                                                    )
                                                  ]),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircularProgressIndicator(color: S.color.main),
                                            SizedBox(height: ctrl.showLoadingText.value == '' ? 5 : 10),
                                            if (ctrl.showLoadingText.value != '')
                                              Container(
                                                padding: EdgeInsets.symmetric(vertical: 20),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(ctrl.showLoadingText.value,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight: FontWeight.w500,
                                                              color: S.color.main)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    )),
                            onTap: () {
                              //controller.isLoading(false);
                            },
                          )
                        : Center())),
              ],
            );
          }
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      builder: (ctrl) {
        return Scaffold(
            key: key,
            drawer: drawer,
            endDrawer: endDrawer,
            bottomSheet: bottomSheet,
            extendBodyBehindAppBar: true,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            body: appBarBlockCallBack ? WillPopScope(onWillPop: ctrl.onCallBackBlocked, child: getBody(context, ctrl)) : getBody(context, ctrl));
      }
    );
  }
}
