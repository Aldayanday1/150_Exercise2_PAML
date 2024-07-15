import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sistem_pengaduan/domain/model/daily_graph.dart';
import 'package:sistem_pengaduan/domain/model/pengaduan.dart';

class PengaduanService {
  final String baseUrl = 'http://192.168.56.1:8080/api/users';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Uri getUri(String path) {
    return Uri.parse("$baseUrl$path");
  }

  // -------------- POST -------------------

  Future<http.Response> tambahPengaduan(
      Map<String, String> data, File? file) async {
    var request = http.MultipartRequest('POST', getUri('/add'));

    request.fields.addAll(data);

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('gambar', file.path));
    }

    // Mengambil token dari secure storage
    String? token = await secureStorage.read(key: 'jwt_token');
    print('Get JWT from secureStorage (create): $token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // request.send(); -> mengirim permintaan http request ke server
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  // -------------- GET ALL -------------------

  Future<List<Pengaduan>> fetchPengaduan() async {
    try {
      final response = await http.get(getUri('/all'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Pengaduan> pengaduan =
            decodedResponse.map((json) => Pengaduan.fromJson(json)).toList();
        return pengaduan;
      } else {
        throw Exception('Failed to load pengaduan: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  // -------------- GET PENGADUAN BY ID  -------------------

  Future<List<Pengaduan>> getMyPengaduan() async {
    // Mengambil token dari secure storage
    final token = await secureStorage.read(key: 'jwt_token');
    print('Get JWT from secureStorage (Menu by ID User): $token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan di secure storage');
    }

    // Lanjutkan permintaan HTTP dengan token yang valid
    final response = await http.get(
      Uri.parse('$baseUrl/my-pengaduan'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<Pengaduan> pengaduanList =
          jsonList.map((json) => Pengaduan.fromJson(json)).toList();
      return pengaduanList;
    } else if (response.statusCode == 401) {
      // Token tidak valid atau tidak ada, arahkan pengguna kembali ke halaman login
      await secureStorage.delete(key: 'jwt_token'); // Hapus token dari storage
      print('Token has been Revoked (expired): $secureStorage');
      throw Exception('Token tidak valid. Silakan login kembali.');
    } else {
      throw Exception('Gagal memuat pengaduan: ${response.body}');
    }
  }

  // ------------ GET PENGADUAN BY STATUS (ADMIN) -----------------

  Future<List<Pengaduan>> getPengaduanByStatus(String status) async {
    final response =
        await http.get(Uri.parse('$baseUrl/pengaduan-by-status/$status'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Pengaduan.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load pengaduan');
    }
  }

  // ------------ GET GRAPH COUNT (ADMIN) -----------------

  Future<List<PengaduanDaily>> fetchDailyPengaduanCount() async {
    try {
      // Mengambil token dari secure storage
      final token = await secureStorage.read(key: 'jwt_token');
      print('Get JWT from secureStorage (get graph count - admin): $token');

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan di secure storage');
      }

      // Lanjutkan permintaan HTTP dengan token yang valid
      final response = await http.get(
        Uri.parse('$baseUrl/daily-count'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        List<PengaduanDaily> pengaduanList = [
          'MONDAY',
          'TUESDAY',
          'WEDNESDAY',
          'THURSDAY',
          'FRIDAY',
          'SATURDAY',
          'SUNDAY'
        ].map((day) {
          int count = json[day] ?? 0; // default value is 0 if data not exist
          return PengaduanDaily(day: day, count: count);
        }).toList();

        return pengaduanList;
      } else if (response.statusCode == 401) {
        // Token tidak valid atau tidak ada, arahkan pengguna kembali ke halaman login
        await secureStorage.delete(
            key: 'jwt_token'); // Hapus token dari storage
        print('Token has been Revoked (expired): $secureStorage');
        throw Exception('Token tidak valid. Silakan login kembali.');
      } else {
        throw Exception(
            'Gagal memuat jumlah data pengaduan per hari: ${response.body}');
      }
    } catch (e) {
      throw Exception(
          'Terjadi kesalahan saat memuat jumlah data pengaduan per hari: $e');
    }
  }

  // -------------- PUT -------------------

  Future<http.Response> updatePengaduan(
      int id, Map<String, String> data, File? file) async {
    // Membuat URI untuk endpoint update dengan ID pengaduan
    var request = http.MultipartRequest('PUT', getUri('/update/$id'));

    // Menambahkan field data ke dalam request
    request.fields.addAll(data);

    // Menambahkan file gambar jika ada
    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('gambar', file.path));
    }

    // Mengambil token dari secure storage
    String? token = await secureStorage.read(key: 'jwt_token');
    print('Get JWT from secureStorage (update): $token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // Kirim permintaan dan dapatkan respons
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  // -------------- DELETE -------------------

  Future<http.Response> deletePengaduan(int id) async {
    // Membuat URI untuk endpoint delete dengan ID pengaduan
    var uri = getUri('/delete/$id');

    // Mengambil token dari secure storage
    String? token = await secureStorage.read(key: 'jwt_token');
    print('Get JWT from secureStorage (delete): $token');

    // Menyiapkan header untuk permintaan
    var headers = {
      "Accept": "application/json", // Menerima response dalam format JSON
    };

    // Menambahkan token ke header jika tersedia
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    // Mengirim permintaan DELETE ke server dengan header yang sudah disiapkan
    return await http.delete(
      uri,
      headers: headers,
    );
  }

  //-------------- CATEGORY FILTERING -------------------

  Future<List<Pengaduan>> fetchKategoriInfrastruktur() async {
    try {
      final response = await http.get(getUri('/kategori/infrastruktur'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Pengaduan> kategoriInfrastruktur =
            decodedResponse.map((data) => Pengaduan.fromJson(data)).toList();
        return kategoriInfrastruktur;
      } else {
        throw Exception(
            'Failed to fetch kategori infrastruktur: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Pengaduan>> fetchKategoriLingkungan() async {
    try {
      final response = await http.get(getUri('/kategori/lingkungan'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Pengaduan> kategoriLingkungan =
            decodedResponse.map((data) => Pengaduan.fromJson(data)).toList();
        return kategoriLingkungan;
      } else {
        throw Exception(
            'Failed to fetch kategori lingkungan: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Pengaduan>> fetchKategoriTransportasi() async {
    try {
      final response = await http.get(getUri('/kategori/transportasi'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Pengaduan> kategoriTransportasi =
            decodedResponse.map((data) => Pengaduan.fromJson(data)).toList();
        return kategoriTransportasi;
      } else {
        throw Exception(
            'Failed to fetch kategori transportasi: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Pengaduan>> fetchKategoriKeamanan() async {
    try {
      final response = await http.get(getUri('/kategori/keamanan'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Pengaduan> kategoriKeamanan =
            decodedResponse.map((data) => Pengaduan.fromJson(data)).toList();
        return kategoriKeamanan;
      } else {
        throw Exception(
            'Failed to fetch kategori keamanan: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Pengaduan>> fetchKategoriKesehatan() async {
    try {
      final response = await http.get(getUri('/kategori/kesehatan'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Pengaduan> kategoriKesehatan =
            decodedResponse.map((data) => Pengaduan.fromJson(data)).toList();
        return kategoriKesehatan;
      } else {
        throw Exception(
            'Failed to fetch kategori kesehatan: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Pengaduan>> fetchKategoriPendidikan() async {
    try {
      final response = await http.get(getUri('/kategori/pendidikan'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Pengaduan> kategoriPendidikan =
            decodedResponse.map((data) => Pengaduan.fromJson(data)).toList();
        return kategoriPendidikan;
      } else {
        throw Exception(
            'Failed to fetch kategori pendidikan: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Pengaduan>> fetchKategoriSosial() async {
    try {
      final response = await http.get(getUri('/kategori/sosial'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Pengaduan> kategoriSosial =
            decodedResponse.map((data) => Pengaduan.fromJson(data)).toList();
        return kategoriSosial;
      } else {
        throw Exception(
            'Failed to fetch kategori sosial: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Pengaduan>> fetchKategoriIzin() async {
    try {
      final response = await http.get(getUri('/kategori/izin'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Pengaduan> kategoriIzin =
            decodedResponse.map((data) => Pengaduan.fromJson(data)).toList();
        return kategoriIzin;
      } else {
        throw Exception(
            'Failed to fetch kategori izin: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Pengaduan>> fetchKategoriBirokrasi() async {
    try {
      final response = await http.get(getUri('/kategori/birokrasi'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Pengaduan> kategoriBirokrasi =
            decodedResponse.map((data) => Pengaduan.fromJson(data)).toList();
        return kategoriBirokrasi;
      } else {
        throw Exception(
            'Failed to fetch kategori birokrasi: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Pengaduan>> fetchKategoriLainnya() async {
    try {
      final response = await http.get(getUri('/kategori/lainnya'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Pengaduan> kategoriLainnya =
            decodedResponse.map((data) => Pengaduan.fromJson(data)).toList();
        return kategoriLainnya;
      } else {
        throw Exception(
            'Failed to fetch kategori Lainnya: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  // -------------- SEARCH -------------------

  Future<List<Pengaduan>> searchPengaduan(String query) async {
    try {
      final response = await http.get(getUri('/search?judul=$query'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Pengaduan> pengaduanList = decodedResponse
            .map((json) => Pengaduan.fromJson(json))
            .toList(); // Konversi ke List<Pengaduan>
        return pengaduanList;
      } else {
        throw Exception('Failed to search pengaduan: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }
}
