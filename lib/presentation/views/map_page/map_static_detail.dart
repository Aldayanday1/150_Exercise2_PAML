import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class StaticMap extends StatefulWidget {
  final LatLng location;

  const StaticMap({Key? key, required this.location}) : super(key: key);

  @override
  _StaticMapState createState() => _StaticMapState();
}

class _StaticMapState extends State<StaticMap> {
  late GoogleMapController _mapController;
  LatLng? _currentLocation;
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  // ----------------- PERMISSION CHECK -----------------

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        print('Permission not granted');
        return;
      }
    }
    _getCurrentLocation();
  }

  // ----------------- GET LOKASI SAAT INI -----------------

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Service not enabled');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  // ----------------- GARIS POLYLINE -----------------

  void _drawRoute() {
    if (_currentLocation != null) {
      print('Current Location: $_currentLocation');
      print('Destination Location: ${widget.location}');

      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          points: [_currentLocation!, widget.location],
          color: Colors.blue,
          width: 5,
        ));
      });
      _moveCameraToFitRoute();
    } else {
      print('Current location is null');
    }
  }

  // ---------- VIEW ANTAR MARKER MAPS & LOKASI KITA ----------

  void _moveCameraToFitRoute() {
    // --- Bounds -> Jarak view antar Marker merah & Lokasi kita
    LatLngBounds bounds = LatLngBounds(
      // -- utara (atas)
      southwest: LatLng(
        (_currentLocation!.latitude <= widget.location.latitude)
            // Current --> Lokasi Saat ini
            ? _currentLocation!.latitude
            : widget.location.latitude,
        (_currentLocation!.longitude <= widget.location.longitude)
            ? _currentLocation!.longitude
            : widget.location.longitude,
      ),
      // -- selatan (bawah)
      northeast: LatLng(
        (_currentLocation!.latitude > widget.location.latitude)
            ? _currentLocation!.latitude
            : widget.location.latitude,
        (_currentLocation!.longitude > widget.location.longitude)
            ? _currentLocation!.longitude
            : widget.location.longitude,
      ),
    );
    _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 40));
  }

  void _moveCamera(LatLng location) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 17.0),
      ),
    );
  }

  void _centerMapToMarker() {
    _moveCamera(widget.location);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.location,
              zoom: 17.0,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: {
              Marker(
                markerId: MarkerId('selectedLocation'),
                position: widget.location,
              ),
            },
            polylines: _polylines,
            trafficEnabled: true,
            rotateGesturesEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
          ),
        ),
        Positioned(
          top: 65.0,
          right: 7.0,
          child: Opacity(
            opacity: 0.7,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _centerMapToMarker,
                  child: Icon(Icons.location_pin),
                  backgroundColor: Colors.white,
                  mini: true,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5.0,
          left: 7.0,
          child: Opacity(
            opacity: 0.7,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _drawRoute,
                  child: Icon(Icons.directions),
                  backgroundColor: Colors.white,
                  mini: true,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
