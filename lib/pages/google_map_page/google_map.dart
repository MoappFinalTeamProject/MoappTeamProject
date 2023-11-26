import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyGoogleMapPage extends StatefulWidget {
  const MyGoogleMapPage({super.key});

  @override
  State<MyGoogleMapPage> createState() => _MyGoogleMapPageState();
}

class _MyGoogleMapPageState extends State<MyGoogleMapPage> {
  late GoogleMapController _controller;
  final List<Marker> markers = [];
  var currentPosition;

  addMarker(cordinate) {
    int id = Random().nextInt(100);
    setState(() {
      markers
          .add(Marker(position: cordinate, markerId: MarkerId(id.toString())));
    });
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      currentPosition = position;
    });
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map page"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          markers.clear();
          var gps = await getCurrentLocation();

          _controller.animateCamera(
              CameraUpdate.newLatLng(LatLng(gps.latitude, gps.longitude)));

          addMarker(LatLng(gps.latitude, gps.longitude));
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.my_location,
          color: Colors.black,
        ),
      ),
      body: GoogleMap(
        zoomControlsEnabled: false,
        markers: markers.toSet(),
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: LatLng(36.1036503441527, 129.388788549438),
          zoom: 17,
        ),
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        onTap: (cordinate) {
          _controller.animateCamera(CameraUpdate.newLatLng(cordinate));
          //addMarker(cordinate);
        },
      ),
    );
  }
}
