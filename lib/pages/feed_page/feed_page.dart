import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addFeed');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '지금 한동에서는',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down),
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
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('feedList')
                      .where('category', isEqualTo: dropdownValue)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          var document = snapshot.data!.docs[index];
                          var data = document.data();
                          bool isMine = (data['participant'].contains(
                              FirebaseAuth.instance.currentUser!.uid));
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Center(
                                            child: Text(
                                              data['title'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 200,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8), // 모서리 둥글기 설정
                                                  border: Border.all(
                                                      color: Colors
                                                          .grey), // 회색 테두리 설정
                                                  color: Colors.white, // 배경색 설정
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                      data['content'],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                '${data['start_date']} ~ ${data['end_date']}',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: (isMine)
                                                  ? () {
                                                      Navigator.pop(context);
                                                    }
                                                  : () {
                                                      participateGroup(data);
                                                      Navigator.pop(context);
                                                      const snackBar = SnackBar(
                                                        content:
                                                            Text('모임에 지원했습니다!'),
                                                        duration: Duration(
                                                            seconds: 3),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    },
                                              child: (isMine)
                                                  ? const SizedBox.shrink()
                                                  : const Text('채팅방 참여'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('닫기'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        width: 2,
                                        color: (isMine)
                                            ? Colors.pink
                                            : const Color.fromARGB(
                                                100, 66, 99, 255),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  maxRadius: 28,
                                                  child: Icon(
                                                    Icons.abc,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  data['title'],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '${data['start_date']} ~ ${data['end_date']}',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: memberStatus(
                                                context, data, isMine),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                (data['participant'].length <
                                            int.parse(data['group_size']) &&
                                        (data['isOpend']))
                                    ? const SizedBox.shrink()
                                    : Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              15), // 모서리 둥글기 설정
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '모집 마감',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('에러가 발생했습니다.'));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}

Widget memberStatus(
    BuildContext context, Map<String, dynamic> data, bool isMine) {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  return Container(
    decoration: BoxDecoration(
      color: (data['uid'] == uid)
          ? Colors.grey
          : (isMine)
              ? Colors.pink
              : const Color.fromARGB(100, 66, 99, 255),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          (isMine) ? Icons.person : Icons.person_outline,
          size: 35,
          color: (data['uid'] == uid)
              ? Colors.black
              : (isMine)
                  ? Colors.white
                  : Colors.black,
        ),
        Text(
          '${data['participant'].length} / ${data['group_size']}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: (data['uid'] == uid)
                ? Colors.black
                : (isMine)
                    ? Colors.white
                    : Colors.black,
          ),
        ),
      ],
    ),
  );
}

Future<void> participateGroup(Map<String, dynamic> data) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final temp = FirebaseFirestore.instance
      .collection('chatRoomsList')
      .doc(data['id'])
      .collection('messages')
      .doc();
  FieldValue time = FieldValue.serverTimestamp();

  FirebaseFirestore.instance.collection('feedList').doc(data['id']).update({
    "participant": FieldValue.arrayUnion([uid]),
  }).then((value) {
    FirebaseFirestore.instance
        .collection('chatRoomsList')
        .doc(data['id'])
        .update({
      "participant": FieldValue.arrayUnion([uid]),
    });
  }).then((value) async => {
        await temp.set({
          "id": temp.id,
          "uid": uid,
          "created_at": time,
          "type": 'in',
          "image_url": "",
        })
      });
}
