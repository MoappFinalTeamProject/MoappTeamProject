import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      });
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Information"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
