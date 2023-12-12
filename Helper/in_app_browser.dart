import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:sprintf/sprintf.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../export.dart';

class InAppBrowerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InAppBrowserController());
  }
}

class InAppBrowserController extends ProXController<InAppBrowserPage> {
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

class InAppBrowserPage extends ProXWidget<InAppBrowserController> {
  final String? appBarTitle;
  final String urlLink;
  final Map<String, String>? header;
  final Map<String, String>? defaultHeader; //{'Authorization': 'Bearer ${accessToken.val}'};

  InAppBrowserPage(this.urlLink, {this.appBarTitle, this.header, this.defaultHeader});

  @override
  String get routeName => '/InAppBrowserPage';

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
    return ProXScaffold<InAppBrowserController>(
      appBar: (ctrl) => appBarTitle.isEmptyOrNull ? null : customAppBar(appBarTitle!, withBackBtn: true),
      builder: (ctrl) =>  InAppWebView(
        /*gestureRecognizers: {
          Factory(() => VerticalDragGestureRecognizer()),
          Factory(() => HorizontalDragGestureRecognizer()),
        },*/
        initialUrlRequest: getURLRequest(),
        initialOptions: options,
        pullToRefreshController: c.pullToRefreshController,
        onWebViewCreated: (InAppWebViewController webViewController) async {
          c.webViewController = webViewController;
          c.webViewController!.addJavaScriptHandler(handlerName: 'Flutter', callback: c.onJavascriptHandler);

          /*bool isAndroidWebSupported = await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.WEB_MESSAGE_LISTENER);

          print('isAndroidWebSupported: $isAndroidWebSupported');

          if (!Platform.isAndroid || isAndroidWebSupported) {
            await ctrl.webViewController?.addWebMessageListener(WebMessageListener(
              jsObjectName: "Flutter",
              onPostMessage: (message, sourceOrigin, isMainFrame, replyProxy) {
                print('webView.message: ${message ?? 'null'}');
                Future.delayed(const Duration(seconds: 1), () {
                  if (isBack) return;
                  if (message != null && message == 'payment_success') {
                    isBack = true;
                    // Get.back(result: 'completePayment');
                    //Navigator.of(context).pop('completePayment');
                  } else if (message != null && message == 'payment_fail') {
                    isBack = true;
                    // Get.back(result: 'cancelPayment');
                   // Navigator.of(context).pop('cancelPayment');
                  }
                });
              },
            ));
          }*/
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) async {
          print('InAppWebView finished loading: $url');
          c.pullToRefreshController?.endRefreshing();
          await Future.delayed(Duration(milliseconds: 100));
          c.isLoading(false);

        },
        onLoadError: (controller, url, code, message) {
          U.show.toast(sprintf(L.GENERAL_ERROR_CODE_COLON_MSG.tr, [code, message]), context: context);
          c.isLoading(false);
        },
        onLoadHttpError: (controller, url, statusCode, description) {
          U.show.toast(sprintf(L.GENERAL_ERROR_CODE_COLON_MSG.tr, [statusCode, description]), context: context);
          c.isLoading(false);
        },
      ),
    );
  }
}
