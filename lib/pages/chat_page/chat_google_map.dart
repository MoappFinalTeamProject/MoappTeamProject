import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyChatGoogleMapPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const MyChatGoogleMapPage({super.key, required this.data});

  @override
  State<MyChatGoogleMapPage> createState() => _MyChatGoogleMapPageState();
}

class _MyChatGoogleMapPageState extends State<MyChatGoogleMapPage> {
  late GoogleMapController _controller;
  final List<Marker> markers = [];
  var currentPosition;
  late double gps1, gps2;

  addMarker(cordinate) {
    gps1 = cordinate.latitude;
    gps2 = cordinate.longitude;
    markers.clear();
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

  Future<void> _handleSubmittedLocatoin(Map<String, dynamic> data) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final temp = FirebaseFirestore.instance
        .collection('chatRoomsList')
        .doc(data['id'])
        .collection('messages')
        .doc();

    FieldValue time = FieldValue.serverTimestamp();

    var querySnapshot = await FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('member info')
        .doc('basic info')
        .get();

    if (querySnapshot.exists) {
      var userData = querySnapshot.data();
      var userName = userData!['name'];
      await temp.set({
        "id": temp.id,
        "uid": uid,
        "created_at": time,
        "location1": gps1,
        "location2": gps2,
        "name": userName,
        "image_url": "",
        "type": 'location',
      });
    } else {
      // 문서가 없는 경우 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("공유할 위치 선택"),
        actions: [
          TextButton(
            onPressed: (markers.isNotEmpty)
                ? () {
                    _handleSubmittedLocatoin(widget.data).then(
                      (value) => Navigator.pop(context),
                    );
                  }
                : null,
            child: Text(
              '공유하기',
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
          addMarker(cordinate);
        },
      ),
    );
  }
}
