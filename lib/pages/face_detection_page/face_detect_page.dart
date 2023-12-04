import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moapp_team_project/provider/mlkit_model.dart';
import 'package:provider/provider.dart';

class MyFaceDetection extends StatefulWidget {
  const MyFaceDetection({super.key});

  @override
  State<MyFaceDetection> createState() => _MyFaceDetectionState();
}

class _MyFaceDetectionState extends State<MyFaceDetection> {
  ui.Image? image;
  XFile? image2;
  final ImagePicker picker = ImagePicker();

  Future getImage(MLkitModel result) async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      var bytesFromImageFile = await pickedFile.readAsBytes();

      decodeImageFromList(bytesFromImageFile).then((img) {
        setState(() {
          image = img;
          image2 = XFile(pickedFile.path);
        });
        result.clearRectList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MLkitModel result = context.watch<MLkitModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI로 좋은 프로필 사진 골라보기',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
          child: Column(
            children: [
              LayoutBuilder(builder: (context, constraints) {
                if (image != null) {
                  var imageSize = MediaQuery.of(context).size.width * 0.8;
                  var imageAspectRatio = image!.width / image!.height;
                  var containerAspectRatio =
                      constraints.maxWidth / constraints.maxHeight;
                  var scale = containerAspectRatio > imageAspectRatio
                      ? constraints.maxHeight / image!.height
                      : constraints.maxWidth / image!.width;

                  return GestureDetector(
                    onTap: () {
                      getImage(result);
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: imageSize,
                          height: imageSize,
                          color: (image != null)
                              ? Colors.transparent
                              : Colors.grey[200],
                          child: CustomPaint(
                            painter: Painter(result.rectList, image!),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      getImage(result);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8,
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.photo_size_select_actual_rounded,
                          size: MediaQuery.of(context).size.width * 0.1,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  );
                }
              }),
              const SizedBox(
                height: 30,
              ),
              FutureBuilder(
                  future: result.watiFetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        height: 150,
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
                                : Text((result.label.isEmpty)
                                    ? '프로필 사진을 분석해보세요!'
                                    : result.label),
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
                  if (image != null) {
                    result.getRecognizedFace(image2!);
                  } else {
                    const snackBar = SnackBar(
                      content: Text('사진을 지정해주세요!'),
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

class Painter extends CustomPainter {
  final List<Rect> rects;
  ui.Image image;

  Painter(this.rects, this.image);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    var imageWidth = image.width.toDouble();
    var imageHeight = image.height.toDouble();
    var canvasWidth = size.width;
    var canvasHeight = size.height;

    var scaleX = canvasWidth / imageWidth;
    var scaleY = canvasHeight / imageHeight;
    var scale = scaleX < scaleY ? scaleX : scaleY;

    canvas.scale(scale);

    var offsetX = (canvasWidth - imageWidth * scale) / 2 * 8.5;
    var offsetY = (canvasHeight - imageHeight * scale) / 2;
    var center = Offset(offsetX, offsetY);

    canvas.drawImage(image, center, paint);
    for (var i = 0; i < rects.length; i++) {
      var adjustedRect = Rect.fromLTRB(
        rects[i].left + offsetX,
        rects[i].top + offsetY,
        rects[i].right + offsetX,
        rects[i].bottom + offsetY,
      );
      canvas.drawRect(adjustedRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
