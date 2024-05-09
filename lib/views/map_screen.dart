import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  // onLocationSelected ialah variable yg bertipekan function yg menerima parameter dalam bentuk string
  final Function(String)
      onLocationSelected; // Callback function to return the address

  final String? currentAddress;

  const MapScreen(
      {super.key, required this.onLocationSelected, this.currentAddress});

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController; // Controller for the Google Map
  LatLng? _lastMapPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Request permissions on Init
  }

  // Fetch the current location
  Future<void> _getCurrentLocation() async {
    // Check if location services are enabled
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });

    // Get the current position
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _lastMapPosition = LatLng(position.latitude, position.longitude);
    });
    mapController.animateCamera(CameraUpdate.newLatLng(_lastMapPosition!));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_lastMapPosition != null) {
      setState(() {
        mapController.animateCamera(CameraUpdate.newLatLng(_lastMapPosition!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        buildingsEnabled: true,
        trafficEnabled: true,
        zoomControlsEnabled: true,
        rotateGesturesEnabled: true,
        mapToolbarEnabled: true,

        // on below line setting compass enabled.
        compassEnabled: true,
        onMapCreated: _onMapCreated,
        //mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _lastMapPosition ??
              const LatLng(-7.801194, 110.364917), // Jogja coordinates
          zoom: 20.0,
        ),
        markers: {
          if (_lastMapPosition != null)
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: _lastMapPosition!,
            ),
        },
        onTap: (position) {
          setState(() {
            _lastMapPosition = position;
          });
        },
      ),
      floatingActionButton: _lastMapPosition != null
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                      _lastMapPosition!.latitude,
                      _lastMapPosition!.longitude,
                    );
                    if (placemarks.isNotEmpty) {
                      Placemark place = placemarks[0];
                      String fullAddress =
                          '${place.subLocality}, ${place.locality}, ${place.country}.';
                      if (fullAddress != widget.currentAddress) {
                        widget.onLocationSelected(fullAddress);
                        Navigator.pop(context, fullAddress);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Silakan ubah alamat')),
                        );
                      }
                    } else {
                      widget.onLocationSelected("No address found");
                      Navigator.pop(context, "No address found");
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            )
          : null,
    );
  }
}
