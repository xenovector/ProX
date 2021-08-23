import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as Permission;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:huawei_location/location/location.dart' as hms;
import 'package:huawei_location/location/fused_location_provider_client.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:huawei_location/activity/activity_conversion_data.dart';
// import 'package:huawei_location/activity/activity_conversion_info.dart';
// import 'package:huawei_location/activity/activity_conversion_response.dart';
// import 'package:huawei_location/activity/activity_identification_data.dart';
// import 'package:huawei_location/activity/activity_identification_response.dart';
// import 'package:huawei_location/activity/activity_identification_service.dart';
// import 'package:huawei_location/geofence/geofence.dart';
// import 'package:huawei_location/geofence/geofence_data.dart';
// import 'package:huawei_location/geofence/geofence_request.dart';
// import 'package:huawei_location/geofence/geofence_service.dart';
// import 'package:huawei_location/location/hwlocation.dart';
// import 'package:huawei_location/location/location_availability.dart';
// import 'package:huawei_location/location/location_callback.dart';
// import 'package:huawei_location/location/location_request.dart';
// import 'package:huawei_location/location/location_result.dart';
// import 'package:huawei_location/location/location_settings_request.dart';
// import 'package:huawei_location/location/location_settings_states.dart';
// import 'package:huawei_location/location/navigation_request.dart';
// import 'package:huawei_location/location/navigation_result.dart';
import 'package:huawei_location/permission/permission_handler.dart';
import '../export.dart';

class ProXLocation {
  static ProXLocation shared = ProXLocation();
  bool serviceEnabled = false;
  bool permissionGranted = false;
  Future<ProXLocationData?> get locationData async => permissionGranted ? await _getLocationData() : null;

  Future<ProXLocationData?> init() async {
    bool shouldUseHMS = await ProX.isHMS();
    if (shouldUseHMS) {
      PermissionHandler permissionHandler = PermissionHandler();
      try {
        bool status = await permissionHandler.requestLocationPermission();
        if (!status) return null;
        serviceEnabled = true;
        permissionGranted = true;
        hms.Location location = await FusedLocationProviderClient().getLastLocation();
        print('HMS.location =>\nlongitude: ${location.longitude}\nlatitude: ${location.latitude}');
      } catch (e) {
        print(e.toString);
        return null;
      }
    } else {
      Location location = Location();
      PermissionStatus permissionStatus;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return null;
        }
      }

      permissionStatus = await location.hasPermission();
      if (permissionStatus == PermissionStatus.deniedForever) {
        return null;
      } else if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await location.requestPermission();
        if (permissionStatus == PermissionStatus.denied || permissionStatus == PermissionStatus.deniedForever) {
          return null;
        }
      }
      permissionGranted = true;
      LocationData _locationData = await location.getLocation();
      print('GMS.location =>\nlongitude: ${_locationData.longitude}\nlatitude: ${_locationData.latitude}');
    }
    return locationData;
  }

  Future<ProXLocationData?> _getLocationData() async {
    bool shouldUseHMS = await ProX.isHMS();
    double? longitude;
    double? latitude;
    double? altitude;
    double? speed;
    double? time;
    if (shouldUseHMS) {
      hms.Location location = await FusedLocationProviderClient().getLastLocation();
      longitude = double.parse(location.longitude.toStringAsFixed(12));
      latitude = double.parse(location.latitude.toStringAsFixed(12));
      altitude = double.parse(location.altitude.toString());
      speed = location.speed;
      time = location.time.toDouble();
    } else {
      Location _l = Location.instance;
      await _l.enableBackgroundMode(enable: true);
      LocationData location = await _l.getLocation();
      longitude = double.parse((location.longitude ?? 0).toStringAsFixed(12));
      latitude = double.parse((location.latitude ?? 0).toStringAsFixed(12));
      altitude = double.parse(location.altitude.toString());
      speed = location.speed;
      time = location.time;
    }
    //if (latitude == 0 || longitude == 0) return null;
    print('latitude: $latitude, longitude $longitude');
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(latitude, longitude);
    geo.Placemark? placemark = placemarks.length > 0 ? placemarks[0] : null;
    if (placemark == null) return null;
    return ProXLocationData(
      street: placemark.street,
      city: placemark.subLocality,
      state: placemark.locality,
      country: placemark.country,
      countryCode: placemark.isoCountryCode,
      postalCode: placemark.postalCode,
      longitude: longitude,
      latitude: latitude,
      altitude: altitude,
      speed: speed,
      time: time,
    );
  }

  Future<bool> openAppSetting() {
    return Permission.openAppSettings();
  }
}

class ProXLocationData {
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? countryCode;
  final String? postalCode;
  final double? longitude;
  final double? latitude;
  final double? altitude;
  final double? speed;
  final double? time;

  ProXLocationData(
      {this.street,
      this.city,
      this.state,
      this.country,
      this.countryCode,
      this.postalCode,
      this.longitude,
      this.latitude,
      this.altitude,
      this.speed,
      this.time});

  @override
  String toString() {
    return '$street, $postalCode, $city, $state, $country';
  }
}
