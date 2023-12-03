import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moapp_team_project/src/app_state.dart';
import 'package:provider/provider.dart';

class MyInformation extends StatefulWidget {
  const MyInformation({Key? key}) : super(key: key);

  @override
  _MyInformationState createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? data;
  bool _isLoading = true;

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          appState.checkTime(),
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          data!['name'], // 이름
                          style: TextStyle(
                            color: Color(0xff3E3E3E),
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Email : ${user!.email!}', // 이메일
                          style: TextStyle(
                            color: Color(0xff3E3E3E),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'PhoneNumber : ' + data!['phone number'], // 전화번호
                          style: TextStyle(
                            color: Color(0xff3E3E3E),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Birthday : ' + data!['birthday'], // 생일
                          style: TextStyle(
                            color: Color(0xff3E3E3E),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Age : ' + data!['age'], // 나이
                          style: TextStyle(
                            color: Color(0xff3E3E3E),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Gender : ' + data!['gender'], // 성별
                          style: TextStyle(
                            color: Color(0xff3E3E3E),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
