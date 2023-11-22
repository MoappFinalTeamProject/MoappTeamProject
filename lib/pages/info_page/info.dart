import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moapp_team_project/src/app_state.dart';
import 'package:provider/provider.dart';

class MyBasicInfoPage extends StatefulWidget {
  const MyBasicInfoPage({Key? key}) : super(key: key);

  @override
  State<MyBasicInfoPage> createState() => _MyBasicInfoPageState();
}

class _MyBasicInfoPageState extends State<MyBasicInfoPage> {

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
     late String _email = "";
  late String _password = "";
  @override
  Widget build(BuildContext context) {
     final appstate = Provider.of<ApplicationState>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Text(""),
        title: Text("WELCOME!"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            children: <Widget>[
              ListTile(
                title:
                TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: '닉네임', hintText: '닉네임을 입력하세요'),
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
              ) ,

              trailing: ElevatedButton(onPressed: (){}, child: Text("중복확인"),),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: '닉네임', hintText: '닉네임을 입력하세요'),
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
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _email, password: _password);
                        FirebaseAuth.instance.currentUser
                            ?.sendEmailVerification();
                        appstate.addMember();
                        Navigator.pop(context, '/');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('weak-password'),
                                  content: Text('비밀번호는 6자리 이상 입력해주세요'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('취소'),
                                    ),
                                  ],
                                ));
                        } else if (e.code == 'email-already-in-use') {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('email-already-in-use'),
                                  content: Text('이메일 계정이 이미 존재합니다. 다른 이메일을 입력해주세요'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('취소'),
                                    ),
                                  ],
                                ));
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }

                      // Navigator.pushNamed(context, '/login');
                    },
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
}