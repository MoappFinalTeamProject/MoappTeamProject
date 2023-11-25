import 'package:flutter/material.dart';
import 'package:moapp_team_project/auth/login.dart';
import 'package:moapp_team_project/auth/register.dart';
import 'package:moapp_team_project/pages/feed_page/add_feed_page.dart';
import 'package:moapp_team_project/pages/navigation.dart';
import 'package:moapp_team_project/pages/onBorading_page/onBorading.dart';
import 'package:moapp_team_project/provider/chatGPT_model.dart';
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
          '/onBoard': (BuildContext context) => const OnBoardingPage(),
          
        },
        theme: ThemeData.light(useMaterial3: true),
      ),
    );
  }
}
