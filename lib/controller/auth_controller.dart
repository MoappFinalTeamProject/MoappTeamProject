import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final _user = FirebaseAuth.instance;

  Future<bool> logout() async {
    try {
      await _user.signOut();
      return true;
    } catch (e) {
      print("Logout error: $e");
      return false;
    }
  }
}
