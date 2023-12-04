import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditInformationPage extends StatefulWidget {
  const EditInformationPage({Key? key}) : super(key: key);

  @override
  _EditInformationPageState createState() => _EditInformationPageState();
}

class _EditInformationPageState extends State<EditInformationPage> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? data;
  bool _isLoading = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  File? _image1, _image2, _image3;
  final picker = ImagePicker();

  String? imageUrl1, imageUrl2, imageUrl3; // 추가된 부분

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    final fetchedData = await FirebaseFirestore.instance
        .collection('member')
        .doc(user!.uid)
        .collection('member info')
        .doc('basic info')
        .get();

    if (mounted) {
      setState(() {
        data = fetchedData.data();
        _isLoading = false;

        nameController.text = data!['name'];
        phoneNumberController.text = data!['phone number'];
        birthdayController.text = data!['birthday'];
        ageController.text = data!['age'];
        genderController.text = data!['gender'];

        imageUrl1 = data!['imageUrl1']; // 추가된 부분
        imageUrl2 = data!['imageUrl2']; // 추가된 부분
        imageUrl3 = data!['imageUrl3']; // 추가된 부분
      });
    }
  }

  Future getImage(int imgNumber) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        switch (imgNumber) {
          case 1:
            _image1 = File(pickedFile.path);
            break;
          case 2:
            _image2 = File(pickedFile.path);
            break;
          case 3:
            _image3 = File(pickedFile.path);
            break;
          default:
            break;
        }
      } else {
        print('No image selected.');
      }
    });

    await uploadFile(imgNumber); // 이미지를 선택하면 바로 업로드합니다.
  }

  Future uploadFile(int imgNumber) async {
    File? image;
    switch (imgNumber) {
      case 1:
        image = _image1;
        break;
      case 2:
        image = _image2;
        break;
      case 3:
        image = _image3;
        break;
      default:
        break;
    }

    if (image != null) {
      try {
        await FirebaseStorage.instance
            .ref(
                'profile/${FirebaseAuth.instance.currentUser!.uid}/image$imgNumber.png')
            .putFile(image);

        String downloadURL = await FirebaseStorage.instance
            .ref(
                'profile/${FirebaseAuth.instance.currentUser!.uid}/image$imgNumber.png')
            .getDownloadURL();

        switch (imgNumber) {
          case 1:
            imageUrl1 = downloadURL;
            break;
          case 2:
            imageUrl2 = downloadURL;
            break;
          case 3:
            imageUrl3 = downloadURL;
            break;
          default:
            break;
        }

        setState(() {}); // 새로운 이미지 URL로 UI를 업데이트합니다.
      } on FirebaseException catch (e) {
        print(e);
      }
    }
  }

  Future<void> updateInformation() async {
    await FirebaseFirestore.instance
        .collection('member')
        .doc(user!.uid)
        .collection('member info')
        .doc('basic info')
        .update({
      'name': nameController.text,
      'phone number': phoneNumberController.text,
      'birthday': birthdayController.text,
      'age': ageController.text,
      'gender': genderController.text,
      'imageUrl1': imageUrl1, // 추가된 부분
      'imageUrl2': imageUrl2, // 추가된 부분
      'imageUrl3': imageUrl3, // 추가된 부분
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Information"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: "Name"),
                        ),
                        TextFormField(
                          controller: phoneNumberController,
                          decoration:
                              InputDecoration(labelText: "Phone Number"),
                        ),
                        TextFormField(
                          controller: birthdayController,
                          decoration: InputDecoration(labelText: "Birthday"),
                        ),
                        TextFormField(
                          controller: ageController,
                          decoration: InputDecoration(labelText: "Age"),
                        ),
                        TextFormField(
                          controller: genderController,
                          decoration: InputDecoration(labelText: "Gender"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          child: imageUrl1 != null
                              ? Image.network(imageUrl1!)
                              : Text('사진 추가하기'),
                          onTap: () async {
                            await getImage(1);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          child: imageUrl2 != null
                              ? Image.network(imageUrl2!)
                              : Text('사진 추가하기'),
                          onTap: () async {
                            await getImage(2);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          child: imageUrl3 != null
                              ? Image.network(imageUrl3!)
                              : Text('사진 추가하기'),
                          onTap: () async {
                            await getImage(3);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: updateInformation,
                          child: Text("프로필 정보 수정"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
