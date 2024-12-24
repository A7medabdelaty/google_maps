import 'package:geolocator/geolocator.dart';

late LocationPermission locationPermission;

class LocationService {
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
}
