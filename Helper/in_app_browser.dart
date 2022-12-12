import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:sprintf/sprintf.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../export.dart';

class InAppBrowerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InAppBrowserController());
  }
}

class InAppBrowserController extends ProXController {
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;

  @override
  void onInit() {
    super.onInit();
    isLoading(true);
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  dynamic onJavascriptHandler(List<dynamic> args) {
    print('args: $args');
  }
}

class InAppBrowserPage extends StatelessWidget {
  final String? appBarTitle;
  final String urlLink;
  final Map<String, String>? header;
  final Map<String, String>? defaultHeader; //{'Authorization': 'Bearer ${accessToken.val}'};

  InAppBrowserPage(this.urlLink, {this.appBarTitle, this.header, this.defaultHeader});

  final InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  URLRequest getURLRequest() {
    if (urlLink.contains('html>') || urlLink.startsWith('<')) {
      return URLRequest(url: Uri.dataFromString(urlLink, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
    } else {
      return URLRequest(url: Uri.parse(urlLink), headers: header ?? defaultHeader);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProXWidget<InAppBrowserController>(
      appBar: appBarTitle.isEmptyOrNull ? null : (ctrl) => customAppBar(appBarTitle!, withBackBtn: true),
      builder: (ctrl) => InAppWebView(
        gestureRecognizers: {
          Factory(() => VerticalDragGestureRecognizer()),
          Factory(() => HorizontalDragGestureRecognizer()),
        },
        initialUrlRequest: getURLRequest(),
        initialOptions: options,
        pullToRefreshController: ctrl.pullToRefreshController,
        onWebViewCreated: (InAppWebViewController webViewController) {
          ctrl.webViewController = webViewController;
          ctrl.webViewController!.addJavaScriptHandler(handlerName: 'Flutter', callback: ctrl.onJavascriptHandler);
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) {
          //print('Page finished loading: $url');
          ctrl.pullToRefreshController?.endRefreshing();
          Future.delayed(Duration(milliseconds: 100)).then((_) {
            ctrl.isLoading(false);
          });
        },
        onLoadError: (controller, url, code, message) {
          U.show.toast(sprintf(L.GENERAL_ERROR_CODE_COLON_MSG.tr, [code, message]), context: context);
          ctrl.isLoading(false);
        },
        onLoadHttpError: (controller, url, statusCode, description) {
          U.show.toast(sprintf(L.GENERAL_ERROR_CODE_COLON_MSG.tr, [statusCode, description]), context: context);
          ctrl.isLoading(false);
        },
      ),
    );
  }
}
