import 'package:location/location.dart';

class LocationProvider {
  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData locationData;

  Future<void> checkForLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    print(
        '=============== LATITUDE: ${locationData.latitude} ===============');
    print(
        '=============== LONGITUDE: ${locationData.longitude} ===============');
  }

  Future<LocationData> getCurrentLocation() async {
    return await location.getLocation();
  }
}
