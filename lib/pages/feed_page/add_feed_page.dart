import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddFeedPage extends StatefulWidget {
  const AddFeedPage({super.key});

  @override
  State<AddFeedPage> createState() => _AddFeedPageState();
}

List<String> list = <String>['한동 한바퀴', '야식 먹기', '스터디하기', '양덕 나가기'];
List<String> list2 = <String>['2', '3', '4', '5', '6', '7', '8', '9', '10'];

class _AddFeedPageState extends State<AddFeedPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String dropdownValue = list.first;
  String dropdownValue2 = list2.first;

  Future<void> _selectStartTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: (_startTime != null) ? _startTime! : TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _startTime = pickedTime;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: (_endTime != null) ? _endTime! : TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _endTime = pickedTime;
      });
    }
  }

  Future<void> makeFeed(String title, String content, String start, String end,
      String category, String size) async {
    FirebaseAuth.instance.currentUser!.uid;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        );
      },
    );

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final tempId = FirebaseFirestore.instance // 저장
        .collection('feedList')
        .doc();

    await tempId.set({
      'title': title,
      'content': content,
      'start_date': start,
      'end_date': end,
      'category': category,
      'group_size': size,
      'host': uid,
      'participant': [uid],
      'isOpend': true,
      'id': tempId.id,
    }).then((value) {
      FirebaseFirestore.instance // 저장
          .collection('chatRoomsList')
          .doc(tempId.id)
          .set({
        'title': title,
        'host': uid,
        'id': tempId.id,
        'participant': [uid],
        'group_size': size,
        'isOpend': true,
      }).then((value) => Navigator.pop(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Schedule'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), // 모서리 둥글기 설정
                  border: Border.all(color: Colors.grey), // 회색 테두리 설정
                  color: Colors.white, // 배경색 설정
                ),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: '모임 이름*',
                    border: InputBorder.none, // 테두리 없애기
                    contentPadding: EdgeInsets.all(8), // 내부 여백 설정
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey), // 테두리 설정
                        borderRadius: BorderRadius.circular(4), // 모서리 둥글기 설정
                        color: Colors.white, // 배경색 설정
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          underline: Container(),
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValue = value!;
                              // if (dropdownValue.compareTo('한동 한바퀴') == 0) {
                              // } else if (dropdownValue.compareTo('야식 먹기') == 0) {
                              // } else if (dropdownValue.compareTo('스터디하기') == 0) {
                              // } else if (dropdownValue.compareTo('양덕 나가기') == 0) {
                              // } else {}
                            });
                          },
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey), // 테두리 설정
                      borderRadius: BorderRadius.circular(4), // 모서리 둥글기 설정
                      color: Colors.white, // 배경색 설정
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: DropdownButton<String>(
                        value: dropdownValue2,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        underline: Container(),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValue2 = value!;
                            // if (dropdownValue2.compareTo('2') == 0) {
                            // } else if (dropdownValue2.compareTo('3') == 0) {
                            // } else if (dropdownValue2.compareTo('4') == 0) {
                            // } else if (dropdownValue2.compareTo('5') == 0) {
                            // } else if (dropdownValue2.compareTo('6') == 0) {
                            // } else if (dropdownValue2.compareTo('7') == 0) {
                            // } else if (dropdownValue2.compareTo('8') == 0) {
                            // } else if (dropdownValue2.compareTo('9') == 0) {
                            // } else if (dropdownValue2.compareTo('10') == 0) {
                            // } else {}
                          });
                        },
                        items:
                            list2.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _selectStartTime,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), // 모서리 둥글기 설정
                        border: Border.all(color: Colors.grey), // 회색 테두리 설정
                        color: Colors.white, // 배경색 설정
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Text(_startTime != null
                              ? _startTime!.format(context)
                              : '시작 시간*'),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '  ~  ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  GestureDetector(
                    onTap: _selectEndTime,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), // 모서리 둥글기 설정
                        border: Border.all(color: Colors.grey), // 회색 테두리 설정
                        color: Colors.white, // 배경색 설정
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Text(_endTime != null
                              ? _endTime!.format(context)
                              : '종료 시간*'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), // 모서리 둥글기 설정
                  border: Border.all(color: Colors.grey), // 회색 테두리 설정
                  color: Colors.white, // 배경색 설정
                ),
                child: SingleChildScrollView(
                  child: TextField(
                    controller: contentController,
                    maxLines: null, // 스크롤 가능하도록 null로 설정
                    decoration: const InputDecoration(
                      hintText: '설명',
                      border: InputBorder.none, // 테두리 없애기
                      contentPadding: EdgeInsets.all(8), // 내부 여백 설정
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              ElevatedButton(
                onPressed: (titleController.text.isNotEmpty &&
                        (_endTime != null && _startTime != null))
                    ? () {
                        makeFeed(
                          titleController.text.trim(),
                          contentController.text.toString().trim(),
                          _startTime!.format(context),
                          _endTime!.format(context),
                          dropdownValue,
                          dropdownValue2,
                        ).then((value) {
                          Navigator.pop(context);
                          const snackBar = SnackBar(
                            content: Text('새로운 모임을 등록했습니다!'),
                            duration: Duration(seconds: 3),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      }
                    : null,
                child: const Text('등록하기'),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
