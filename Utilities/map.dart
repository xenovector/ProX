import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'utils.dart';

class UtilsMap {
  /// Waze Map App.
  void openWaze(double lat, double lng) async {
    var url = 'waze://?ll=${lat.toString()},${lng.toString()}';
    var fallbackUrl = 'https://waze.com/ul?ll=${lat.toString()},${lng.toString()}&navigate=yes';
    try {
      bool launched = await launchUrlString(url);
      if (!launched) {
        await launchUrlString(fallbackUrl);
      }
    } catch (e) {
      await launchUrlString(fallbackUrl);
    }
  }

  /// Google Map App.
  void openGoogle(double lat, double lng) async {
    var url = 'google.navigation:q=${lat.toString()},${lng.toString()}';
    var fallbackUrl = 'https://www.google.com/maps/search/?api=1&query=${lat.toString()},${lng.toString()}';
    try {
      bool launched = await launchUrlString(url);
      if (!launched) {
        await launchUrlString(fallbackUrl);
      }
    } catch (e) {
      await launchUrlString(fallbackUrl);
    }
  }

  /// Apple's Maps App.
  void openMaps(double lat, double lng) async {
    launchUrlString('https://maps.apple.com/?q=${lat.toString()},${lng.toString()}');
  }

  /// Best to refer https://pub.dev/packages/map_launcher/install.
  void autoOpen(double latitude, double longitude) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      var mapSchema = 'geo:$latitude,$longitude?q=$latitude,$longitude';
      /*if (await canLaunch('google.navigation:'))
        launch('google.navigation:q=$latitude,$longitude');*/
      if (await canLaunchUrlString('geo:')) {
        launchUrlString(mapSchema);
      } else {
        //U.show.confirmDialog('Please install waze or google map to start navigator');
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      bool canMap = await canLaunchUrlString('waze://');
      if (!canMap) {
        bool canGoogleMap = await canLaunchUrlString('comgooglemaps://');
        if (canGoogleMap) {
          launchUrlString(
              // ignore: unnecessary_brace_in_string_interps
              'comgooglemaps://?saddr=&daddr=${latitude},${longitude}&directionsmode=driving');
        } else if (await canLaunchUrlString('https://maps.apple.com/')) {
          // ignore: unnecessary_brace_in_string_interps
          launchUrlString('https://maps.apple.com/?q=${latitude},${longitude}');
        } else {
          //U.show.confirmDialog('Please install waze or google map to start navigator');
        }
      } else {
        // ignore: unnecessary_brace_in_string_interps
        launchUrlString('waze://?ll=${latitude},${longitude}&navigate=yes&zoom=17');
      }
    }
  }
}
