import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late CameraPosition initialCameraPosition;

  late GoogleMapController mapController;
  LatLng homeLocation = LatLng(30.54784687684049, 31.12807335054871);

  @override
  void initState() {
    initialCameraPosition = CameraPosition(
      target: LatLng(30.54784687684049, 31.12807335054871),
      zoom: 12,
    );
    initMapStyle();
    //initMapMarkers();
    super.initState();
  }

  Set<Marker> mapMarkers = {};

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        GoogleMap(
          markers: mapMarkers,
          cameraTargetBounds: CameraTargetBounds(
            LatLngBounds(
              southwest: LatLng(21.999299540452224, 24.968977091465547),
              northeast: LatLng(31.328894771153053, 34.19815133092022),
            ),
          ),
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

  void navigateToHome() {
    initMapMarkers();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: homeLocation,
          zoom: 15,
        ),
      ),
    );
  }

  void initMapStyle() {
    rootBundle.loadString('assets/map_styles/dark_map_style.json').then(
      (string) {
        mapController.setMapStyle(string);
      },
    );
  }

  void initMapMarkers() {
    mapMarkers.add(
      Marker(
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
}
