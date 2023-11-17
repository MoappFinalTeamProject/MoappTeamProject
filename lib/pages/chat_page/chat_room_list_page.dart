import 'package:flutter/material.dart';
import 'package:moapp_team_project/pages/chat_page/feed_chat_rooms.dart';
import 'package:moapp_team_project/pages/chat_page/matching_chat_rooms.dart';

class MyChatRoomListPgae extends StatefulWidget {
  const MyChatRoomListPgae({super.key});

  @override
  State<MyChatRoomListPgae> createState() => _MyChatRoomListPgaeState();
}

class _MyChatRoomListPgaeState extends State<MyChatRoomListPgae>
    with TickerProviderStateMixin {
  late TabController myTabController;

  @override
  void initState() {
    super.initState();
    myTabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat Room'),
        ),
        body: TabBarView(
          controller: myTabController,
          children: [
            MyFeedChatRoomList(),
            MyMatchingChatRoomList(),
          ],
        ));
  }
}
