// mengkonsumsi api dari database

import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';
import 'package:kulinerjogja/data/services/kuliner_service.dart';

class KulinerController {
  final KulinerService kulinerService = KulinerService();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // -------------- POST -------------------

  Future<Map<String, dynamic>> addKuliner(Kuliner kuliner, File? file) async {
    Map<String, String> data = {
      'nama': kuliner.nama,
      'alamat': kuliner.alamat,
      'deskripsi': kuliner.deskripsi,
      'kategori': Kategori.kategoriToString(kuliner.kategori),
      'latitude': kuliner.latitude.toString(),
      'longitude': kuliner.longitude.toString(),
      'namaPembuat': kuliner.namaPembuat,
      'profileImagePembuat': kuliner.profileImagePembuat,
    };

    try {
      var response = await kulinerService.tambahKuliner(data, file);

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        Kuliner addedKuliner = Kuliner.fromJson(responseData);

        return {
          'success': true,
          'message': addedKuliner.dateMessage,
          'kuliner': addedKuliner,
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

  Future<List<Kuliner>> getAllKuliner() async {
    try {
      return await kulinerService.fetchKuliner();
    } catch (e) {
      print('Error fetching All kuliner: $e');
      throw Exception(
        'Failed to get All kuliner',
      );
    }
  }

  // -------------- GET KULINER BY ID -------------------

  Future<List<Kuliner>> getMyKuliner() async {
    return await kulinerService.getMyKuliner();
  }

  // ------------ GET KULINER BY STATUS -----------------

  Future<List<Kuliner>> getKulinerByStatus(String status) {
    return kulinerService.getKulinerByStatus(status);
  }

  // -------------- GET GRAPH COUNT (LANGSUNG DI GRAPH WIDGET SCREEN) -------------------

  // -------------- PUT -------------------

  Future<Map<String, dynamic>> updateKuliner(
      Kuliner kuliner, File? file) async {
    Map<String, String> data = {
      'nama': kuliner.nama,
      'alamat': kuliner.alamat,
      'deskripsi': kuliner.deskripsi,
      'kategori': Kategori.kategoriToString(kuliner.kategori),
      'latitude': kuliner.latitude.toString(),
      'longitude': kuliner.longitude.toString(),
    };

    try {
      var response = await kulinerService.updateKuliner(kuliner.id, data, file);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        Kuliner updatedKuliner = Kuliner.fromJson(responseData);
        // HttpStatus.OK
        return {
          'success': true,
          'message': updatedKuliner.dateMessage,
          'kuliner': updatedKuliner,
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
          'message': 'Anda tidak diizinkan untuk mengubah kuliner ini.',
        };
        // HttpStatus.NOT_FOUND
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Pengguna atau kuliner tidak ditemukan.',
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

  Future<Map<String, dynamic>> deleteKuliner(int id) async {
    try {
      var response = await kulinerService.deleteKuliner(id);
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
          'message': 'Anda tidak diizinkan untuk menghapus kuliner ini.',
        };
        // HttpStatus.NOT_FOUND
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Pengguna atau kuliner tidak ditemukan.',
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

  Future<List<Kuliner>> fetchKategoriMakanan() async {
    try {
      return await kulinerService.fetchKategoriMakanan();
    } catch (e) {
      print('Error fetching kategori makanan: $e');
      throw Exception(
        'Failed to get Kategori makanan',
      );
    }
  }

  Future<List<Kuliner>> fetchKategoriMinuman() async {
    try {
      return await kulinerService.fetchKategoriMinuman();
    } catch (e) {
      print('Error fetching kategori minuman: $e');
      throw Exception(
        'Failed to get Kategori Minuman',
      );
    }
  }

  Future<List<Kuliner>> fetchKategoriKue() async {
    try {
      return await kulinerService.fetchKategoriKue();
    } catch (e) {
      print('Error fetching kategori kue: $e');
      throw Exception(
        'Failed to get Kategori Kue',
      );
    }
  }

  Future<List<Kuliner>> fetchKategoriDessert() async {
    try {
      return await kulinerService.fetchKategoriDessert();
    } catch (e) {
      print('Error fetching kategori dessert: $e');
      throw Exception(
        'Failed to get Kategori Dessert',
      );
    }
  }

  Future<List<Kuliner>> fetchKategoriSnack() async {
    try {
      return await kulinerService.fetchKategoriSnack();
    } catch (e) {
      print('Error fetching kategori snack: $e');
      throw Exception(
        'Failed to get Kategori Snack',
      );
    }
  }

  Future<List<Kuliner>> fetchKategoriBread() async {
    try {
      return await kulinerService.fetchKategoriBread();
    } catch (e) {
      print('Error fetching kategori bread: $e');
      throw Exception(
        'Failed to get Kategori Bread',
      );
    }
  }

  Future<List<Kuliner>> fetchKategoriTea() async {
    try {
      return await kulinerService.fetchKategoriTea();
    } catch (e) {
      print('Error fetching kategori tea: $e');
      throw Exception(
        'Failed to get Kategori Tea',
      );
    }
  }

  Future<List<Kuliner>> fetchKategoriCoffee() async {
    try {
      return await kulinerService.fetchKategoriCoffee();
    } catch (e) {
      print('Error fetching kategori coffee: $e');
      throw Exception(
        'Failed to get Kategori Coffee',
      );
    }
  }

  Future<List<Kuliner>> fetchKategoriJuice() async {
    try {
      return await kulinerService.fetchKategoriJuice();
    } catch (e) {
      print('Error fetching kategori juice: $e');
      throw Exception(
        'Failed to get Kategori Juice',
      );
    }
  }

  // -------------- SEARCH -------------------

  Future<List<Kuliner>> searchKuliner(String query) async {
    try {
      List<dynamic> kulinerData = await kulinerService.searchKuliner(query);
      List<Kuliner> kuliner =
          kulinerData.map((json) => Kuliner.fromJson(json)).toList();
      return kuliner;
    } catch (e) {
      throw Exception('Failed to search kuliner');
    }
  }
}
