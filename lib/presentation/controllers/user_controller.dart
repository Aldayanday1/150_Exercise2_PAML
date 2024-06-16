import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kulinerjogja/data/services/user_service.dart';
import 'package:kulinerjogja/domain/model/user.dart';

class UserController {
  final ApiService apiService = ApiService();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

// ----------------------- REGISTER --------------------------

  Future<String> registerUser(User user) async {
    return await apiService.registerUser(user);
  }

  Future<String> verifyOtp(String otp) async {
    return await apiService.verifyOtp(otp);
  }

  // ----------------------- LOGIN USER --------------------------

  Future<String> loginUser(String email, String password) async {
    return await apiService.loginUser(email, password);
  }

  Future<void> loginWithOtp(String otp) async {
    String token = await apiService.loginWithOtp(otp);
    await secureStorage.write(key: 'jwt_token', value: token);
  }

  // ----------------------- LOGIN ADMIN --------------------------

  Future<String> loginAdmin(String nama, String password) async {
    return await apiService.loginAdmin(nama, password);
  }

  // ----------------------- CHECK OTP STATUS --------------------------

  Future<bool> checkOtpStatus(String email) async {
    return await apiService.checkOtpStatus(email);
  }
}
