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
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 2,
                          color: const Color.fromARGB(100, 66, 99, 255),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    maxRadius: 28,
                                    child: Icon(
                                      Icons.abc,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '22/남/기독교',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      '제목: ~~~~~~~asdsadasdas',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text('시간: ~~~'),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: joinButton(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget joinButton(BuildContext context) {
  return InkWell(
    onTap: () {
      print('Join!!');
    },
    child: Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(100, 66, 99, 255),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 35,
          ),
          Text(
            'n / 10',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
