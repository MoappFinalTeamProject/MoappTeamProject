// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:moapp_team_project/pages/chat_page/chat_room_list_page.dart';
// import 'package:moapp_team_project/pages/feed_page/feed_page.dart';
// import 'package:moapp_team_project/pages/home_page/home.dart';
// import 'package:moapp_team_project/pages/profile_page/profile_list_page.dart';
// import 'package:moapp_team_project/test.dart';

// class NavigationController extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   int _selectedIndex = 1;

//   int get selectedIndex => _selectedIndex;
//   void setSelectedIndex(int index) {
//     _selectedIndex = index;
//     print(_selectedIndex);
//     notifyListeners();
//   }

//   Widget getPageByIndex() {
//     return IndexedStack(
//       index: _selectedIndex,
//       children: const [
//         MyTestPage(),
//         //const TodayDatePage(),
//         MyFeedPage(),
//         MyHomePage(),
//         MyChatRoomListPage(),
//         ProfileListPage(),
//       ],
//     );
//   }

//   bool isEmailVerified() {
//     bool isVerified = false;

//     if (_auth.currentUser!.emailVerified) {
//       isVerified = true;
//     } else {
//       isVerified = false;
//     }

//     return isVerified;
//   }
// }