class KulinerController {

  final KulinerService kulinerService = KulinerService();

  Future<Map<String, dynamic>> addKuliner(Kuliner kuliner, File? file) async {
    Map<String, String> data = {
      'nama': kuliner.nama,
      'alamat': kuliner.alamat,
      'deskripsi': kuliner.deskripsi
    };
  }
}