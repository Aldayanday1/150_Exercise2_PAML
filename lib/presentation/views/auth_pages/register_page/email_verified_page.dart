import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

import 'package:sistem_pengaduan/presentation/views/auth_pages/login_user_page/login_page.dart';

class EmailVerifiedPage extends StatefulWidget {
  @override
  _EmailVerifiedPageState createState() => _EmailVerifiedPageState();
}

class _EmailVerifiedPageState extends State<EmailVerifiedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Durasi animasi teks
    );
    // Menghilang - Muncul
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward(); // Memulai animasi

    Timer(Duration(seconds: 8), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animation
            Lottie.network(
              'https://lottie.host/e0f3afcc-45cf-437b-9f1f-7ce15d8492ae/7lBhejqdar.json',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // Animated Text
            FadeTransition(
              opacity: _animation,
              child: Column(
                children: [
                  Text(
                    'Email Verified!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Thank you for verifying your email.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
