import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moapp_team_project/pages/home.dart';
import 'package:moapp_team_project/auth/login.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (user != null) ? const MyHomePage() : const MyLoginPage(),
    );
  }
}
