import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kulinerjogja/presentation/controllers/user_controller.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/register_page/email_verified_page.dart';
import 'dart:async';

import 'package:kulinerjogja/presentation/views/auth_pages/register_page/register_page.dart';
import 'package:lottie/lottie.dart';

class TokenInputPage extends StatefulWidget {
  final String email;
  TokenInputPage({required this.email});

  @override
  _TokenInputPageState createState() => _TokenInputPageState();
}

class _TokenInputPageState extends State<TokenInputPage> {
  // ----------------- VALIDATE FORM & VERIFY OTP -----------------
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = UserController();

  // ----------------- OTP CONTROLLER -----------------
  final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(4, (index) => FocusNode());

  // ----------------- OBSCURE EMAIL -----------------
  String obscureEmail(String email) {
    // Pisahkan email menjadi dua bagian, sebelum dan sesudah '@'
    var parts = email.split('@');

    // Jika bagian sebelum '@' memiliki panjang lebih dari 2 karakter
    if (parts[0].length > 2) {
      // Ambil 2 karakter pertama dari bagian sebelum '@'
      var firstPart = parts[0].substring(0, 2);

      // Ganti semua karakter setelah 2 karakter pertama dengan '*'
      var lastPart = parts[0].substring(2).replaceAll(RegExp(r'.'), '*');

      // Gabungkan kembali bagian yang sudah disamarkan dengan bagian setelah '@'
      return '$firstPart$lastPart@${parts[1]}';
    }

    // Jika bagian sebelum '@' tidak lebih dari 2 karakter, kembalikan email asli
    return email;
  }

  // ----------------- CHECK OTP STATUS -----------------
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
        // Jika OTP tidak aktif, kembali ke halaman Registrasi
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
      // Handle error, misalnya dengan menampilkan pesan kesalahan
      print('Gagal memeriksa status OTP: $e');
    }
  }

  // ----------------- VERIFY OTP -----------------
  String _otp = '';

  Future<void> _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      _otp = _otpControllers.map((controller) => controller.text).join();
      try {
        String message = await _userController.verifyOtp(_otp);
        _isOtpVerified = true;
        _timer.cancel();

        // Tampilkan snackbar "Registrasi berhasil"
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));

        // Navigate to Verified Email after successful Registration
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

  // ----------------- TIMER FOR DISPOSE -----------------
  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ------ SAMARAN EMAIL -------
    String obfuscatedEmail = obscureEmail(widget.email);
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Lottie.network(
              'https://lottie.host/622b70c5-e4ad-44f9-b0ae-cd2a2241ac49/NPNSeOC9Q2.json',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
          ),
          // Logo ody fullscreen
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/ody.png',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter OTP",
                      style: GoogleFonts.poppins(
                        fontSize: 32.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "We've sent an OTP to your email: $obfuscatedEmail",
                      style: GoogleFonts.poppins(
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(4, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SizedBox(
                              width: 50,
                              child: TextFormField(
                                controller: _otpControllers[index],
                                focusNode: _otpFocusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                decoration: InputDecoration(
                                  counterText: "",
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black87),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.length == 1 && index < 3) {
                                    FocusScope.of(context).requestFocus(
                                        _otpFocusNodes[index + 1]);
                                  } else if (value.isEmpty && index > 0) {
                                    FocusScope.of(context).requestFocus(
                                        _otpFocusNodes[index - 1]);
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Verify",
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
