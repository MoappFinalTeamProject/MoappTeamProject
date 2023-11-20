import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moapp_team_project/app.dart';
import 'package:moapp_team_project/src/app_state.dart';
import 'package:moapp_team_project/pages/navigation.dart';
import 'package:moapp_team_project/auth/login.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const FinalApp()),
    ));
}