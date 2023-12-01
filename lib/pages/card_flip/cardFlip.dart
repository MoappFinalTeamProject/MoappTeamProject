import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:moapp_team_project/provider/chatGPT_model.dart';
import 'package:provider/provider.dart';

class MyCardFlipPage extends StatefulWidget {
  const MyCardFlipPage({super.key});

  @override
  State<MyCardFlipPage> createState() => _MyCardFlipPageState();
}

class _MyCardFlipPageState extends State<MyCardFlipPage> {
  TextEditingController textController = TextEditingController();
  bool shouldFlip = false;
  _renderBg() {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
    );
  }

  _renderContent(context, GPTModel result) {
    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.only(
          left: 32.0, right: 32.0, top: 20.0, bottom: 0.0),
      color: const Color(0x00000000),
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        side: CardSide.FRONT,
        speed: 1000,
        flipOnTouch: shouldFlip,
        onFlip: () {
          if (textController.text.trim().isNotEmpty) {
            result.makeALine(textController.text.trim());
            textController.clear();
          }
        },
        onFlipDone: (status) {
          //print(status);
        },
        front: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF006666),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), // 모서리 둥글기 설정
                  border: Border.all(color: Colors.grey), // 회색 테두리 설정
                  color: Colors.white, // 배경색 설정
                ),
                child: SingleChildScrollView(
                  child: TextField(
                    controller: textController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: '고민이 있나요?',
                      border: InputBorder.none, // 테두리 없애기
                      contentPadding: EdgeInsets.all(8), // 내부 여백 설정
                    ),
                    onChanged: (value) {
                      if (textController.text.trim().isNotEmpty) {
                        shouldFlip = true;
                      } else {
                        shouldFlip = false;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                '카드를 눌러 결과를 확인하세요!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        back: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 189, 24, 79),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                  future: result.watiFetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8), // 모서리 둥글기 설정
                          border: Border.all(color: Colors.grey), // 회색 테두리 설정
                          color: Colors.white, // 배경색 설정
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: (result.isOnProgress)
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Text((result.result.isEmpty)
                                    ? '성경 구절을 추천받아보세요!'
                                    : result.result),
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
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
    GPTModel result = context.watch<GPTModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('연애 조언 받기'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _renderBg(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: _renderContent(context, result),
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
