import 'dart:async';
import 'dart:core';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart'; // new
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moapp_team_project/src/member_info_cons.dart';


class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }
  

int _memberCount = 0;
int get memberCount => _memberCount;

void set_memberCount(){
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
          notifyListeners();
        });

      } else {
        _loggedIn = false;
        _memberInfo = [];
        _memberSubscription?.cancel();
      }
      notifyListeners();
  }
  );

  }
  Future<void> addMember() {
    set_memberCount();
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    final data;
    
      data = <String, dynamic>{
        'email': FirebaseAuth.instance.currentUser!.email,
        //'name': FirebaseAuth.instance.currentUser!.displayName,
        'name' : ("$memberCount"),
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

    final member = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    notifyListeners();
    return member.set(data);
  }

}