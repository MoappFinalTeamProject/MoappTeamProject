import 'package:flutter/material.dart';
import 'package:moapp_team_project/provider/chatGPT_model.dart';
import 'package:provider/provider.dart';

class MyTestPage extends StatefulWidget {
  const MyTestPage({super.key});

  @override
  State<MyTestPage> createState() => _MyTestPageState();
}

class _MyTestPageState extends State<MyTestPage> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GPTModel result = context.watch<GPTModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: textController,
            decoration: const InputDecoration(
                labelText: 'api test', hintText: 'gpt input'),
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
                            : Text(result.result),
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
              }
            },
            child: const Text('submit'),
          ),
        ],
      ),
    );
  }
}
