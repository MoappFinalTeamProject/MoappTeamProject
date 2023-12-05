import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:moapp_team_project/pages/notification/notification.dart';
import 'package:moapp_team_project/src/app_state.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';
import 'package:timer_builder/timer_builder.dart';

class TodayDatePage extends StatefulWidget {
  const TodayDatePage({super.key});

  @override
  State<TodayDatePage> createState() => _TodayDatePageState();
}

class _TodayDatePageState extends State<TodayDatePage> {


  _renderContent(context, ApplicationState appState) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.07,
          right: MediaQuery.of(context).size.width * 0.07,
          top: MediaQuery.of(context).size.height * 0.05,
          bottom: MediaQuery.of(context).size.height * 0.05,),
      color: Color(0x00000000),
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,

        side: appState.isFlipped? CardSide.BACK : CardSide.FRONT,
        speed: 1000,

        onFlip: () {
          setState(() {
            appState.setIsFlipped();
          });
        },
        onFlipDone: (status) {
          setState(() {
            print("rebuild");
          });
        },
        flipOnTouch : appState.isFlipped? false : true, 
        front: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 241, 211, 230),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               SizedBox(
                height: 50,
                child: Image.asset('assets/images/1313.png', fit: BoxFit.contain)),
              //Text('오늘의 소개가 도착했습니다', style: Theme.of(context).textTheme.headline1),
              SizedBox(height: 30,),
              Text('카드 오픈',
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        back: Container(
          decoration: BoxDecoration(
            //color: Color.fromARGB(255, 189, 24, 79),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FutureBuilder<List<String>>(
                  future: appState.getMatchedProfilePics(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return Center(child: Text("매칭 할 상대방이 없습니다"));
                    }
                    else{
                    return Stack(
                    alignment: Alignment.bottomCenter,
                      children: [
                        CarouselSlider(
                          //options: CarouselOptions(height: MediaQuery.of(context).size.height -100),
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.48,
                            viewportFraction: 1,
                            enlargeCenterPage: true,
                          ),
                          items: snapshot.data!.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: NetworkImage(i),
                                            fit: BoxFit.cover)),
                                    width: 600,
                                    height: 600,
                                    child: BackdropFilter(
                                      filter:
                                          ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                      child: Container(
                                          color: Colors.black.withOpacity(0.1)),
                                    ));
                              },
                            );
                          }).toList(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(onPressed: (){}, 
                            child: Text("더 알아보기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                            SizedBox(width: 10,),
                          ElevatedButton(onPressed: (){}, 
                          child: Text("매칭 신청"), style: ElevatedButton.styleFrom(primary: Colors.pink[50], foregroundColor: Colors.black)),
                          ],
                        ),
                      ],
                    );
                  }
                  }),
              // Text('Back', style: Theme.of(context).textTheme.headline1),
              // Text('Click here to flip front',
              //     style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final appState = Provider.of<ApplicationState>(context);
    showNotification2();
    return 
    Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("오늘의 소개"),
        actions: [
          IconButton(
            onPressed: (){
              appState.getWishPercent().then((value) => Navigator.pushNamed(context, '/filter'));
              //appState.setAtLeastPerc();
              }, 
            icon: SizedBox(
              width: 25,
              child: Image.asset('assets/icons/filter.png',)))
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          //_renderBg(),
          Column(
            children: <Widget>[
              appState.checkTime(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.60,
                width: MediaQuery.of(context).size.width,
                child: _renderContent(context, appState),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
