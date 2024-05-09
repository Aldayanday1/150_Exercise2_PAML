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
  }
}