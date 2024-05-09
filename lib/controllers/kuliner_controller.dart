// mengkonsumsi api dari database

import 'dart:convert';
import 'dart:io';

import 'package:kulinerjogja/model/kuliner.dart';
import 'package:kulinerjogja/services/kuliner_service.dart';

class KulinerController {
  final KulinerService kulinerService = KulinerService();

  Future<Map<String, dynamic>> addKuliner(Kuliner kuliner, File? file) async {
    Map<String, String> data = {
      'nama': kuliner.nama,
      'alamat': kuliner.alamat,
      'deskripsi': kuliner.deskripsi
    };

    try {
      var response = await kulinerService.tambahKuliner(data, file);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Data berhasil disimpan',
        };
      } else {
        if (response.headers['content-type']!.contains('application/json')) {
          var decodedJson = jsonDecode(response.body);
          return {
            'success': false,
            'message': decodedJson['message'] ?? 'Terjadi kesalahan',
          };
        }
        var decodedJson = jsonDecode(response.body);
        return {
          'success': false,
          'message':
              decodedJson['message'] ?? 'Terjadi kesalahan saat menyimpan data',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  Future<List<Kuliner>> getAllKuliner() async {
    try {
      List<dynamic> kulinerData = await kulinerService.fetchKuliner();
      List<Kuliner> kuliner =
          kulinerData.map((json) => Kuliner.fromJson(json)).toList();
      return kuliner;
    } catch (e) {
      print('Error in getAllKuliner: $e');
      throw Exception('Failed to get All kuliner');
    }
  }

  Future<Map<String, dynamic>> updateKuliner(
      Kuliner kuliner, File? file) async {
    Map<String, String> data = {
      'nama': kuliner.nama,
      'alamat': kuliner.alamat,
      'deskripsi': kuliner.deskripsi
    };

    try {
      var response = await kulinerService.updateKuliner(kuliner.id, data, file);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message':
              response.body, // Menggunakan pesan yang diberikan oleh server
        };
      } else {
        // Jika status code lain, tampilkan pesan kesalahan default
        return {
          'success': false,
          'message': 'Terjadi kesalahan saat memperbarui data',
        };
      }
    } catch (e) {
      // Menangkap kesalahan jaringan atau saat decoding JSON
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
}
