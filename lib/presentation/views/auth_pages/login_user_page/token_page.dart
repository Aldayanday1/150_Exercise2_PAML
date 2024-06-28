import 'package:flutter/material.dart';
import 'package:kulinerjogja/domain/model/user_profile.dart';
import 'package:kulinerjogja/presentation/controllers/user_controller.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/login_user_page/login_page.dart';
import 'dart:async';

import 'package:kulinerjogja/presentation/views/home_page/home_screen.dart';

class TokenInputPageLogin extends StatefulWidget {
  final String email;
  TokenInputPageLogin({required this.email});

  @override
  _TokenInputPageLoginState createState() => _TokenInputPageLoginState();
}

class _TokenInputPageLoginState extends State<TokenInputPageLogin> {
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = UserController();
  String _otp = '';
  late Timer _timer;
  bool _isOtpVerified = false;

  @override
  void initState() {
    super.initState();
    _startOtpStatusCheck();
  }

  void _startOtpStatusCheck() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      await _checkOtpStatus();
    });
  }

  Future<void> _checkOtpStatus() async {
    if (_isOtpVerified) return;
    try {
      bool isOtpActive = await _userController.checkOtpStatus(widget.email);
      if (!isOtpActive) {
        _timer.cancel();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(),
              settings:
                  RouteSettings(arguments: "Maaf, kode OTP sudah kadaluwarsa")),
          (route) => false,
        );
      }
    } catch (e) {
      print('Gagal memeriksa status OTP: $e');
    }
  }

  Future<void> _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _userController.loginWithOtp(_otp);
        _isOtpVerified = true;
        _timer.cancel();

        // Tampilkan snackbar "Login berhasil"
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login berhasil')));

        // Navigate to home page after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeView()),
        );
      } catch (e) {
        String errorMessage = e.toString();
        // Remove "Exception: " from the error message if present
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring(11);
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input Token')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'OTP'),
                onSaved: (value) => _otp = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'OTP tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOtp,
                child: Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
