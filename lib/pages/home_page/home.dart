import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:moapp_team_project/src/app_state.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> images = [
    ];
  
  int activeIndex = 1;
  Widget imageSlider(path, index) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        width: double.infinity,
        height: 240,
        //color: Colors.grey,
        child: Image.network(path, fit: BoxFit.contain),
      );

  Widget indicator() => Container(
      margin: const EdgeInsets.only(top: 20.0, bottom: 20),
      alignment: Alignment.bottomCenter,
      child: AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: images.length,
        effect: ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: Colors.black,
            dotColor: Colors.grey.withOpacity(0.6)),
      ));

      
  @override
  Widget build(BuildContext context) {
     final appState = Provider.of<ApplicationState>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(appState.currentUserName + " 님 환영합니다!\n",
                style: const TextStyle(fontSize: 20)),
          ),
          
          Column(
            children: [
              Stack(alignment: Alignment.bottomLeft, children: <Widget>[
                CarouselSlider.builder(
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 1000),
                    initialPage: 0,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) => setState(() {
                      activeIndex = index;
                    }),
                  ),
                  itemCount: appState.imageUrl.length,
                  itemBuilder: (context, index, realIndex) {
                    appState.setCurrentImageSliderIndex(index);
                    //print("index : ${index}");
                    final path = appState.imageUrl[index];
                    return imageSlider(path, index);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      onPressed: () {
                          launchUrl(appState.siteUrl[appState.currentImageSliderIndex]);
                      },
                      // child: Text(
                      //     "${appState.currentImageSliderIndex}번 컨텐츠 더 알아보기")
                      child: appState.currentImageSliderIndex == 0?
                      Text("식단 정보 확인하기")
                      :appState.currentImageSliderIndex == 1?
                        Text("히즈넷 들어가기")
                          :appState.currentImageSliderIndex == 2?
                          Text("한동대 유튜브 들어가기")
                            :appState.currentImageSliderIndex == 3?
                            Text("한동대 소식 확인하기")
                            :Text("error")
                      ,
                          ),
                ),
              ]),
              Align(alignment: Alignment.bottomCenter, child: indicator()),
              //카드 뒤집기 해서 오늘의 말씀 보여주기
              contentBox(
                context,
                1,
                Colors.lightBlue[50]!,
                () {
                  Navigator.pushNamed(context, '/gptPage');
                },
                '오늘의 성경 구절 자동 추천 받기',
                'chatGPT 사용해보기',
              ),
              contentBox(
                context,
                2,
                Colors.pink[50]!,
                () {
                  Navigator.pushNamed(context, '/faceDetect');
                },
                '나의 사진 분석하기',
                'MLkit 사용해보기',
              ),
              contentBox(
                context,
                3,
                Colors.lightGreen[50]!,
                () {
                  Navigator.pushNamed(context, '/googleMap');
                },
                '나의 위치 찾기',
                'GoogleMap 사용해보기',
              ),
              const SizedBox(
                height: 20,
              ),
              contentBox(
                context,
                4,
                Colors.lightBlue[50]!,
                () {
                  Navigator.pushNamed(context, '/cardFlip');
                },
                '카드 플립 테스트',
                '카드플립 사용해보기',
              ),
            ],
          ),
        ],
      ),
    );
  }
  Future<void> _launchUrl(Uri site_url) async {
  if (!await launchUrl(site_url)) {
    throw Exception('Could not launch $site_url');
  }
}

  Padding contentBox(BuildContext context, int num, Color color, Function func,
      String boxContent, String buttonContent) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, right: 20, left: 20),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.13,
        width: MediaQuery.of(context).size.width * 0.93,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                boxContent,
                style: const TextStyle(fontSize: 17),
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    func();
                  },
                  child: Text(
                    buttonContent,
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
