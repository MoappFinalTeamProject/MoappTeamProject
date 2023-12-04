import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyGoogleMapPage extends StatefulWidget {
  final double gps1, gps2;
  final bool isMakePath;
  const MyGoogleMapPage(
      {super.key,
      required this.gps1,
      required this.gps2,
      required this.isMakePath});

  @override
  State<MyGoogleMapPage> createState() => _MyGoogleMapPageState();
}

class _MyGoogleMapPageState extends State<MyGoogleMapPage> {
  late GoogleMapController _controller;
  final List<Marker> markers = [];
  final Set<Polyline> polyline = {};
  List<LatLng> latLen = [];
  var currentPosition;

  @override
  void initState() {
    if (widget.gps1 != 0 && widget.gps2 != 0) {
      addMarker(LatLng(widget.gps1, widget.gps2));
    }
    super.initState();
  }

  addMarker(cordinate) {
    //int id = Random().nextInt(100);
    setState(() {
      markers.add(Marker(
          position: cordinate, markerId: const MarkerId("currentLocation")));
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (widget.isMakePath)
          ? FloatingActionButton(
              onPressed: () async {
                markers.clear();
                var gps = await getCurrentLocation();

                _controller.animateCamera(CameraUpdate.newLatLng(
                    LatLng(gps.latitude, gps.longitude)));

                addMarker(LatLng(gps.latitude, gps.longitude));

                latLen.clear();
                latLen.add(LatLng(
                    currentPosition.latitude, currentPosition.longitude));
                latLen.add(LatLng(widget.gps1, widget.gps2));

                for (int i = 0; i < latLen.length; i++) {
                  setState(() {});
                  polyline.add(Polyline(
                    width: 5,
                    polylineId: const PolylineId('1'),
                    points: latLen,
                    color: const Color.fromARGB(100, 66, 99, 255),
                  ));
                }
              },
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.navigation,
                color: Colors.red,
              ),
            )
          : FloatingActionButton(
              onPressed: () async {
                markers.clear();

                var gps = await getCurrentLocation();

                _controller.animateCamera(CameraUpdate.newLatLng(
                    LatLng(gps.latitude, gps.longitude)));

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
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: (widget.gps1 != 0 && widget.gps2 != 0)
              ? LatLng(widget.gps1, widget.gps2)
              : const LatLng(36.1036503441527, 129.388788549438),
          zoom: 17,
        ),
        markers: (widget.isMakePath)
            ? {
                markers[0],
                Marker(
                  markerId: const MarkerId("destination"),
                  position: LatLng(widget.gps1, widget.gps2),
                ),
              }
            : markers.toSet(),
        polylines: polyline,
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        onTap: (cordinate) {
          _controller.animateCamera(CameraUpdate.newLatLng(cordinate));
        },
      ),
    );
  }
}
