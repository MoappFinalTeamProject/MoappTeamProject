import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GPTModel with ChangeNotifier {
  String result = "";
  bool isOnProgress = false;

  void switchAIState(value) {
    isOnProgress = value;
    notifyListeners();
  }

  void makeALine(String prompt) async {
    OpenAI.apiKey = dotenv.env['open_ai_key']!;

    try {
      switchAIState(true);
      OpenAIChatCompletionModel lineGPT = await OpenAI.instance.chat.create(
        //  사용하는 모델
        model: 'gpt-3.5-turbo',
        //  출력의 최대 토큰 수 (기본값; 50)
        maxTokens: 200,
        //  창의성, 수치와 비례함 (기본값: 0.5)
        temperature: 1,
        //  답변의 확률 분포 상위 p%, 단어의 다양성 (기본값: 1)
        topP: 1,
        //  중복되는 구문 생성 방지 (기본값: 0)
        frequencyPenalty: 0,
        //  답변의 특정 키워드 제거 (기본값: 0)
        presencePenalty: 0,
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "다음 글의 내용을 보고 위로되는 성경 구절 하나 보여줘. <$prompt>",
              ),
            ],
            role: OpenAIChatMessageRole.user,
          ),
        ],
      );

      result = lineGPT.choices.first.message.content!.first.text.toString();
    } on RequestFailedException catch (e) {
      debugPrint(e.message);
      result = "";
    }
    switchAIState(false);
    notifyListeners();
  }

  Future<bool> watiFetchData() async {
    if (!isOnProgress) {
      return true;
    }

    //  delay for loading page
    return Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (result.isNotEmpty) {
          return true;
        }
        return false;
      },
    );
  }
}
