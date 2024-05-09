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
}