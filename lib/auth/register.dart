import 'package:flutter/material.dart';

class MyRegisterPage extends StatelessWidget {
  const MyRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입 페이지'),
      ),
      body: const Center(child: Text('Register Page')),
    );
  }
}
