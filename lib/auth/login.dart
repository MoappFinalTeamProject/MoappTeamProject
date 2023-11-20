import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moapp_team_project/src/app_state.dart';
import 'package:moapp_team_project/auth/register.dart';
import 'package:provider/provider.dart';

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

  void signInWithEmail() async {
    if (_formKey.currentState!.validate()) {
      // 폼 유효성 검사
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        if(await FirebaseAuth.instance.currentUser!.emailVerified){
        print("yes");
        print('로그인 성공!');
        User? user = userCredential.user;
        Navigator.pop(context, '/');
      }
      else{
        print("no");
        //알람 기능 
      }
      } catch (e) {
        // 로그인 실패 처리
        print('로그인 실패: $e');
      }
    }
  }

  void navigateToRegisterPage() {
    Navigator.pushNamed(context, '/register',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(""),
        title: const Text('이메일 로그인'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child:  OverflowBar(
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
                  ElevatedButton(
                    onPressed: signInWithEmail,
                    child: const Text('로그인'),
                  ),
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
}
