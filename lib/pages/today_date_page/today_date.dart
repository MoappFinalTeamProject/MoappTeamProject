import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodayDatePage extends StatefulWidget {
  const TodayDatePage({Key? key}) : super(key: key);

  @override
  _TodayDatePageState createState() => _TodayDatePageState();
}

class _TodayDatePageState extends State<TodayDatePage> {
  Map<String, bool>? userPreferences;
  List<DocumentSnapshot> recommendedUsers = [];

  @override
  void initState() {
    super.initState();
    fetchPreferences();
  }

  Future<void> fetchPreferences() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('member info')
        .doc('preference')
        .get();

    setState(
      () {
        userPreferences =
            Map<String, bool>.from(snapshot.data() as Map<String, dynamic>);
      },
    );

    findRecommendedUsers();
  }

  Future<void> findRecommendedUsers() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('member').get();

    snapshot.docs.forEach((doc) {
      if (doc.id == FirebaseAuth.instance.currentUser!.uid) {
        return;
      }

      Map<String, bool> otherUserPreferences =
          Map<String, bool>.from(doc['preference'] as Map<String, dynamic>);

      int matchCount = 0;

      userPreferences!.forEach((key, value) {
        if (value && otherUserPreferences[key] == true) {
          matchCount++;
        }
      });

      if (matchCount >= 3) {
        recommendedUsers.add(doc);
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: recommendedUsers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recommendedUsers[index]['username']),
            subtitle: Text('선호 목록이 3개 이상 동일한 인물입니다!'),
          );
        },
      ),
    );
  }
}
