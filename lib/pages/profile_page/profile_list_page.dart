import 'package:flutter/material.dart';
import 'package:moapp_team_project/pages/profile_page/setting.dart';
import 'package:moapp_team_project/pages/profile_page/my_information.dart';
import 'package:moapp_team_project/pages/profile_page/my_preference.dart';

class ProfileListPage extends StatefulWidget {
  const ProfileListPage({super.key});

  @override
  State<ProfileListPage> createState() => _ProfileListPageState();
}

class _ProfileListPageState extends State<ProfileListPage>
    with TickerProviderStateMixin {
  late TabController myTabController;

  @override
  void initState() {
    super.initState();
    myTabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    myTabController.dispose();
    super.dispose();
  }

  final List<Tab> myTabs = <Tab>[
    const Tab(text: '기본 정보'),
    const Tab(text: '나의 선호'),
    const Tab(text: '환경 설정'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text('My Profile'),
              expandedHeight: 500.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Image.asset(
                  'assets/images/profile1.png',
                  fit: BoxFit.cover,
                ),
              ),
              bottom: TabBar(
                controller: myTabController,
                tabs: myTabs,
              ),
            )
          ];
        },
        body: TabBarView(
          controller: myTabController,
          children: const [
            MyInformation(),
            MyPreference(),
            Setting(),
          ],
        ),
      ),
    );
  }
}
