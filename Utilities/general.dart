import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:image/image.dart' as img_pkg;
import '../Helper/device.dart';
import '../Helper/hotkey.dart';
import '../Core/extension.dart';


class UtilsGeneral {
  void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void setSystemNavigationBarColor(Color color, {bool darkIcons = false}) {
    if (DevicePreferences.androidSdkVersion >= 29) return;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: color,
        systemNavigationBarIconBrightness: darkIcons ? Brightness.dark : Brightness.light));
  }

  Future<void> playSound(String name) async {
    AudioCache cache = AudioCache();
    await cache.load('sounds/$name');
    final player = AudioPlayer();
    await player.play(AssetSource('sounds/$name'));
  }

  void vibrate() async {
    var canVibrate = await Vibrate.canVibrate;
    if (canVibrate) Vibrate.vibrate();

    /*
    final Iterable<Duration> pauses = [
      const Duration(milliseconds: 500),
      const Duration(milliseconds: 1000),
      const Duration(milliseconds: 500),
    ];
    // vibrate - sleep 0.5s - vibrate - sleep 1s - vibrate - sleep 0.5s - vibrate
    Vibrate.vibrateWithPauses(pauses);
    */
  }

  Future<bool> checkRestrictFileSize(String path) async {
    Uint8List bytes = await File(path).readAsBytes();
    int fileSize = bytes.lengthInBytes;
    double sizeInMB = fileSize / 1024 / 1024;
    return sizeInMB >= 10;
  }

  Future<File> resizeImage(String path) async {
    bool isImage = false;
    if (path.endsWith('jpg') || path.endsWith('jpeg') || path.endsWith('png')) {
      isImage = true;
    }
    if (!isImage) return File(path);
    Uint8List bytes = await File(path).readAsBytes();
    int fileSize = bytes.lengthInBytes;
    double sizeInMB = fileSize / 1024 / 1024;
    //print('resizeImage.path: $path');
    //print('sizeInMB: $sizeInMB mb');
    img_pkg.Image? img = img_pkg.decodeImage(bytes);
    if (img != null) {
      bool needResize = false;
      int newWidth = 0;
      int newHeight = 0;
      if (sizeInMB >= 9) {
        needResize = true;
        double rate = 0;
        if (img.width > img.height) {
          rate = img.width / 960;
        } else if (img.height > img.width) {
          rate = img.height / 960;
        }
        newWidth = (img.width / rate).round();
        newHeight = (img.height / rate).round();
      }
      if (needResize) {
        img_pkg.Image resizedImage = img_pkg.copyResize(img, width: newWidth, height: newHeight);
        Uint8List resizedBytes = Uint8List.fromList(img_pkg.encodePng(resizedImage));
        String dir = (await getApplicationDocumentsDirectory()).path;
        String newPath = '$dir/${basename(path)}';
        File file = File(newPath);
        await file.writeAsBytes(resizedBytes);
        return file;
      }
    }
    return File(path);
  }

  bool isEmailValid(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  Future<File> downloadFile(String url, String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    String path = '$dir/$filename';
    bool isExist = await File(path).exists();
    if (isExist) return File(path);
    var httpClient = HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    File file = File(path);
    await file.writeAsBytes(bytes);
    return file;
  }

  /// Use as open url in external browser, for internal, look for show.inAppBrowser.
  Future openURL(String? url, {bool pop = false}) async {
    if (url == null || url == '') {
      return;
    } else if (await canLaunchUrlString(url)) {
      if (pop) Get.back();
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void openEmail({required String email, required String title, String? body}) async {
    var link = 'mailto:$email?subject=$title';
    if (body != null) link += '&body=$body';
    link.replaceAll(' ', '%20');
    await openURL(link);
  }

  void openWhatsapp({required String number, required String text}) async {
    final url = 'whatsapp://send?phone=$number&text=${Uri.parse(text)}';
    if (await canLaunchUrlString(url)) {
      await openURL(url);
    } else {
      //await openURL('https://wa.me/$number?text=$text');
      U.show.topFlash('Application not found.', 'You are required to install WhatsApp before you can link it over.');
    }
  }

  void openFacebookByName({required String name}) async {
    await openURL('https://fb.me/$name');
  }

  void openFacebookByID({required int pageId}) async {
    await openURL('fb://page/$pageId');
  }

  void openMessengerByName({required String name}) async {
    await openURL('https://m.me/$name');
  }

  void openMessengerByID({required int pageId}) async {
    await openURL('fb-messenger://user/$pageId'); // 111562633998062
  }

  void openInXiaoHongShu({required String user}) async {
    //user/profile/5feef3ec000000000100905e?xhsshare=CopyLink&appuid=5df750ce0000000001003b72&apptime=1679320466
    final url = 'xhsdiscover://user/$user';
    if (await canLaunchUrlString(url)) {
      await openURL(url);
    } else {
      U.show
          .topFlash('Application not found.', 'You are required to install Xiao Hong Shu before you can link it over.');
    }
  }

  void openInInstagram({required String user}) async {
    final url = 'instagram://user?username=$user';
    if (await canLaunchUrlString(url)) {
      await openURL(url);
    } else {
      U.show.topFlash('Application not found.', 'You are required to install Instagram before you can link it over.');
    }
  }

  void call({required String phone}) async {
    //phone = phone.replaceAll(' ', '');
    if (Platform.isAndroid) {
      // ignore: unnecessary_brace_in_string_interps
      launchUrlString('tel:${phone}');
    } else {
      launchUrlString('tel://${phone.replaceAll(' ', '').getEmptyOrNull ?? phone}');
    }
  }

  String numberToAlphabet(int number) {
    var alphabetList = {
      1: 'A',
      2: 'B',
      3: 'C',
      4: 'D',
      5: 'E',
      6: 'F',
      7: 'G',
      8: 'H',
      9: 'I',
      10: 'J',
      11: 'K',
      12: 'L',
      13: 'M',
      14: 'N',
      15: 'O',
      16: 'P',
      17: 'Q',
      18: 'R',
      19: 'S',
      20: 'T',
      21: 'U',
      22: 'V',
      23: 'W',
      24: 'X',
      25: 'Y',
      26: 'Z',
    };
    return alphabetList[number] ?? 'Error';
  }
}
