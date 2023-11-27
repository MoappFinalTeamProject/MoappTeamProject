import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart'; // new
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:moapp_team_project/src/member_info_cons.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  String _currentUserName = "";
  String get currentUserName => _currentUserName;

  void setCurrentUserName(String name) {
    _currentUserName = name;
    //notifyListeners();
  }

  int _currentImageSliderIndex = 0;
  int get currentImageSliderIndex => _currentImageSliderIndex;
  void setCurrentImageSliderIndex(int index) {
    _currentImageSliderIndex = index;
    // notifyListeners();
  }

  int _currentGenderIndex = 0;
  int get currentGenderIndex => _currentGenderIndex;
  void SetCurrentGenderIndex(int index) {
    _currentGenderIndex = index;
    // notifyListeners();
  }

  int _memberCount = 0;
  int get memberCount => _memberCount;

  void set_memberCount() {
    _memberCount++;
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _memberSubscription;
  List<MemberInfoCons> _memberInfo = [];

  List<MemberInfoCons> get memberInfo => _memberInfo;

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;

        _memberSubscription = FirebaseFirestore.instance
            .collection('member')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _memberInfo = [];
          for (final document in snapshot.docs) {
            _memberInfo.add(
              MemberInfoCons(
                name: document.data()['name'] as String,
                email: document.data()['email'] as String,
                uid: document.data()['uid'] as String,
                time: document.data()['timestamp'] as int,
              ),
            );
          }
          //notifyListeners();
        });
      } else {
        _loggedIn = false;
        _memberInfo = [];
        _memberSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  Future<void> addMember() {
    set_memberCount();
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    final data;

    data = <String, dynamic>{
      'email': FirebaseAuth.instance.currentUser!.email,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    final member = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    notifyListeners();
    return member.set(data);
  }

  Future<void> addMemberInfo() {
    set_memberCount();
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    final data;

    data = <String, dynamic>{
      'name': "",
      'birthday': "",
      'age': "",
      'phone number': "",
      'gender': "",
    };

    final member = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("member info")
        .doc('basic info');
    notifyListeners();
    return member.set(data);
  }

  Future<List<String>> getProfilePics() async {
    FirebaseStorage storage = FirebaseStorage.instance;

    final profilePicsRef = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("member info")
        .doc('profile pictures');

    final profilePicsDoc = await profilePicsRef.get();
    final profilePicsData = profilePicsDoc.data();

    List<String> profilePicUrls = [];

    try {
      var url1 = await storage
          .ref('profile/${profilePicsData?['pic1']}')
          .getDownloadURL();
      var url2 = await storage
          .ref('profile/${profilePicsData?['pic2']}')
          .getDownloadURL();
      var url3 = await storage
          .ref('profile/${profilePicsData?['pic3']}')
          .getDownloadURL();

      profilePicUrls.add(url1);
      profilePicUrls.add(url2);
      profilePicUrls.add(url3);
    } catch (e) {
      print(e);
    }

    return profilePicUrls;
  }

  Future<void> addProfilePics(List<String> _url) {
    set_memberCount();
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    final data;

    data = <String, dynamic>{
      'pic1': _url[0],
      'pic2': _url[1],
      'pic3': _url[2],
    };

    final member = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("member info")
        .doc('profile pictures');
    notifyListeners();
    return member.set(data);
  }

  Future<void> updateInformation(
      String name, String birthday, int age, String phoneNum) async {
    FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'name': name,
    });

    final member = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("member info")
        .doc('basic info')
        .update({
      'name': name,
      'birthday': birthday,
      'age': "${age}",
      'phone number': phoneNum,
      'gender': _currentGenderIndex == 0 ? "M" : "W",
    });
    notifyListeners();

    return member;
  }
}
