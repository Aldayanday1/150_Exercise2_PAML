import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kulinerjogja/domain/model/daily_graph.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';

class KulinerService {
  final String baseUrl = 'http://192.168.56.1:8080/api/users';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Uri getUri(String path) {
    return Uri.parse("$baseUrl$path");
  }

  // -------------- POST -------------------

  Future<http.Response> tambahKuliner(
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

  Future<List<Kuliner>> fetchKuliner() async {
    try {
      final response = await http.get(getUri('/all'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Kuliner> kuliner =
            decodedResponse.map((json) => Kuliner.fromJson(json)).toList();
        return kuliner;
      } else {
        throw Exception('Failed to load kuliner: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  // -------------- GET KULINER BY ID -------------------

  Future<List<Kuliner>> getMyKuliner() async {
    // Mengambil token dari secure storage
    final token = await secureStorage.read(key: 'jwt_token');
    print('Get JWT from secureStorage (Menu by ID User): $token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan di secure storage');
    }

    // Lanjutkan permintaan HTTP dengan token yang valid
    final response = await http.get(
      Uri.parse('$baseUrl/my-kuliner'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<Kuliner> kulinerList =
          jsonList.map((json) => Kuliner.fromJson(json)).toList();
      return kulinerList;
    } else if (response.statusCode == 401) {
      // Token tidak valid atau tidak ada, arahkan pengguna kembali ke halaman login
      await secureStorage.delete(key: 'jwt_token'); // Hapus token dari storage
      print('Token has been Revoked (expired): $secureStorage');
      throw Exception('Token tidak valid. Silakan login kembali.');
    } else {
      throw Exception('Gagal memuat kuliner: ${response.body}');
    }
  }

  // ------------ GET KULINER BY STATUS -----------------

  Future<List<Kuliner>> getKulinerByStatus(String status) async {
    final response =
        await http.get(Uri.parse('$baseUrl/kuliner-by-status/$status'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Kuliner.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load kuliner');
    }
  }

  // -------------- GET GRAPH COUNT -------------------

  Future<List<KulinerDaily>> fetchDailyKulinerCount() async {
    final response = await http.get(Uri.parse('$baseUrl/daily-count'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      List<KulinerDaily> kulinerList = [
        'MONDAY',
        'TUESDAY',
        'WEDNESDAY',
        'THURSDAY',
        'FRIDAY',
        'SATURDAY',
        'SUNDAY'
      ].map((day) {
        int count = json[day] ?? 0; // default value is 0 if data not exist
        return KulinerDaily(day: day, count: count);
      }).toList();

      return kulinerList;
    } else {
      throw Exception('Failed to load daily kuliner count');
    }
  }

  // -------------- PUT -------------------

  Future<http.Response> updateKuliner(
      int id, Map<String, String> data, File? file) async {
    // Membuat URI untuk endpoint update dengan ID kuliner
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

  Future<http.Response> deleteKuliner(int id) async {
    // Membuat URI untuk endpoint delete dengan ID kuliner
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

  Future<List<Kuliner>> fetchKategoriMakanan() async {
    try {
      final response = await http.get(getUri('/kategori/makanan'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Kuliner> kategoriMakanan =
            decodedResponse.map((data) => Kuliner.fromJson(data)).toList();
        return kategoriMakanan;
      } else {
        throw Exception(
            'Failed to fetch kategori makanan: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Kuliner>> fetchKategoriMinuman() async {
    try {
      final response = await http.get(getUri('/kategori/minuman'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Kuliner> kategoriMinuman =
            decodedResponse.map((data) => Kuliner.fromJson(data)).toList();
        return kategoriMinuman;
      } else {
        throw Exception(
            'Failed to fetch kategori minuman: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Kuliner>> fetchKategoriKue() async {
    try {
      final response = await http.get(getUri('/kategori/kue'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Kuliner> kategoriKue =
            decodedResponse.map((data) => Kuliner.fromJson(data)).toList();
        return kategoriKue;
      } else {
        throw Exception(
            'Failed to fetch kategori kue: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Kuliner>> fetchKategoriDessert() async {
    try {
      final response = await http.get(getUri('/kategori/dessert'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Kuliner> kategoriDessert =
            decodedResponse.map((data) => Kuliner.fromJson(data)).toList();
        return kategoriDessert;
      } else {
        throw Exception(
            'Failed to fetch kategori dessert: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Kuliner>> fetchKategoriSnack() async {
    try {
      final response = await http.get(getUri('/kategori/snack'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Kuliner> kategoriSnack =
            decodedResponse.map((data) => Kuliner.fromJson(data)).toList();
        return kategoriSnack;
      } else {
        throw Exception(
            'Failed to fetch kategori snack: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Kuliner>> fetchKategoriBread() async {
    try {
      final response = await http.get(getUri('/kategori/bread'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Kuliner> kategoriBread =
            decodedResponse.map((data) => Kuliner.fromJson(data)).toList();
        return kategoriBread;
      } else {
        throw Exception(
            'Failed to fetch kategori bread: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Kuliner>> fetchKategoriTea() async {
    try {
      final response = await http.get(getUri('/kategori/tea'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Kuliner> kategoriTea =
            decodedResponse.map((data) => Kuliner.fromJson(data)).toList();
        return kategoriTea;
      } else {
        throw Exception(
            'Failed to fetch kategori tea: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Kuliner>> fetchKategoriCoffee() async {
    try {
      final response = await http.get(getUri('/kategori/coffee'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Kuliner> kategoriCoffee =
            decodedResponse.map((data) => Kuliner.fromJson(data)).toList();
        return kategoriCoffee;
      } else {
        throw Exception(
            'Failed to fetch kategori coffee: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<List<Kuliner>> fetchKategoriJuice() async {
    try {
      final response = await http.get(getUri('/kategori/juice'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Kuliner> kategoriJuice =
            decodedResponse.map((data) => Kuliner.fromJson(data)).toList();
        return kategoriJuice;
      } else {
        throw Exception(
            'Failed to fetch kategori juice: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  // -------------- SEARCH -------------------

  Future<List<Kuliner>> searchKuliner(String query) async {
    try {
      final response = await http.get(getUri('/search?nama=$query'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        List<Kuliner> kulinerList = decodedResponse
            .map((json) => Kuliner.fromJson(json))
            .toList(); // Konversi ke List<Kuliner>
        return kulinerList;
      } else {
        throw Exception('Failed to search kuliner: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }
}
