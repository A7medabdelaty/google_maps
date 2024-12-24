import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

late LocationPermission locationPermission;

class LocationService {
  void initLocationService(BuildContext context) {
    requestLocationService(context: context);
    requestLocationPermission();
  }

  void requestLocationService({required context}) async {
    var value = await Geolocator.isLocationServiceEnabled();
    if (!value) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(8.0),
            title: Text('Location Service is Disabled'),
            content: Text('Please enable location service to continue'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Geolocator.openLocationSettings();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
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

  getLocationStream() {
    Geolocator.getPositionStream().listen((Position position) {});
  }
}
