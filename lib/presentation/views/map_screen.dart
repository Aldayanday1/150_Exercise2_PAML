import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final Function(LatLng, String) onLocationSelected;
  final LatLng? currentLocation;
  final String? currentAddress;

  const MapScreen({
    Key? key,
    required this.onLocationSelected,
    this.currentLocation,
    this.currentAddress,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? _lastMapPosition;
  String? _lastAddress;

  @override
  void initState() {
    super.initState();
    if (widget.currentLocation != null) {
      _lastMapPosition = widget.currentLocation;
      _lastAddress = widget.currentAddress;
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });

    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _lastMapPosition = LatLng(position.latitude, position.longitude);
    });

    if (_lastMapPosition != null) {
      mapController.animateCamera(CameraUpdate.newLatLng(_lastMapPosition!));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_lastMapPosition != null) {
      mapController.animateCamera(CameraUpdate.newLatLng(_lastMapPosition!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        buildingsEnabled: true,
        trafficEnabled: true,
        zoomControlsEnabled: true,
        rotateGesturesEnabled: true,
        mapToolbarEnabled: true,
        compassEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _lastMapPosition ??
              LatLng(-7.801194, 110.364917), // Lokasi default jika null
          zoom: 20.0,
        ),
        markers: {
          if (_lastMapPosition != null)
            Marker(
              markerId: MarkerId('currentLocation'),
              position: _lastMapPosition!,
            ),
        },
        onTap: (position) {
          setState(() {
            _lastMapPosition = position;
          });
          _updateSelectedLocation(position);
        },
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tap untuk memperbarui alamat',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_lastMapPosition != null) {
                  _updateSelectedLocation(_lastMapPosition!);
                }
              },
              child: Text('Pilih Lokasi Ini'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateSelectedLocation(LatLng position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String fullAddress =
          "${place.subLocality}, ${place.locality}, ${place.country}.";
      setState(() {
        _lastAddress = fullAddress;
      });
      widget.onLocationSelected(position, fullAddress);
    }
  }
}



  // void _updateSelectedLocation(LatLng position) async {
  //   List<Placemark> placemarks = await placemarkFromCoordinates(
  //     position.latitude,
  //     position.longitude,
  //   );
  //   if (placemarks.isNotEmpty) {
  //     Placemark place = placemarks[0];
  //     String fullAddress =
  //         "${place.subLocality}, ${place.locality}, ${place.country}.";
  //     if (fullAddress != widget.currentAddress) {
  //       widget.onLocationSelected(fullAddress);
  //     }
  //   }
  // }