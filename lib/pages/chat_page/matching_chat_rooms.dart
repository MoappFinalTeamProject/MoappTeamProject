import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moapp_team_project/pages/chat_page/chat_ui_page.dart';

class MyMatchingChatRoomList extends StatelessWidget {
  const MyMatchingChatRoomList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('matchingChatRoomList')
                  .where('participant',
                      arrayContains: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index) {
                      var document = snapshot.data!.docs[index];
                      var data = document.data();
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatRoomUIPage(
                                data: data,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: (index == 0)
                                  ? Colors.white
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 2,
                                color: (index == 0)
                                    ? const Color.fromARGB(100, 66, 99, 255)
                                    : Colors.black,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: (index == 0)
                                        ? const Color.fromARGB(100, 66, 99, 255)
                                        : Colors.white,
                                    maxRadius: 28,
                                    child: (index == 0)
                                        ? const Badge(
                                            label: Text('2'),
                                            child:
                                                Icon(Icons.messenger_outline),
                                          )
                                        : const Icon(
                                            Icons.chat,
                                          ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        (index == 0)
                                            ? const Text(
                                                '매칭 채팅방',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : const Text(
                                                '과거 채팅방',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text('에러가 발생했습니다.'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
