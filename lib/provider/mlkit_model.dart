import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moapp_team_project/provider/face_model.dart';

class MLkitModel with ChangeNotifier {
  bool isOnProgress = false;
  List<Face> faceList = [];
  List<Rect> rectList = [];
  String label = "";

  void switchAIState(value) {
    isOnProgress = value;
    notifyListeners();
  }

  void clearRectList() {
    rectList.clear();
    label = "";
    notifyListeners();
  }

  Future getRecognizedFace(XFile image) async {
    switchAIState(true);
    clearRectList();

    final InputImage inputImage = InputImage.fromFilePath(image.path);

    final faceRecognizer = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: true,
      ),
    );

    faceList = await faceRecognizer.processImage(inputImage);

    await faceRecognizer.close();

    extractFaceInfo(faceList);

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
      int count = response.length;
      label = "총 $count명의 얼굴 감지\n\n-감정 상태-\n";

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
    }
    notifyListeners();
  }

  String detectSmile(smileProb) {
    if (smileProb > 0.86) {
      return 'Big smile with teeth';
    } else if (smileProb > 0.8) {
      return 'Big Smile';
    } else if (smileProb > 0.3) {
      return 'Smile';
    } else {
      return 'Sad';
    }
  }
}
