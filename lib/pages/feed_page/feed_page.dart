import 'package:flutter/material.dart';

class MyFeedPage extends StatefulWidget {
  const MyFeedPage({super.key});

  @override
  State<MyFeedPage> createState() => _MyFeedPageState();
}

List<String> list = <String>['한동 한바퀴', '야식 먹기', '스터디하기', '양덕 나가기'];

class _MyFeedPageState extends State<MyFeedPage> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Text('지금 한동에서는'),
            DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.home),
              elevation: 16,
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                  if (dropdownValue.compareTo('한동 한바퀴') == 0) {
                  } else if (dropdownValue.compareTo('야식 먹기') == 0) {
                  } else if (dropdownValue.compareTo('스터디하기') == 0) {
                  } else if (dropdownValue.compareTo('양덕 나가기') == 0) {
                  } else {}
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
