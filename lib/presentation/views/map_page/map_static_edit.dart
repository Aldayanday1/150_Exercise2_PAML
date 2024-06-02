import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class StaticMapEdit extends StatefulWidget {
  final LatLng location;
  final Function(LatLng, String) onLocationChanged;

  const StaticMapEdit({
    Key? key,
    required this.location,
    required this.onLocationChanged,
  }) : super(key: key);

  @override
  _StaticMapEditState createState() => _StaticMapEditState();
}

class _StaticMapEditState extends State<StaticMapEdit> {
  late GoogleMapController _mapController;
  late LatLng _currentLocation;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.location;
  }

  @override
  void didUpdateWidget(covariant StaticMapEdit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location) {
      _moveCamera(widget.location);
      _currentLocation = widget.location;
    }
  }

  void _moveCamera(LatLng location) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 17.0),
      ),
    );
  }

  void _onMapTap(LatLng position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String fullAddress =
          "${place.subLocality}, ${place.locality}, ${place.country}";
      widget.onLocationChanged(position, fullAddress);
      setState(() {
        _currentLocation = position;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation,
          zoom: 17.0,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        onTap: _onMapTap,
        markers: {
          Marker(
            markerId: MarkerId('selectedLocation'),
            position: _currentLocation,
            draggable: true,
            onDragEnd: (newPosition) {
              _onMapTap(newPosition);
            },
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        },
        trafficEnabled: true,
        rotateGesturesEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
      ),
    );
  }
}
