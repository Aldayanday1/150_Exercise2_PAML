import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_app/models/user.dart';
import 'package:kulinerjogja/domain/model/user.dart';

class ApiService {
  static const String baseUrl = "http://192.168.56.1:8080/api/users";
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // ----------------------- REGISTRASI --------------------------

  Future<String> registerUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return 'Registrasi berhasil. Silakan cek email Anda untuk kode OTP.';
    } else {
      throw (' ${response.body}');
    }
  }

  Future<String> verifyOtp(String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      body: {'otp': otp},
    );

    if (response.statusCode == 200) {
      return 'Verifikasi OTP berhasil. Silakan login.';
    } else {
      throw (' ${response.body}');
    }
  }

  // ----------------------- LOGIN USER --------------------------

  Future<String> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return 'OTP telah dikirimkan ke email Anda. Silakan cek email Anda untuk kode OTP.';
    } else {
      throw (' ${response.body}');
    }
  }

  Future<String> loginWithOtp(String otp) async {
    final url = Uri.parse('$baseUrl/login-with-otp');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'otp': otp}),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        String token = responseData['token'];

        // Simpan token JWT ke secure storage
        await secureStorage.write(key: 'jwt_token', value: token);

        // Cetak token ke konsol (console)
        print('Token JWT: $token');

        return "Login berhasil";
      } else {
        var responseBody = jsonDecode(response.body);
        throw (responseBody['message']);
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  // ----------------------- LOGIN ADMIN --------------------------

  Future<String> loginAdmin(String nama, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin-login'),
      body: {'nama': nama, 'password': password},
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      String token = responseData['token'];
      return token;
    } else {
      throw (' ${response.body}');
    }
  }

  // ----------------------- CHECK STATUS OTP --------------------------

  Future<bool> checkOtpStatus(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/check-otp-status?email=$email'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as bool;
    } else {
      throw ('Gagal memeriksa status OTP: ${response.body}');
    }
  }
}
