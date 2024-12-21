import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late CameraPosition initialCameraPosition;

  late GoogleMapController mapController;

  @override
  void initState() {
    initialCameraPosition = CameraPosition(
      target: LatLng(30.54784687684049, 31.12807335054871),
      zoom: 12,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        GoogleMap(
          cameraTargetBounds: CameraTargetBounds(
            LatLngBounds(
              southwest: LatLng(21.999299540452224, 24.968977091465547),
              northeast: LatLng(31.328894771153053, 34.19815133092022),
            ),
          ),
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          initialCameraPosition: initialCameraPosition,
        ),
        ElevatedButton(
          onPressed: () {
            mapController.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(30.54784687684049, 31.12807335054871),
              ),
            );
            setState(() {});
          },
          child: Text('Navigate to Home'),
        ),
      ],
    );
  }
}
