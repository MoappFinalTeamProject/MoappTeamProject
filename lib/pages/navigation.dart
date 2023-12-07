import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moapp_team_project/pages/chat_page/chat_room_list_page.dart';
import 'package:moapp_team_project/pages/feed_page/feed_page.dart';
import 'package:moapp_team_project/pages/home_page/home.dart';
import 'package:moapp_team_project/pages/profile_page/profile_list_page.dart';
import 'package:moapp_team_project/pages/today_date_page/today_date.dart';
import 'package:moapp_team_project/pages/gpt_cheer_page/gpt_page.dart';
import 'package:moapp_team_project/src/app_state.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentPageIndex = 2;
  @override
  Widget build(BuildContext context) {
    final appstate = Provider.of<ApplicationState>(context);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        //indicatorColor: Colors.white,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.access_time_filled,
              color: Colors.blue,
            ),
            icon: Icon(Icons.access_time),
            label: '오늘의 소개',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.feed, color: Colors.blue),
            icon: Icon(Icons.feed_outlined),
            label: '피드',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Colors.blue),
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.messenger, color: Colors.blue),
            // selectedIcon: Badge(
            //   label: Text('2'),
            //   child: Icon(Icons.messenger, color: Colors.blue),
            // ),
            icon: Icon(Icons.messenger_outline),
            // icon: Badge(
            //   label: Text('2'),
            //   child: Icon(Icons.messenger_outline),
            // ),
            label: '채팅',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle, color: Colors.blue),
            icon: Icon(Icons.account_circle_outlined),
            label: '프로필',
          ),
        ],
      ),
      body: <Widget>[
        const TodayDatePage(),
        const MyFeedPage(),
        const MyHomePage(),
        const MyChatRoomListPage(),
        const ProfileListPage(),
      ][currentPageIndex],
    );
  }
}
