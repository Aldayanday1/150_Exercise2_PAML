import 'package:flutter/material.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/login_user_page/login_page.dart';
import 'dart:async';

import 'package:kulinerjogja/presentation/views/home_page/home_screen.dart';

class EmailVerifiedPage extends StatefulWidget {
  @override
  _EmailVerifiedPageState createState() => _EmailVerifiedPageState();
}

class _EmailVerifiedPageState extends State<EmailVerifiedPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Email Verified')),
      body: Center(
        child: Text('Email Verified'),
      ),
    );
  }
}
