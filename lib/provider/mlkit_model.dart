import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moapp_team_project/provider/face_model.dart';
import 'package:tuple/tuple.dart';

class MLkitModel with ChangeNotifier {
  bool isOnProgress = false;
  List<Face> faceList = [];
  List<Rect> rectList = [];
  String label = "";
  bool isFaceDetected = false;
  int number = 0;

  void switchAIState(value) {
    isOnProgress = value;
    notifyListeners();
  }

  void clearRectList() {
    rectList.clear();
    label = "";
    notifyListeners();
  }

  Future<Tuple2<bool, int>> getRecognizedFace(XFile image) async {
    switchAIState(true);
    clearRectList();

    final InputImage inputImage = InputImage.fromFilePath(image.path);

    final faceRecognizer = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: true,
      ),
    );

    faceList = await faceRecognizer.processImage(inputImage);

    await faceRecognizer.close();

    extractFaceInfo(faceList);

    switchAIState(false);
    notifyListeners();
    return Tuple2<bool, int>(isFaceDetected, number);
  }

  Future<bool> watiFetchData() async {
    if (!isOnProgress) {
      return true;
    }

    //  delay for loading page
    return Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (label.isNotEmpty) {
          return true;
        }
        return false;
      },
    );
  }

  void extractFaceInfo(List<Face>? faces) {
    List<FaceModel>? response = [];
    double? smile;
    double? leftEyeOpen;
    double? rightEyeOpen;

    for (Face face in faces!) {
      final rect = face.boundingBox;
      rectList.add(rect);
      if (face.smilingProbability != null) {
        smile = face.smilingProbability;
      }

      leftEyeOpen = face.leftEyeOpenProbability;
      rightEyeOpen = face.rightEyeOpenProbability;

      final faceModel = FaceModel(
        smile: smile,
        leftYearsOpen: leftEyeOpen,
        rightYearsOpen: rightEyeOpen,
        rect: rect,
      );

      response.add(faceModel);
    }

    if (response.isNotEmpty) {
      number = response.length;
      label = "총 $number명의 얼굴이 감지되었어요!";
      isFaceDetected = true;

      if (number == 1 && (response[0].smile)! > 0.8) {
        label += '\n\n';
        label += "프로필 사진으로 사용하기 적합해요!";
      } else if (number != 1) {
        label += '\n\n';
        label += "한 명의 얼굴이 있는 사진을 골라주세요!";
      } else {
        label += '\n\n';
        label += "좀 더 밝게 웃는 사진을 골라보는건 어떨까요?";
      }

      label += "\n\n-분석된 감정 상태-\n";

      for (int i = 0; i < response.length; i++) {
        var temp = response[i];
        if (i == 0) {
          label += "${detectSmile(temp.smile)}, ";
        } else {
          label += " ${detectSmile(temp.smile)}, ";
        }
      }

      if (label.isNotEmpty) {
        label = label.substring(0, label.length - 2);
      }
    } else {
      label = '얼굴이 감지되지 않습니다.';
      isFaceDetected = false;
    }
    notifyListeners();
  }

  String detectSmile(smileProb) {
    if (smileProb > 0.85) {
      return '매우 큰 행복';
    } else if (smileProb > 0.6) {
      return '행복';
    } else if (smileProb > 0.3) {
      return '보통';
    } else {
      return '슬픔';
    }
  }
}
