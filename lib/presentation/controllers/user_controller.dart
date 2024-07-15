import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sistem_pengaduan/data/services/user_service.dart';
import 'package:sistem_pengaduan/domain/model/user.dart';
import 'package:sistem_pengaduan/domain/model/user_profile.dart';

class UserController {
  final ApiService apiService = ApiService();

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

  Future<String> loginWithOtp(String otp) async {
    return await apiService.loginWithOtp(otp);
  }

  // ----------------------- LOGIN ADMIN --------------------------

  Future<String> loginAdmin(String nama, String password) async {
    return await apiService.loginAdmin(nama, password);
  }

  // ---------------- LOGOUT & BLACKLIST TOKEN ----------------

  Future<void> logout() async {
    try {
      await apiService.logout();
    } catch (e) {
      debugPrint('Error: $e');
      throw e;
    }
  }

  // -------------- GET USER PROFILE -------------------

  Future<UserProfile?> getUserProfile() async {
    try {
      return await apiService.getUserProfile();
    } catch (e) {
      // Handle error saat memuat profil pengguna
      debugPrint('Error: $e');
      throw e;
    }
  }

  // -------------- UPDATE USER PROFILE -------------------

  Future<String> updateUserProfile(
      File? profileImage, File? backgroundImage) async {
    try {
      // Inisialisasi path untuk gambar profil dan background sebagai default string (belum diisi)
      String profileImagePath = '';
      String backgroundImagePath = '';

      // Jika gambar profil tidak null (sudah diisi), setel path gambar profil
      if (profileImage != null) {
        profileImagePath = profileImage.path;
      }

      // Jika gambar latar belakang tidak null (sudah diisi), setel path gambar background
      if (backgroundImage != null) {
        backgroundImagePath = backgroundImage.path;
      }

      // Memanggil metode updateUserProfile dari apiService dan mengembalikan hasilnya
      return await apiService.updateUserProfile(
          profileImagePath, backgroundImagePath);
    } catch (e) {
      // Menangani kesalahan saat mengupdate profil pengguna
      debugPrint('Error: $e');
      throw e;
    }
  }

  // ------------ UPLOAD IMAGE (ADMIN) -----------------

  // Future<String> uploadImage(int pengaduanId, File imageFile) async {
  //   try {
  //     return await apiService.uploadImage(pengaduanId, imageFile);
  //   } catch (e) {
  //     throw Exception('Gagal mengunggah gambar: $e');
  //   }
  // }

  // ----------------------- STATUS LAPORAN -----------------------

  // ----------------------- CHECK OTP STATUS --------------------------

  Future<bool> checkOtpStatus(String email) async {
    return await apiService.checkOtpStatus(email);
  }
}
