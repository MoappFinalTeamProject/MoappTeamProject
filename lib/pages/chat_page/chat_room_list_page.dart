import 'package:flutter/material.dart';
import 'package:moapp_team_project/pages/chat_page/feed_chat_rooms.dart';
import 'package:moapp_team_project/pages/chat_page/matching_chat_rooms.dart';
import 'package:moapp_team_project/src/app_state.dart';
import 'package:provider/provider.dart';

class MyChatRoomListPage extends StatefulWidget {
  const MyChatRoomListPage({Key? key}) : super(key: key);

  @override
  State<MyChatRoomListPage> createState() => _MyChatRoomListPageState();
}

class _MyChatRoomListPageState extends State<MyChatRoomListPage>
    with TickerProviderStateMixin {
  late TabController myTabController;

  @override
  void initState() {
    super.initState();
    myTabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    myTabController.dispose();
    super.dispose();
  }

  final List<Tab> myTabs = <Tab>[
    const Tab(text: '피드 채팅방'),
    const Tab(text: '매칭 채팅방'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Image.asset('assets/images/1313.png', fit: BoxFit.contain),
        ),
        title: const Text('Chat Room'),
        bottom: TabBar(
          tabs: myTabs,
          controller: myTabController,
        ),
      ),
      body: TabBarView(
        controller: myTabController,
        children: const [
          MyFeedChatRoomList(),
          MyMatchingChatRoomList(),
        ],
      ),
    );
  }
}
