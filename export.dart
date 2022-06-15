export 'package:flutter/material.dart';
export 'package:get/get.dart';
export 'Core/extension.dart';
export 'Core/constant.dart';
export 'Core/pro_x.dart';
export 'Core/pro_x_dialog.dart';
export 'Core/pro_x_storage.dart';
export 'i18n/languages.dart';
export 'Theme/style.dart';
export 'Helper/confirmation_dialog.dart';
export 'Helper/device.dart';
export 'Helper/in_app_browser.dart';
export 'Helper/size_config.dart';
export 'Helper/reuseable.dart';
export 'Utilities/general.dart';
export 'Api/api_controller.dart';
export 'Api/api_setting.dart';
export 'Api/http_client.dart';
export 'Api/response.dart';

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



