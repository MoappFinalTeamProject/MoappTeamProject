import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moapp_team_project/src/app_state.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appstate = Provider.of<ApplicationState>(context);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final docRef = FirebaseFirestore.instance.collection("member").doc(_auth.currentUser!.uid);
docRef.snapshots().listen(
      (event){
        appstate.setCurrentUserName(event.data()!["name"]);
      }
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Text(appstate.currentUserName + "님" + "13:13에 오신걸 환영합니다!\n"),
    );
  }
}