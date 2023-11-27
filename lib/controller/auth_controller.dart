import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moapp_team_project/controller/navigation_controller.dart';

class AuthController extends ChangeNotifier {
  final _user = FirebaseAuth.instance;

  Future<void> logout() async {
    //print(NavigationController().selectedIndex);
    //await _user.signOut();
    FirebaseAuth.instance.signOut();
  }
}
