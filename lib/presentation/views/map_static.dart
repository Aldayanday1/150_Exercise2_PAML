import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StaticMap extends StatelessWidget {
  final LatLng location;

  const StaticMap({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: location,
        zoom: 18.0,
      ),
      markers: {
        Marker(
          markerId: MarkerId('selectedLocation'),
          position: location,
        ),
      },
      zoomControlsEnabled: false,
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: false,
      tiltGesturesEnabled: false,
      mapToolbarEnabled: false,
    );
  }
}
