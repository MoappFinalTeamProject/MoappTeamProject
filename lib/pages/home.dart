import 'package:flutter/material.dart';
import 'package:moapp_team_project/pages/chat_page/chat_room_list_page.dart';
import 'package:moapp_team_project/pages/feed_page/feed_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyFeedPage()),
                );
              },
              child: Text('Feed page'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyChatRoomListPgae()),
                );
              },
              child: Text('Chat page'),
            ),
          ),
        ],
      ),
    );
  }
}
