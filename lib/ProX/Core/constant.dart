import 'package:flutter/foundation.dart';

// Testing
bool skipForTest = !kReleaseMode;

//General Message
const Test_Title = 'This is a test Title';
const Test_Message =
    'Lorem test text, this message is a Lorem testing message to test the UI in different length situation.';

// GoogleApiKey for Map API or Cloud API
// var googleApiKey = 'AIzaSyArUIWzNvSv-cj2awcUapj7oxef0BzKLF0';

// Social Login
/*final FacebookLogin facebookSignIn = new FacebookLogin();
final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);*/



/*Future<bool> requestCameraStoragePermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.photos,
    Permission.storage,
  ].request();

  bool isAllGranted = true;
  statuses.forEach((key, value) {
    if (!value.isGranted) {
      isAllGranted = false;
    }
  });

  return isAllGranted;
}*/

/*void showCameraStoragePermissionDialog(BuildContext context) {
  showConfirmCancel(
    context,
    AppLocalizations.of(context).translate(Lang.Dialog_Title_Notice) ??
        'Notice',
    Platform.isAndroid
        ? AppLocalizations.of(context).translate(
                Lang.Permission_CameraStorage_Message_GrantAccess_Android) ??
            'Please grant Camera and Storage permission from App Settings before proceeding.'
        : AppLocalizations.of(context).translate(
                Lang.Permission_CameraStorage_Message_GrantAccess_Android) ??
            'Please grant Camera and Photos permission from App Settings before proceeding.',
    positive: AppLocalizations.of(context)
            .translate(Lang.Dialog_Action_GoToAppSettings) ??
        'Go to App Settings',
    negative:
        AppLocalizations.of(context).translate(Lang.Dialog_Action_Cancel) ??
            'Cancel',
    confirm: () async {
      await AppSettings.openAppSettings();
    },
  );
}*/

// String getFullAddressFromGeolocatorPlace(Placemark placemark) {
//   String address = '';
//   if (placemark.name == placemark.thoroughfare) {
//     address = '${placemark.name}, '
//         '${placemark.postalCode}, ${placemark.locality}, '
//         '${placemark.administrativeArea}, ${placemark.country}';
//   } else {
//     address = '${placemark.name}, ${placemark.thoroughfare}, '
//         '${placemark.postalCode}, ${placemark.locality}, '
//         '${placemark.administrativeArea}, ${placemark.country}';
//   }
//
//   if (address.startsWith(',')) {
//     address = address.replaceFirst(',', '');
//   }
//   address = address.replaceAll(', ,', ',');
//   address = address.replaceAll(', ,', ',');
//
//   return address ?? '';
// }

// Future<bool> requestLocationService() async {
//   Location location = new Location();
//
//   bool _serviceEnabled = await location.serviceEnabled();
//   // if (!_serviceEnabled) {
//   //   _serviceEnabled = await location.requestService();
//
//   //   return _serviceEnabled;
//   // }
//
//   return _serviceEnabled;
// }

// Future<bool> requestLocationPermission() async {
//   Location location = new Location();
//
//   PermissionStatus _permissionGranted;
//
//   _permissionGranted = await location.hasPermission();
//   if (_permissionGranted == PermissionStatus.denied) {
//     _permissionGranted = await location.requestPermission();
//
//     if (_permissionGranted == PermissionStatus.denied ||
//         _permissionGranted == PermissionStatus.deniedForever) {
//       return false;
//     } else {
//       return true;
//     }
//   } else if (_permissionGranted == PermissionStatus.deniedForever) {
//     return false;
//   } else {
//     return true;
//   }
// }

/*Future<bool> requestLocationService() async {
  Location location = new Location();

  bool _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();

    return _serviceEnabled;
  }

  return _serviceEnabled;
}

Future<bool> requestLocationPermission() async {
  Location location = new Location();

  PermissionStatus _permissionGranted;

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();

    if (_permissionGranted == PermissionStatus.denied ||
        _permissionGranted == PermissionStatus.deniedForever) {
      return false;
    } else {
      return true;
    }
  } else if (_permissionGranted == PermissionStatus.deniedForever) {
    return false;
  } else {
    return true;
  }
}

Future<bool> requestCameraStoragePermission() async {
  Map<PermissionManager.Permission, PermissionManager.PermissionStatus>
      statuses = await [
    PermissionManager.Permission.camera,
    PermissionManager.Permission.storage,
  ].request();

  bool isAllGranted = true;
  statuses.forEach((key, value) {
    if (!value.isGranted) {
      isAllGranted = false;
    }
  });

  return isAllGranted;
}*/
