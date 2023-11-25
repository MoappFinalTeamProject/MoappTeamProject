import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moapp_team_project/pages/onBorading_page/onBorading.dart';
import 'package:moapp_team_project/src/app_state.dart';
import 'package:moapp_team_project/auth/register.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email = "";
  late String _password = "";
  late String _nickname = "";

  void navigateToRegisterPage() {
    Navigator.pushNamed(
      context,
      '/register',
    );
  }

  @override
  Widget build(BuildContext context) {
    final appstate = Provider.of<ApplicationState>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Text(""),
        title: const Text('이메일 로그인'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: OverflowBar(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: '이메일', hintText: 'example@example.com'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '이메일을 입력해주세요.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _email = value!;
                  });
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: '비밀번호', hintText: '비밀번호를 입력하세요.'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '비밀번호를 입력해주세요.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _password = value!;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  signWithEmail(context, appstate),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: navigateToRegisterPage,
                    child: const Text('회원가입'),
                  ),
                ],
              ),
              Text(_email),
              Text(_password)
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton signWithEmail(
      BuildContext context, ApplicationState appstate) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          // 폼 유효성 검사
          try {
            UserCredential userCredential =
                await _auth.signInWithEmailAndPassword(
              email: _email,
              password: _password,
            );
            if (await FirebaseAuth.instance.currentUser!.emailVerified) {
              print("yes");
              print('로그인 성공!');
              User? user = userCredential.user;
              final memberInformation = FirebaseFirestore.instance
                  .collection("member")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("member info")
                  .doc("basic info");

              memberInformation.get().then(
                (DocumentSnapshot doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  //if (data["name"] == "new member") {
                  if (data["name"] == "") {
                    //  Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => OnBoardingPage(),
                    //   ),
                    // );
                    Navigator.pushNamed(context, '/onBoard');
                  } else {
                    appstate.setCurrentUserName(data["name"]);
                    Navigator.pop(context, '/');
                  }
                },
                onError: (e) => print("Error getting document: $e"),
              );
            } else {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Email verification'),
                        content: Text('Email 인증을 완료해주세요'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('취소'),
                          ),
                        ],
                      ));
              //알람 기능
            }
          } catch (e) {
            // 로그인 실패 처리
            print('로그인 실패: $e');
          }
        }
      },
      child: const Text('로그인'),
    );
  }
}
