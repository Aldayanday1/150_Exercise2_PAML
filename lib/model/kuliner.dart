// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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
    required this.gambar,
    required this.deskripsi,
  });

  Kuliner copyWith({
    int? id,
    String? nama,
    String? alamat,
    String? gambar,
    String? deskripsi,
  }) {
    return Kuliner(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      gambar: gambar ?? this.gambar,
      deskripsi: deskripsi ?? this.deskripsi,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'gambar': gambar,
      'deskripsi': deskripsi,
    };
  }

  factory Kuliner.fromMap(Map<String, dynamic> map) {
    return Kuliner(
      id: map['id'] as int,
      nama: map['nama'] as String,
      alamat: map['alamat'] as String,
      gambar: map['gambar'] as String,
      deskripsi: map['deskripsi'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Kuliner.fromJson(String source) =>
      Kuliner.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Kuliner(id: $id, nama: $nama, alamat: $alamat, gambar: $gambar, deskripsi: $deskripsi)';
  }

  @override
  bool operator ==(covariant Kuliner other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nama == nama &&
        other.alamat == alamat &&
        other.gambar == gambar &&
        other.deskripsi == deskripsi;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nama.hashCode ^
        alamat.hashCode ^
        gambar.hashCode ^
        deskripsi.hashCode;
  }
}
