import 'package:flutter/material.dart';
import 'package:moapp_team_project/provider/chatGPT_model.dart';
import 'package:provider/provider.dart';

class MyGPTPage extends StatefulWidget {
  const MyGPTPage({super.key});

  @override
  State<MyGPTPage> createState() => _MyGPTPageState();
}

class _MyGPTPageState extends State<MyGPTPage> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GPTModel result = context.watch<GPTModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI\'s pick Bible verses'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
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
                      hintText: '지금은 어떤 상태인가요?',
                      border: InputBorder.none, // 테두리 없애기
                      contentPadding: EdgeInsets.all(8), // 내부 여백 설정
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              FutureBuilder(
                  future: result.watiFetchDiaryData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        height: 200,
                        width: double.infinity,
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
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  if (textController.text.trim().isNotEmpty) {
                    result.makeALine(textController.text.trim());
                    textController.clear();
                  } else {
                    const snackBar = SnackBar(
                      content: Text('내용을 입력해주세요!'),
                      duration: Duration(milliseconds: 750),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Text('submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
