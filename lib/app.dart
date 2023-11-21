import 'package:flutter/material.dart';
import 'package:moapp_team_project/auth/login.dart';
import 'package:moapp_team_project/auth/register.dart';
import 'package:moapp_team_project/pages/feed_page/add_feed_page.dart';
import 'package:moapp_team_project/pages/navigation.dart';

class FinalApp extends StatelessWidget {
  const FinalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '13:13',
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (BuildContext context) => const NavigationPage(),
        '/login': (BuildContext context) => const MyLoginPage(),
        '/register': (BuildContext context) => const MyRegisterPage(),
        '/addFeed': (BuildContext context) => const AddFeedPage(),
      },
      theme: ThemeData.light(useMaterial3: true),
    );
  }
}
