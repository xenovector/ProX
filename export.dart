export 'package:flutter/material.dart';
export 'package:flutter/foundation.dart';
export 'package:get/get.dart';
export 'Core/extension.dart';
export 'Core/prox_constant.dart';
export 'Core/prox_locker.dart';
export 'Core/prox_controller.dart';
export 'Core/prox_scaffold.dart';
export 'Core/prox_widget.dart';
export 'i18n/languages.dart';
export 'Helper/device.dart';
export 'Helper/sizer.dart';
export 'Helper/in_app_browser.dart';
export 'Helper/hotkey.dart';
export 'Utilities/general.dart';
export 'Api/api_controller.dart';
export 'Api/response.dart';
export '../ReuseableWidget/default/reuseable.dart';
export '../ReuseableWidget/default/confirmation_dialog.dart';
export '../ReuseableWidget/default/image_view.dart';

//import 'ProX/export.dart';

// ----- Pull to refresh example ----- //
//import 'package:pull_to_refresh/pull_to_refresh.dart';

// final refreshCtrl = RefreshController();
// List<T> list = [];
// int listingPage = 1;
// bool isFinished = false;

// isLoading(true);
// List<T>? _list = await getList(1, onFailed);
// list = _list ?? [];
// isLoading(false);
// update();

// void onRefresh() async {
//   listingPage = 1;
//   isFinished = false;
//   List<T>? _list = await getList(1, onFailed);
//   if (_list != null && _list != []) list = _list;
//   update();
//   refreshCtrl.refreshCompleted(resetFooterState: true);
// }

// void onLoadMore() async {
//   if (isFinished) {
//     refreshCtrl.loadNoData();
//   } else {
//     List<T>? _list = await getList(listingPage + 1, onFailed);
//     if (_list != null && _list != []) {
//       listingPage += 1;
//       list += _list;
//       update();
//       refreshCtrl.loadComplete();
//     } else {
//       isFinished = true;
//       refreshCtrl.loadNoData();
//     }
//   }
// }

// SmartRefresher(
//             enablePullDown: true,
//             enablePullUp: true,
//             controller: ctrl.refreshCtrl,
//             onRefresh: ctrl.onRefresh,
//             onLoading: ctrl.onLoadMore,



