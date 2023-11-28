import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyPreference extends StatefulWidget {
  const MyPreference({Key? key}) : super(key: key);

  @override
  _MyPreferenceState createState() => _MyPreferenceState();
}

class _MyPreferenceState extends State<MyPreference> {
  Map<String, bool> hobbyCategories = {
    '운동': false,
    '독서': false,
    '드라마 시청': false,
    '영화 시청': false,
    '게임': false,
    '요리': false,
    '노래 부르기': false,
    '노래방 가기': false,
  };

  Map<String, bool> foodCategories = {
    '한식': false,
    '중식': false,
    '일식': false,
    '양식': false,
    '베트남식': false,
  };

  void savePreferences() {
    FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('member info')
        .doc('preference')
        .set({
      'hobby': hobbyCategories,
      'food': foodCategories,
    });
  }

  Widget buildCategory(String title, Map<String, bool> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 10.0,
          runSpacing: 0.0,
          children: categories.keys.map((String key) {
            return OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: categories[key] ?? false
                    ? Color.fromARGB(255, 80, 133, 223)
                    : Colors.grey[300],
              ),
              onPressed: () {
                setState(() {
                  categories[key] = !(categories[key] ?? false);
                  savePreferences();
                });
              },
              child: Text(
                key,
                style: TextStyle(
                  color: categories[key] ?? false ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCategory('취미', hobbyCategories),
            buildCategory('음식', foodCategories),
          ],
        ),
      ),
    );
  }
}
