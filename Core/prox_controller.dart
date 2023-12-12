import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'prox_constant.dart';
import 'prox_widget.dart';


mixin class InitializeController {
  var _didInit = false;

  bool get isInited => _didInit;
  void didInit() => _didInit = true;
  void unInit() => _didInit = false;
}

abstract class ProXController<T> extends FullLifeCycleController
    with FullLifeCycleMixin, InitializeController
    implements GeneralCallBack, DidAppearAgain {
  final RxBool showLoading = false.obs;
  final RxString showLoadingText = ''.obs;
  T get page => Get.arguments;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<bool> onCallBackBlocked() async {
    return true;
  }

  @override
  void didAppearAgain(dynamic result) {
    print('$runtimeType - onAppearAgain called');
  }

  @override
  Future<X> moveTo<X>(ProXWidget page, {Bindings? binding}) async {
    var result = await Get.to(page, binding: binding);
    Future.delayed(Duration(milliseconds: 200)).then((value) => didAppearAgain(result));
    return result;
  }

  @override
  void onClose() {
    super.onClose();
    print('$runtimeType - onClose called');
  }

  @override
  void onDetached() {
    print('$runtimeType - onDetached called');
  }

  @override
  void onInactive() {
    print('$runtimeType - onInactive called');
  }

  @override
  void onPaused() {
    print('$runtimeType - onPaused called');
  }

  @override
  void onResumed() {
    print('$runtimeType - onResumed called');
  }

  @override
  Future<bool> onFailed(int code, String title, String msg, {dynamic data, Function()? tryAgain}) async {
    return await ProX.onFailed(code, title, msg, data: data, tryAgain: tryAgain);
  }

  void isLoading(bool value,
      {String textAfterSeconds = 'Just a moment more,\nsorry to keep you waiting...', int seconds = 7}) async {
    showLoading(value);
    if (value) {
      await Future.delayed(Duration(seconds: seconds));
      if (showLoading.isTrue) {
        showLoadingText(textAfterSeconds);
      }
    } else if (!value) {
      showLoadingText('');
    }
  }
}

abstract class GeneralCallBack {
  Future<bool> onFailed(int code, String title, String msg, {dynamic data, Function()? tryAgain});
}

abstract class DidAppearAgain {
  void didAppearAgain(dynamic result);

  Future<T> moveTo<T>(ProXWidget page, {Bindings? binding});
}
