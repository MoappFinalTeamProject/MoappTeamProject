import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moapp_team_project/src/app_state.dart';
import 'package:provider/provider.dart';

class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({super.key});

  @override
  State<MyRegisterPage> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email = "";
  late String _password = "";
  @override
  Widget build(BuildContext context) {
    final appstate = Provider.of<ApplicationState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입 페이지'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: OverflowBar(
            children: <Widget>[
              // Consumer<ApplicationState>(
              //     builder: (context, appState, _) => GoogleLogin(
              //         addMessage: (message) => appState.addMemberFromGoogle(),
              //         loggedIn: appState.loggedIn,
              //         signOut: () {
              //           FirebaseAuth.instance.signOut();
              //         }),
              //   ),
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
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: _email, password: _password);
                      FirebaseAuth.instance.currentUser
                          ?.sendEmailVerification();
                      appstate.addMember();
                      Navigator.pop(context, '/');
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
