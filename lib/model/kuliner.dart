class Kuliner {
  int id;
  String nama;
  String alamat;
  String gambar;
  String deskripsi;

  Kuliner({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.deskripsi,
    required this.gambar,
  });

  factory Kuliner.fromJson(Map<String, dynamic> json) {
    return Kuliner(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      gambar: json['gambar'],
      deskripsi: json['deskripsi'],
    );
  }
}
