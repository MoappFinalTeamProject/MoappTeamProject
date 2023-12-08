import 'package:flutter/material.dart';
import 'package:moapp_team_project/pages/profile_page/edit_information.dart';
import 'package:moapp_team_project/pages/profile_page/setting.dart';
import 'package:moapp_team_project/pages/profile_page/my_information.dart';
import 'package:moapp_team_project/pages/profile_page/my_preference.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:moapp_team_project/src/app_state.dart';
import 'package:provider/provider.dart';

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
    final appState = Provider.of<ApplicationState>(context, listen: false);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child:
                    Image.asset('assets/images/1313.png', fit: BoxFit.contain),
              ),
              title: Stack(
                children: <Widget>[
                  Text(
                    'My Profile',
                    style: TextStyle(
                      // fontSize: 40,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.black54,
                    ),
                  ),
                  const Text(
                    'My Profile',
                    style: TextStyle(
                      // fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              expandedHeight: 500.0,
              floating: false,
              pinned: true,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditInformationPage()),
                    );
                  },
                ),
              ],
              flexibleSpace: FutureBuilder<List<String>>(
                  future: appState.getProfilePics(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 30 ),
                      child: FlexibleSpaceBar(
                        centerTitle: true,
                        background: CarouselSlider(
                          options: CarouselOptions(height:MediaQuery.of(context).size.height*0.40,),
                          items: snapshot.data!.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  height: 600,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(color: Colors.amber),
                                  child: Image.network(i, fit: BoxFit.fitWidth),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }),
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
