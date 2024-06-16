import 'package:flutter/material.dart';
import 'package:kulinerjogja/presentation/controllers/user_controller.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/register_page/email_verified.dart';
import 'dart:async';

import 'package:kulinerjogja/presentation/views/auth_pages/register_page/register_page.dart';

class TokenInputPage extends StatefulWidget {
  final String email;
  TokenInputPage({required this.email});

  @override
  _TokenInputPageState createState() => _TokenInputPageState();
}

class _TokenInputPageState extends State<TokenInputPage> {
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = UserController();
  String _otp = '';
  late Timer _timer;

  bool _isOtpVerified = false; // Tambahkan flag ini

  @override
  void initState() {
    super.initState();
    _startOtpStatusCheck();
  }

// cek perubahan pada status otp setiap 1 detik
  void _startOtpStatusCheck() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      await _checkOtpStatus();
    });
  }

// cek status dari otp, apakah masih valid?
  Future<void> _checkOtpStatus() async {
    if (_isOtpVerified) return; // Jangan cek status OTP jika sudah diverifikasi
    try {
      bool isOtpActive = await _userController.checkOtpStatus(widget.email);
      if (!isOtpActive) {
        // Jika OTP tidak aktif, kembali ke halaman registrasi
        _timer.cancel();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => RegisterPage(),
              settings:
                  RouteSettings(arguments: "Maaf, kode OTP sudah kadaluwarsa")),
          (route) => false, // Hapus semua route sebelumnya
        );
      }
    } catch (e) {
      print('Gagal memeriksa status OTP: $e');
      // Handle error, misalnya dengan menampilkan pesan kesalahan
    }
  }

//  validasi otp
  void _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        String message = await _userController.verifyOtp(_otp);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        _isOtpVerified = true; // Set flag ke true
        _timer.cancel(); // Hentikan timer
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EmailVerifiedPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
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
