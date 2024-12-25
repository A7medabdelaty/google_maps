import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/utils/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController mapController;
  late BitmapDescriptor icon;
  late LocationService locationService;

  LatLng homeLocation = LatLng(30.54784687684049, 31.12807335054871);
  Set<Marker> mapMarkers = {};

  @override
  void initState() {
    initCameraPosition();
    initMapStyle();
    initMapIconImage();
    locationService = LocationService();
    updateCameraLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        GoogleMap(
          markers: mapMarkers,
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
            initMapStyle();
          },
          initialCameraPosition: initialCameraPosition,
        ),
        ElevatedButton(
          onPressed: () {
            navigateToHome();
          },
          child: Text('Navigate to Home'),
        ),
      ],
    );
  }

  void initCameraPosition() {
    initialCameraPosition = CameraPosition(
      target: LatLng(30.54784687684049, 31.12807335054871),
      zoom: 12,
    );
  }

  void initMapIconImage() async {
    icon = await BitmapDescriptor.asset(
      ImageConfiguration(
        size: Size(15, 18),
      ),
      'assets/images/google_map_icon.jpg',
    );
  }

  void initMapStyle() {
    rootBundle.loadString('assets/map_styles/dark_map_style.json').then(
      (string) {
        mapController.setMapStyle(string);
      },
    );
  }

  void navigateToHome() {
    addHomeMarker();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: homeLocation,
          zoom: 15,
        ),
      ),
    );
  }

  void addHomeMarker() async {
    mapMarkers.add(
      Marker(
        icon: icon,
        markerId: MarkerId('marker one'),
        position: homeLocation,
        infoWindow: InfoWindow(
          title: 'Home',
          snippet: 'This is my home',
        ),
      ),
    );
    setState(() {});
  }

  void updateCameraLocation() async {
    await locationService.requestLocationService();
    var hasLocationPermission =
        await locationService.requestLocationPermission();
    if (hasLocationPermission) {
      locationService.getLocationStream(
        (positionData) {
          navigateToCurrentLocation(positionData);
          addLocationMarker(positionData);
        },
      );
    }
  }

  var firstCall = true;

  void navigateToCurrentLocation(Position positionData) {
    if (firstCall) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              positionData.latitude,
              positionData.longitude,
            ),
            zoom: 15,
          ),
        ),
      );
      firstCall = false;
      return;
    }
    mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          positionData.latitude,
          positionData.longitude,
        ),
      ),
    );
  }

  void addLocationMarker(Position positionData) {
    mapMarkers.add(
      Marker(
        icon: icon,
        markerId: MarkerId('marker two'),
        position: LatLng(
          positionData.latitude,
          positionData.longitude,
        ),
        infoWindow: InfoWindow(
          title: 'Current Location',
          snippet: 'This is your current location',
        ),
      ),
    );
    setState(() {});
  }
}
