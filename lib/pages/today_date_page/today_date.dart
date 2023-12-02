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
  _renderBg() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFFFFFFF)),
    );
  }

  _renderContent(context, ApplicationState appState) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(
          left: 32.0,
          right: 32.0,
          top: MediaQuery.of(context).size.height * 0.12,
          bottom: 0.0),
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
        onFlipDone: (status) {},
        //flipOnTouch : appState.isFlipped? false : true, 
        front: Container(
          decoration: BoxDecoration(
            color: Color(0xFF006666),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Front', style: Theme.of(context).textTheme.headline1),
              Text('Click here to flip back',
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
                    print("snapshot data : ${snapshot.data}");
                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      print("no data");
                      return Center(child: Text("매칭 할 상대방이 없습니다"));
                    }
                    else{
                    return CarouselSlider(
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
    showNotification2();
    final appState = Provider.of<ApplicationState>(context);
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          //_renderBg(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              appState.checkTime(),
              Expanded(
                flex: 4,
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
