import 'package:geolocator/geolocator.dart';

late LocationPermission locationPermission;

class LocationService {
  Future<bool> requestLocationService() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      await Geolocator.openLocationSettings();
      isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        return false;
      }
    }
    return true;
  }

  Future<bool> requestLocationPermission() async {
    locationPermission = await Geolocator.requestPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }
    if (locationPermission == LocationPermission.deniedForever ||
        locationPermission == LocationPermission.denied) {
      return false;
    }
    return true;
  }

  void getLocationStream(void Function(Position)? onData) {
    Geolocator.getPositionStream().listen(onData);
  }
}
