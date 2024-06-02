import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kulinerjogja/domain/model/kuliner.dart';

class KulinerService {
  final String baseUrl = 'http://192.168.56.1:8080/kuliner_150/';

  Uri getUri(String path) {
    return Uri.parse("$baseUrl$path");
  }

  // -------------- POST -------------------

  Future<http.Response> tambahKuliner(
      Map<String, String> data, File? file) async {
    var request = http.MultipartRequest(
      'POST',
      getUri('add'),
    );

    request.fields.addAll(data);

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('gambar', file.path));
    }

    // request.send(); -> mengirim permintaan http request ke server
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  // Future<List<dynamic>> fetchKuuliner() async {
  //   var response = await http.get(
  //     getUri('all'),
  //     headers: {
  //       HttpHeaders.acceptHeader: "application/json",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     final List<dynamic> decodedResponse = json.decode(response.body);
  //     return decodedResponse;
  //   } else {
  //     throw Exception('Failed to load kuliner: ${response.reasonPhrase}');
  //   }
  // }

  // -------------- GET ALL -------------------

  Future<List<Kuliner>> fetchKuliner() async {
    try {
      final response = await http.get(getUri('all'));
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

  // -------------- PUT -------------------

  Future<http.Response> updateKuliner(
      int id, Map<String, String> data, File? file) async {
    var request = http.MultipartRequest(
      'PUT',
      getUri('update/$id'),
    );

    request.fields.addAll(data);

    // Tambahkan file gambar jika ada
    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('gambar', file.path));
    }

    // Kirim permintaan dan dapatkan respons
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  // -------------- DELETE -------------------

  Future<http.Response> deleteKuliner(int id) async {
    return await http.delete(
      getUri('delete/$id'),
      headers: {
        "Accept": "application/json",
      },
    );
  }

  // -------------- CATEGORY FILTERING -------------------

  Future<List<Kuliner>> fetchKategoriMakanan() async {
    try {
      final response = await http.get(getUri('kategori/makanan'));
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
      final response = await http.get(getUri('kategori/minuman'));
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
      final response = await http.get(getUri('kategori/kue'));
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
      final response = await http.get(getUri('kategori/dessert'));
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
      final response = await http.get(getUri('kategori/snack'));
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
      final response = await http.get(getUri('kategori/bread'));
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
      final response = await http.get(getUri('kategori/tea'));
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
      final response = await http.get(getUri('kategori/coffee'));
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
      final response = await http.get(getUri('kategori/juice'));
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
      final response = await http.get(getUri('search?nama=$query'));
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
