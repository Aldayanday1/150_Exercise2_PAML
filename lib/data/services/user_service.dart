import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kulinerjogja/domain/model/status_laporan.dart';
import 'package:kulinerjogja/domain/model/user.dart';
import 'package:kulinerjogja/domain/model/user_profile.dart';

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
        print('Token JWT User: $token');

        // mengembalikan (return) nilai token, sehingga nilai token JWT ini dapat digunakan di tempat lain di aplikasi (misalnya untuk mengakses endpoint yang memerlukan otentikasi).
        return token;
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
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nama': nama, 'password': password}),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      String token = responseData['token'];

      // Simpan token JWT ke secure storage
      await secureStorage.write(key: 'jwt_token', value: token);

      // Cetak token ke konsol (console)
      print('Token JWT Admin: $token');

      return "Login berhasil";
    } else {
      var responseBody = jsonDecode(response.body);
      throw responseBody['message'];
    }
  }

  // ---------------- LOGOUT & BLACKLIST TOKEN ----------------

  Future<void> logout() async {
    String? token = await secureStorage.read(key: 'jwt_token');
    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Hapus token dari secure storage setelah logout berhasil
      await secureStorage.delete(key: 'jwt_token');
      print('Get JWT from secureStorage (Token has been revoked): $token');
    } else {
      throw Exception('Gagal logout: ${response.body}');
    }
  }

  // ----------------------- GET USER PROFILE -----------------------

  Future<UserProfile?> getUserProfile() async {
    // Mendapatkan token dari secure storage
    String? token = await secureStorage.read(key: 'jwt_token');
    print('Get JWT from secureStorage (get user profile): $token');
    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    // Melakukan GET request untuk mengambil profil pengguna
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // Memeriksa respons dari server
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserProfile.fromJson(data);
    } else if (response.statusCode == 401) {
      // Token tidak valid atau tidak ada, arahkan pengguna kembali ke halaman login
      await secureStorage.delete(key: 'jwt_token'); // Hapus token dari storage
      print('Token has been Revoked (expired): $secureStorage');
      throw Exception('Token tidak valid. Silakan login kembali.');
    } else {
      throw Exception('Gagal memuat profil pengguna: ${response.body}');
    }
  }

  // ----------------------- UPDATE USER PROFILE -----------------------

  Future<String> updateUserProfile(
      String profileImagePath, String backgroundImagePath) async {
    // Mendapatkan token dari secure storage
    String? token = await secureStorage.read(key: 'jwt_token');
    print('Get JWT from secureStorage (update user profile): $token');
    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    // Membuat request multipart untuk update profil pengguna
    var request =
        http.MultipartRequest('PUT', Uri.parse('$baseUrl/profile/update'));
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    // Menambahkan file gambar profil jika ada perubahan
    if (profileImagePath.isNotEmpty) {
      request.files.add(
          await http.MultipartFile.fromPath('profileImage', profileImagePath));
    }

    // Menambahkan file gambar latar belakang jika ada perubahan
    if (backgroundImagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
          'backgroundImage', backgroundImagePath));
    }

    // Melakukan request dan mengambil respons
    final response = await request.send();
    final responseData = await http.Response.fromStream(response);

    // Memeriksa respons dari server
    if (response.statusCode == 200) {
      return 'Profil pengguna berhasil diperbarui.';
    } else if (response.statusCode == 400 &&
        responseData.body.contains('Tidak ada perubahan yang dilakukan')) {
      return 'Tidak ada perubahan yang dilakukan.';
    } else if (response.statusCode == 401) {
      // Token tidak valid atau tidak ada, arahkan pengguna kembali ke halaman login
      await secureStorage.delete(key: 'jwt_token'); // Hapus token dari storage
      print('Token has been Revoked (expired): $secureStorage');
      throw Exception('Token tidak valid. Silakan login kembali.');
    } else {
      throw Exception(
          'Gagal memperbarui profil pengguna: ${responseData.body}');
    }
  }

  // ------------------- UPDATE STATUS LAPORAN (ADMIN) -------------------

  Future<void> updateStatusLaporan(
      int kulinerId, StatusLaporan statusLaporan) async {
    try {
      // Mengambil token dari secure storage
      final token = await secureStorage.read(key: 'jwt_token');
      print(
          'Get JWT from secureStorage (update status laporan - admin): $token');

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan di secure storage');
      }

      // Lanjutkan permintaan HTTP dengan token yang valid
      final response = await http.put(
        Uri.parse('$baseUrl/update-status/$kulinerId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(statusLaporan.toJson()),
      );

      if (response.statusCode == 200) {
        print('Status laporan berhasil diperbarui');
      } else if (response.statusCode == 401) {
        // Token tidak valid atau tidak ada, arahkan pengguna kembali ke halaman login
        await secureStorage.delete(
            key: 'jwt_token'); // Hapus token dari storage
        print('Token has been Revoked (expired): $secureStorage');
        throw Exception('Token tidak valid. Silakan login kembali.');
      }
    } catch (e) {
      print('Gagal memperbarui status laporan: $e');
      throw Exception('Gagal memperbarui status laporan: $e');
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
