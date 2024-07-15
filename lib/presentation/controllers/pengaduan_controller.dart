// mengkonsumsi api dari database

import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sistem_pengaduan/data/services/pengaduan_service.dart';
import 'package:sistem_pengaduan/domain/model/pengaduan.dart';

class PengaduanController {
  final PengaduanService pengaduanService = PengaduanService();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // -------------- POST -------------------

  Future<Map<String, dynamic>> addPengaduan(
      Pengaduan pengaduan, File? file) async {
    Map<String, String> data = {
      'judul': pengaduan.judul,
      'alamat': pengaduan.alamat,
      'deskripsi': pengaduan.deskripsi,
      'kategori': Kategori.kategoriToString(pengaduan.kategori),
      'latitude': pengaduan.latitude.toString(),
      'longitude': pengaduan.longitude.toString(),
      'namaPembuat': pengaduan.namaPembuat,
      'profileImagePembuat': pengaduan.profileImagePembuat,
    };

    try {
      var response = await pengaduanService.tambahPengaduan(data, file);

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        Pengaduan addedPengaduan = Pengaduan.fromJson(responseData);

        return {
          'success': true,
          'message': addedPengaduan.dateMessage,
          'pengaduan': addedPengaduan,
        };
      } else if (response.statusCode == 401) {
        await secureStorage.delete(
            key: 'jwt_token'); // Hapus token dari storage
        print('Token has been Revoked (expired): $secureStorage');
        return {
          'success': false,
          'message': 'Token tidak valid. Silakan login kembali.',
        };
      } else {
        var decodedJson = jsonDecode(response.body);
        return {
          'success': false,
          'message': decodedJson['message'] ?? 'Terjadi kesalahan',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // -------------- GET ALL DATA -------------------

  Future<List<Pengaduan>> getAllPengaduan() async {
    try {
      return await pengaduanService.fetchPengaduan();
    } catch (e) {
      print('Error fetching All pengaduan: $e');
      throw Exception(
        'Failed to get All pengaduan',
      );
    }
  }

  // -------------- GET PENGADUAN BY ID -------------------

  Future<List<Pengaduan>> getMyPengaduan() async {
    return await pengaduanService.getMyPengaduan();
  }

  // ------------- GET PENGADUAN BY STATUS ------------------

  Future<List<Pengaduan>> getPengaduanByStatus(String status) {
    return pengaduanService.getPengaduanByStatus(status);
  }

  // -------------- GET GRAPH COUNT (LANGSUNG DI GRAPH WIDGET SCREEN) -------------------

  // -------------- PUT -------------------

  Future<Map<String, dynamic>> updatePengaduan(
      Pengaduan pengaduan, File? file) async {
    Map<String, String> data = {
      'judul': pengaduan.judul,
      'alamat': pengaduan.alamat,
      'deskripsi': pengaduan.deskripsi,
      'kategori': Kategori.kategoriToString(pengaduan.kategori),
      'latitude': pengaduan.latitude.toString(),
      'longitude': pengaduan.longitude.toString(),
    };

    try {
      var response =
          await pengaduanService.updatePengaduan(pengaduan.id, data, file);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        Pengaduan updatedPengaduan = Pengaduan.fromJson(responseData);
        // HttpStatus.OK
        return {
          'success': true,
          'message': updatedPengaduan.dateMessage,
          'pengaduan': updatedPengaduan,
        };
        // HttpStatus.BAD_REQUEST
      } else if (response.statusCode == 400) {
        return {
          'success': false,
          'message': response.body,
        };
        // HttpStatus.UNAUTHORIZED
      } else if (response.statusCode == 401) {
        await secureStorage.delete(
            key: 'jwt_token'); // Hapus token dari storage
        print('Token has been Revoked (expired): $secureStorage');
        return {
          'success': false,
          'message': 'Token tidak valid. Silakan login kembali.',
        };
        // HttpStatus.FORBIDDEN
      } else if (response.statusCode == 403) {
        return {
          'success': false,
          'message': 'Anda tidak diizinkan untuk mengubah pengaduan ini.',
        };
        // HttpStatus.NOT_FOUND
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Pengguna atau pengaduan tidak ditemukan.',
        };
      } else {
        var decodedJson = jsonDecode(response.body);
        return {
          'success': false,
          'message': decodedJson['message'] ?? 'Terjadi kesalahan',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // -------------- DELETE -------------------

  Future<Map<String, dynamic>> deletePengaduan(int id) async {
    try {
      var response = await pengaduanService.deletePengaduan(id);
      // HttpStatus.OK
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Data berhasil dihapus',
        };
        // HttpStatus.UNAUTHORIZED
      } else if (response.statusCode == 401) {
        await secureStorage.delete(
            key: 'jwt_token'); // Hapus token dari storage
        print('Token has been Revoked (expired): $secureStorage');
        return {
          'success': false,
          'message': 'Token tidak valid. Silakan login kembali.',
        };
        // HttpStatus.FORBIDDEN
      } else if (response.statusCode == 403) {
        return {
          'success': false,
          'message': 'Anda tidak diizinkan untuk menghapus pengaduan ini.',
        };
        // HttpStatus.NOT_FOUND
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Pengguna atau pengaduan tidak ditemukan.',
        };
        // HttpStatus.INTERNAL_SERVER_ERROR
      } else if (response.statusCode == 500) {
        return {
          'success': false,
          'message': 'Terjadi kesalahan pada server.',
        };
      } else {
        var decodedJson = jsonDecode(response.body);
        return {
          'success': false,
          'message':
              decodedJson['message'] ?? 'Terjadi kesalahan saat mendelete data',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // -------------- FETCH CATGORY FILTERING -------------------

  Future<List<Pengaduan>> fetchKategoriInfrastruktur() async {
    try {
      return await pengaduanService.fetchKategoriInfrastruktur();
    } catch (e) {
      print('Error fetching kategori infrastruktur: $e');
      throw Exception(
        'Failed to get Kategori Infrastruktur',
      );
    }
  }

  Future<List<Pengaduan>> fetchKategoriLingkungan() async {
    try {
      return await pengaduanService.fetchKategoriLingkungan();
    } catch (e) {
      print('Error fetching kategori lingkungan: $e');
      throw Exception(
        'Failed to get Kategori Lingkungan',
      );
    }
  }

  Future<List<Pengaduan>> fetchKategoriTransportasi() async {
    try {
      return await pengaduanService.fetchKategoriTransportasi();
    } catch (e) {
      print('Error fetching kategori transportasi: $e');
      throw Exception(
        'Failed to get Kategori Transportasi',
      );
    }
  }

  Future<List<Pengaduan>> fetchKategoriKeamanan() async {
    try {
      return await pengaduanService.fetchKategoriKeamanan();
    } catch (e) {
      print('Error fetching kategori keamanan: $e');
      throw Exception(
        'Failed to get Kategori Keamanan',
      );
    }
  }

  Future<List<Pengaduan>> fetchKategoriKesehatan() async {
    try {
      return await pengaduanService.fetchKategoriKesehatan();
    } catch (e) {
      print('Error fetching kategori kesehatan: $e');
      throw Exception(
        'Failed to get Kategori Kesehatan',
      );
    }
  }

  Future<List<Pengaduan>> fetchKategoriPendidikan() async {
    try {
      return await pengaduanService.fetchKategoriPendidikan();
    } catch (e) {
      print('Error fetching kategori pendidikan: $e');
      throw Exception(
        'Failed to get Kategori Pendidikan',
      );
    }
  }

  Future<List<Pengaduan>> fetchKategoriSosial() async {
    try {
      return await pengaduanService.fetchKategoriSosial();
    } catch (e) {
      print('Error fetching kategori sosial: $e');
      throw Exception(
        'Failed to get Kategori Sosial',
      );
    }
  }

  Future<List<Pengaduan>> fetchKategoriIzin() async {
    try {
      return await pengaduanService.fetchKategoriIzin();
    } catch (e) {
      print('Error fetching kategori izin: $e');
      throw Exception(
        'Failed to get Kategori Izin',
      );
    }
  }

  Future<List<Pengaduan>> fetchKategoriBirokrasi() async {
    try {
      return await pengaduanService.fetchKategoriBirokrasi();
    } catch (e) {
      print('Error fetching kategori birokrasi: $e');
      throw Exception(
        'Failed to get Kategori Birokrasi',
      );
    }
  }

  Future<List<Pengaduan>> fetchKategoriLainnya() async {
    try {
      return await pengaduanService.fetchKategoriLainnya();
    } catch (e) {
      print('Error fetching kategori lainnya: $e');
      throw Exception(
        'Failed to get Kategori Lainnya',
      );
    }
  }

  // -------------- SEARCH -------------------

  Future<List<Pengaduan>> searchPengaduan(String query) async {
    try {
      List<dynamic> pengaduanData =
          await pengaduanService.searchPengaduan(query);
      List<Pengaduan> pengaduan =
          pengaduanData.map((json) => Pengaduan.fromJson(json)).toList();
      return pengaduan;
    } catch (e) {
      throw Exception('Failed to search pengaduan');
    }
  }
}
