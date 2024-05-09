class class KulinerService {

  final String baseUrl = 'http://192.168.56.1:8080/kuliner_150/';

  Uri getUri(String path) {
    return Uri.parse("$baseUrl$path");
  }

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

    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<List<dynamic>> fetchKuliner() async {
    var response = await http.get(
      getUri('all'),
      headers: {
        HttpHeaders.acceptHeader: "application/json",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> decodedResponse = json.decode(response.body);
      return decodedResponse;
    } else {
      throw Exception('Failed to load kuliner: ${response.reasonPhrase}');
    }
  }

  Future<http.Response> updateKuliner(
      int id, Map<String, String> data, File? file) async {
    var request = http.MultipartRequest(
      'PUT',
      getUri('update/$id'),
    );

    request.fields.addAll(data);

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('gambar', file.path));
    }

    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> deleteKuliner(int id) async {
    return await http.delete(
      getUri('delete/$id'),
      headers: {
        "Accept": "application/json",
      },
    );
  }
}