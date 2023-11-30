import 'package:flutter/material.dart';
import 'package:moapp_team_project/auth/login.dart';
import 'package:moapp_team_project/auth/register.dart';

import 'package:moapp_team_project/controller/auth_controller.dart';
import 'package:moapp_team_project/pages/card_flip/cardFlip.dart';

import 'package:moapp_team_project/pages/face_detection_page/face_detect_page.dart';

import 'package:moapp_team_project/pages/feed_page/add_feed_page.dart';
import 'package:moapp_team_project/pages/google_map_page/google_map.dart';
import 'package:moapp_team_project/pages/navigation.dart';
import 'package:moapp_team_project/pages/onBorading_page/onBorading.dart';
import 'package:moapp_team_project/provider/chatGPT_model.dart';
import 'package:moapp_team_project/pages/gpt_cheer_page/gpt_page.dart';
import 'package:moapp_team_project/provider/mlkit_model.dart';

import 'package:provider/provider.dart';

class FinalApp extends StatelessWidget {
  const FinalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GPTModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthController(),
        ),
        ChangeNotifierProvider(
          create: (context) => MLkitModel(),
        ),
      ],
      child: MaterialApp(
        title: '13:13',
        initialRoute: '/login',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (BuildContext context) => const NavigationPage(),
          '/login': (BuildContext context) => const MyLoginPage(),
          '/register': (BuildContext context) => const MyRegisterPage(),
          '/addFeed': (BuildContext context) => const AddFeedPage(),
          '/gptPage': (BuildContext context) => const MyGPTPage(),
          '/onBoard': (BuildContext context) => const OnBoardingPage(),
          '/faceDetect': (BuildContext context) => const MyFaceDetection(),
          '/googleMap': (BuildContext context) => const MyGoogleMapPage(),
          '/cardFlip': (BuildContext context) => const MyCardFlipPage(),
        },
        theme: ThemeData.light(useMaterial3: true),
      ),
    );
  }
}
