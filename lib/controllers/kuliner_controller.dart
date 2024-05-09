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
}