import 'dart:io';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ChatRoomUIPage extends StatefulWidget {
  const ChatRoomUIPage({Key? key, required this.data}) : super(key: key);
  final Map<String, dynamic> data;

  @override
  State<ChatRoomUIPage> createState() => _ChatRoomUIPageState();
}

class _ChatRoomUIPageState extends State<ChatRoomUIPage>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  XFile? image;
  final ImagePicker picker = ImagePicker();
  String dropdownValue = "";
  List<String> list2 = <String>[];

  @override
  void initState() {
    dropdownValue = widget.data['group_size'];
    for (int i = widget.data['participant'].length; i <= 10; i++) {
      if (i == 1) {
        i++;
      }
      list2.add(i.toString());
    }
    super.initState();
  }

  Future getImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = XFile(pickedFile.path);
      });
    }
  }

  Widget messageBar() {
    Color messageBarColor = const Color(0xffF4F4F5);
    Color sendButtonColor = Colors.blue;
    final TextEditingController _textController = TextEditingController();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              color: messageBarColor,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        getImage();
                      },
                      icon: const Icon(Icons.photo)),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: '메세지 입력하기',
                        hintMaxLines: 1,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10),
                        hintStyle: const TextStyle(fontSize: 16),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 0.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Colors.black26,
                            width: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: InkWell(
                      child: Icon(
                        Icons.send,
                        color: sendButtonColor,
                        size: 24,
                      ),
                      onTap: () {
                        if (_textController.text.trim().isNotEmpty ||
                            image != null) {
                          _handleSubmitted(_textController.text.trim());
                        }
                        _textController.text = '';
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(
            '${widget.data['title']}  (${widget.data['participant'].length} / ${widget.data['group_size']})'),
        actions: [
          IconButton(
            onPressed: () {
              key.currentState?.openEndDrawer();
            },
            icon: const Icon(
              Icons.menu,
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${widget.data['title']}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '(${widget.data['participant'].length} / ${widget.data['group_size']})명 참여 중',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.data['participant'].length,
                itemBuilder: (context, index) {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('member')
                        .where('uid',
                            isEqualTo: widget.data['participant'][index])
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // 데이터를 가져오는 중인 경우 로딩 표시
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        // 오류가 발생한 경우 오류 메시지 표시
                        return const Center(
                            child: Text('데이터를 가져오는 중 오류가 발생했습니다.'));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        // 데이터가 없는 경우 처리
                        return const Center(child: Text('데이터가 없습니다.'));
                      }
                      var data = snapshot.data!.docs.first.data();
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: (data['uid'] == widget.data['host'])
                            ? ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                tileColor: (data['uid'] == uid)
                                    ? const Color.fromARGB(100, 66, 99, 255)
                                    : Colors.transparent,
                                leading: CircleAvatar(
                                  radius: 30,
                                  child: Image.asset(
                                    'assets/temp_profile/kitty.png',
                                    scale: 12,
                                  ),
                                ),
                                title: Text('${data['name']} (방장)'),
                                onTap: () {},
                              )
                            : ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                tileColor: (data['uid'] == uid)
                                    ? const Color.fromARGB(100, 66, 99, 255)
                                    : Colors.transparent,
                                leading: CircleAvatar(
                                  radius: 30,
                                  child: Image.asset(
                                    'assets/temp_profile/doggy.png',
                                    scale: 12,
                                  ),
                                ),
                                title: Text('${data['name']}'),
                                onTap: () {},
                              ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  (widget.data['host'] != uid)
                      ? IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Center(
                                    child: Text(
                                      '모임을 나가시겠습니까?',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          exitGroup(widget.data);
                                          Navigator.popUntil(
                                              context,
                                              (route) =>
                                                  route.settings.name == '/');
                                        },
                                        child: const Text('예'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          '아니요',
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.exit_to_app,
                            size: 30,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Center(
                                    child: Text(
                                      '채팅방 설정',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('인원수 설정:'),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: 70,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey), // 테두리 설정
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      4), // 모서리 둥글기 설정
                                              color: Colors.white, // 배경색 설정
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: DropdownButton<String>(
                                                value: dropdownValue,
                                                icon: const Icon(
                                                    Icons.arrow_drop_down),
                                                elevation: 16,
                                                underline: Container(),
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    dropdownValue = value!;
                                                  });
                                                  FirebaseFirestore.instance
                                                      .collection('feedList')
                                                      .doc(widget.data['id'])
                                                      .update({
                                                    "group_size": dropdownValue,
                                                  }).then((value) {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'chatRoomsList')
                                                        .doc(widget.data['id'])
                                                        .update({
                                                      "group_size":
                                                          dropdownValue,
                                                    });
                                                  });
                                                  widget.data['group_size'] =
                                                      dropdownValue;
                                                },
                                                items: list2.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
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
                                        height: 20,
                                      ),
                                      ToggleSwitch(
                                        customWidths: const [90.0, 50.0],
                                        cornerRadius: 20.0,
                                        activeBgColors: const [
                                          [Colors.cyan],
                                          [Colors.redAccent]
                                        ],
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.grey,
                                        inactiveFgColor: Colors.white,
                                        totalSwitches: 2,
                                        initialLabelIndex:
                                            (widget.data['isOpend']) ? 0 : 1,
                                        labels: const ['입장 허용', ''],
                                        icons: const [null, Icons.close],
                                        onToggle: (index) {
                                          FirebaseFirestore.instance
                                              .collection('feedList')
                                              .doc(widget.data['id'])
                                              .update({
                                            "isOpend": (index == 0),
                                          }).then((value) {
                                            FirebaseFirestore.instance
                                                .collection('chatRoomsList')
                                                .doc(widget.data['id'])
                                                .update({
                                              "isOpend": (index == 0),
                                            });
                                          });
                                          widget.data['isOpend'] = (index == 0);
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Center(
                                                  child: Text(
                                                    '채팅방을 삭제하시겠습니까?',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        removeGroup(widget.data,
                                                            context);
                                                      },
                                                      child: const Text('예'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('아니요'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: const Text('모임 끝내기'),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                  actions: [
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
                          icon: const Icon(Icons.settings)),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      body: Container(
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey),
                ),
              )
            : null,
        child: Column(
          children: <Widget>[
            Flexible(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chatRoomsList')
                    .doc(widget.data['id'])
                    .collection('messages')
                    .where("created_at",
                        isGreaterThanOrEqualTo: widget.data[uid])
                    .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Stack(
                      children: [
                        ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          reverse: true,
                          itemCount: snapshot.data!.size,
                          itemBuilder: (context, index) {
                            var document = snapshot.data!.docs[index];
                            var data = document.data();
                            var continuous = (index !=
                                    snapshot.data!.size - 1 &&
                                data['uid'] ==
                                    snapshot.data!.docs[index + 1]
                                        .data()['uid'] &&
                                snapshot.data!.docs[index + 1].data()['type'] ==
                                    'chat');
                            bool isMine = (data['uid'] == uid);

                            return ChatMessageDesign(
                              data: data,
                              isMine: isMine,
                              isContinuous: continuous,
                            );
                          },
                        ),
                        if (image != null)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.maxFinite,
                              height: 200,
                              color: Colors.black.withOpacity(0.7),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Image.file(
                                        File(image!.path),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          image = null;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        else
                          Container(),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('에러가 발생했습니다.'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            messageBar(),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmitted(String text) async {
    _textController.clear();
    final temp = FirebaseFirestore.instance
        .collection('chatRoomsList')
        .doc(widget.data['id'])
        .collection('messages')
        .doc();

    FieldValue time = FieldValue.serverTimestamp();
    String imageURL = "";

    if (image != null) {
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

      final imageInstance =
          FirebaseStorage.instance.ref("/product_images/${temp.id}");
      await imageInstance
          .putFile(
            File(image!.path),
            SettableMetadata(
              customMetadata: {
                "meta": temp.id,
              },
              contentType: "image/png",
            ),
          )
          .then((p0) => Navigator.pop(context));
      imageURL = await imageInstance.getDownloadURL();
    }

    var querySnapshot = await FirebaseFirestore.instance
        .collection('member')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    var documents = querySnapshot.docs;

    if (documents.isNotEmpty) {
      var userData = documents.first.data();
      var userName = userData['name'];
      await temp.set({
        "id": temp.id,
        "uid": uid,
        "created_at": time,
        "chat": text,
        "name": userName,
        "image_url": imageURL,
        "type": 'chat',
      }).then((value) {
        setState(() {
          image = null;
        });
      });
    } else {
      // 문서가 없는 경우 처리
    }
  }
}

class ChatMessageDesign extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isMine;
  final bool isContinuous;

  const ChatMessageDesign(
      {super.key,
      required this.data,
      required this.isMine,
      required this.isContinuous});

  @override
  Widget build(BuildContext context) {
    if (data['type'] == 'in') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: BubbleSpecialOne(
              text: '${data['name']} 유저가 입장하였습니다.',
              textStyle: const TextStyle(
                color: Colors.white,
              ),
              color: Colors.grey,
              tail: false,
              isSender: false,
            ),
          ),
        ],
      );
    }
    if (data['type'] == 'out') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: BubbleSpecialOne(
              text: '${data['name']} 유저가 퇴장하였습니다.',
              textStyle: const TextStyle(
                color: Colors.white,
              ),
              color: Colors.grey,
              tail: false,
              isSender: false,
            ),
          ),
        ],
      );
    } else if (isMine) {
      return Column(
        children: [
          (data['image_url'].isNotEmpty)
              ? Padding(
                  padding: EdgeInsets.only(left: (!isContinuous) ? 0 : 60),
                  child: BubbleNormalImage(
                    id: data['image_url'],
                    image: Image.network(data['image_url']),
                    color: Colors.grey.shade200,
                    tail: !isContinuous,
                    isSender: isMine,
                  ),
                )
              : Container(),
          (data['chat'].isNotEmpty)
              ? BubbleSpecialOne(
                  text: data['chat'],
                  color: const Color.fromARGB(100, 66, 99, 255),
                  tail: !isContinuous,
                  isSender: isMine,
                )
              : Container(),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          (!isContinuous)
              ? CircleAvatar(
                  radius: 23,
                  child: Image.asset(
                    'assets/temp_profile/doggy.png',
                    scale: 17,
                  ),
                )
              : Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (data['image_url'].isNotEmpty)
                  ? Padding(
                      padding: EdgeInsets.only(left: (!isContinuous) ? 0 : 46),
                      child: BubbleNormalImage(
                        id: data['image_url'],
                        image: Image.network(data['image_url']),
                        color: Colors.grey.shade200,
                        tail: !isContinuous,
                        isSender: isMine,
                      ),
                    )
                  : Container(),
              (data['chat'].isNotEmpty)
                  ? Padding(
                      padding: EdgeInsets.only(left: (!isContinuous) ? 0 : 46),
                      child: BubbleSpecialOne(
                        text: data['chat'],
                        color: Colors.grey.shade200,
                        tail: !isContinuous,
                        isSender: isMine,
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      );
    }
  }
}

Future<void> exitGroup(Map<String, dynamic> data) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final temp = FirebaseFirestore.instance
      .collection('chatRoomsList')
      .doc(data['id'])
      .collection('messages')
      .doc();
  FieldValue time = FieldValue.serverTimestamp();

  FirebaseFirestore.instance.collection('feedList').doc(data['id']).update({
    "participant": FieldValue.arrayRemove([uid]),
  }).then((value) {
    FirebaseFirestore.instance
        .collection('chatRoomsList')
        .doc(data['id'])
        .update({
      "participant": FieldValue.arrayRemove([uid]),
      uid: FieldValue.delete(),
    });
  }).then((value) async => {
        await temp.set({
          "id": temp.id,
          "uid": uid,
          "created_at": time,
          "type": 'out',
          "image_url": "",
        })
      });
  ;
}

Future<void> removeGroup(
    Map<String, dynamic> data, BuildContext context) async {
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
  await FirebaseFirestore.instance
      .collection('feedList')
      .doc(data['id'])
      .delete();

  QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
      .collection('chatRoomsList')
      .doc(data['id'])
      .collection('messages')
      .get();

  for (DocumentSnapshot doc in messagesSnapshot.docs) {
    if (await checkFileExists("/product_images/${doc["id"]}")) {
      await FirebaseStorage.instance
          .ref("/product_images/${doc["id"]}")
          .delete();
    }
    await doc.reference.delete();
  }

  await FirebaseFirestore.instance
      .collection('chatRoomsList')
      .doc(data['id'])
      .delete()
      .then((value) =>
          Navigator.popUntil(context, (route) => route.settings.name == '/'));
}

Future<bool> checkFileExists(String filePath) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference fileRef = storage.ref().child(filePath);

  try {
    final metadata = await fileRef.getMetadata();
    return true; // 파일이 존재하는 경우
  } catch (e) {
    return false;
  }
}
