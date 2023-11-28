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
    '잠': false,
  };

  Map<String, bool> foodCategories = {
    '한식': false,
    '중식': false,
    '일식': false,
    '양식': false,
    '면류': false,
    '밥류': false,
    '빵류': false,
    '국물류': false,
    '볶음류': false,
    '튀김류': false,
  };

  Map<String, bool> majorCategories = {
    '경영경제': false,
    '커뮤니케이션': false,
    '콘텐츠디자인': false,
    '생명': false,
    '기계': false,
    '전산전자': false,
    'ICT창업': false,
    '법': false,
    '상담심리사회복지': false,
    '국제어문': false,
    '공간환경시스템': false,
  };

  Map<String, bool> regionCategories = {
    '서울': false,
    '경기': false,
    '인천': false,
    '대전': false,
    '강원': false,
    '충북': false,
    '충남': false,
    '전북': false,
    '전남': false,
    '경북': false,
    '경남': false,
    '대구': false,
    '울산': false,
    '부산': false,
    '광주': false,
    '제주': false,
  };

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  void loadPreferences() async {
    final doc = await FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('member info')
        .doc('preference')
        .get();

    if (doc.exists) {
      setState(() {
        hobbyCategories = {
          ...hobbyCategories,
          ...Map<String, bool>.from(doc['hobby'])
        };
        foodCategories = {
          ...foodCategories,
          ...Map<String, bool>.from(doc['food'])
        };
        majorCategories = {
          ...majorCategories,
          ...Map<String, bool>.from(doc['major'])
        };
        regionCategories = {
          ...regionCategories,
          ...Map<String, bool>.from(doc['region'])
        };
      });
    }
  }

  void savePreferences() {
    FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('member info')
        .doc('preference')
        .set({
      'hobby': hobbyCategories,
      'food': foodCategories,
      'major': majorCategories,
      'region': regionCategories,
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
            buildCategory('전공', majorCategories),
            buildCategory('지역', regionCategories),
          ],
        ),
      ),
    );
  }
}
