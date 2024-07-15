import 'package:intl/intl.dart';

// Enumeration untuk merepresentasikan berbagai kategori pengaduan.
// Setiap kategori memiliki metode untuk mendapatkan tampilan nama kategorinya.
// Terdapat juga metode untuk mengonversi string kategori menjadi enum dan sebaliknya.
// SERIALISASI DATA
enum Kategori {
  // ignore: constant_identifier_names
  INFRASTRUKTUR,
  // ignore: constant_identifier_names
  LINGKUNGAN,
  // ignore: constant_identifier_names
  TRANSPORTASI,
  // ignore: constant_identifier_names
  KEAMANAN,
  // ignore: constant_identifier_names
  KESEHATAN,
  // ignore: constant_identifier_names
  PENDIDIKAN,
  // ignore: constant_identifier_names
  SOSIAL,
  // ignore: constant_identifier_names
  IZIN,
  // ignore: constant_identifier_names
  BIROKRASI,
  // ignore: constant_identifier_names
  LAINNYA;

  // Mendapatkan tampilan nama kategori.
  String get displayName {
    switch (this) {
      case Kategori.INFRASTRUKTUR:
        return 'Infrastruktur';
      case Kategori.LINGKUNGAN:
        return 'Lingkungan';
      case Kategori.TRANSPORTASI:
        return 'Transportasi';
      case Kategori.KEAMANAN:
        return 'Keamanan';
      case Kategori.KESEHATAN:
        return 'Kesehatan';
      case Kategori.PENDIDIKAN:
        return 'Pendidikan';
      case Kategori.SOSIAL:
        return 'Sosial';
      case Kategori.IZIN:
        return 'Izin';
      case Kategori.BIROKRASI:
        return 'Birokrasi';
      case Kategori.LAINNYA:
        return 'Lainnya';
      default:
        throw Exception('Unknown category: $this');
    }
  }

// Mengonversi string kategori menjadi enum Kategori.
  static Kategori fromString(String kategori) {
    switch (kategori) {
      case 'INFRASTRUKTUR':
        return Kategori.INFRASTRUKTUR;
      case 'LINGKUNGAN':
        return Kategori.LINGKUNGAN;
      case 'TRANSPORTASI':
        return Kategori.TRANSPORTASI;
      case 'KEAMANAN':
        return Kategori.KEAMANAN;
      case 'KESEHATAN':
        return Kategori.KESEHATAN;
      case 'PENDIDIKAN':
        return Kategori.PENDIDIKAN;
      case 'SOSIAL':
        return Kategori.SOSIAL;
      case 'IZIN':
        return Kategori.IZIN;
      case 'BIROKRASI':
        return Kategori.BIROKRASI;
      case 'LAINNYA':
        return Kategori.LAINNYA;
      default:
        throw Exception('Unknown category: $kategori');
    }
  }

// Mengonversi enum Kategori menjadi string kategori.
  static String kategoriToString(Kategori kategori) {
    switch (kategori) {
      case Kategori.INFRASTRUKTUR:
        return 'INFRASTRUKTUR';
      case Kategori.LINGKUNGAN:
        return 'LINGKUNGAN';
      case Kategori.TRANSPORTASI:
        return 'TRANSPORTASI';
      case Kategori.KEAMANAN:
        return 'KEAMANAN';
      case Kategori.KESEHATAN:
        return 'KESEHATAN';
      case Kategori.PENDIDIKAN:
        return 'PENDIDIKAN';
      case Kategori.SOSIAL:
        return 'SOSIAL';
      case Kategori.IZIN:
        return 'IZIN';
      case Kategori.BIROKRASI:
        return 'BIROKRASI';
      case Kategori.LAINNYA:
        return 'LAINNYA';
      default:
        throw Exception('Unknown category: $kategori');
    }
  }
}

// Kelas model untuk merepresentasikan data pengaduan.
class Pengaduan {
  int id;
  String judul;
  String deskripsi;
  String alamat;
  String gambar;
  Kategori kategori;
  double latitude;
  double longitude;
  DateTime createdAt;
  DateTime updatedAt;
  // --- for name & profile ---
  String namaPembuat;
  String profileImagePembuat;
  // --- for status & tanggapan ---
  String? status;
  String? tanggapan;

  Pengaduan({
    required this.id,
    required this.judul,
    required this.alamat,
    required this.deskripsi,
    required this.gambar,
    required this.kategori,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    // --- for name & profile ---
    required this.namaPembuat,
    required this.profileImagePembuat,
    // --- for status & tanggapan ---
    required this.status,
    required this.tanggapan,
  });

// Mengonversi data JSON menjadi objek Pengaduan.
  factory Pengaduan.fromJson(Map<String, dynamic> json) {
    return Pengaduan(
      id: json['id'],
      judul: json['judul'],
      alamat: json['alamat'],
      gambar: json['gambar'],
      deskripsi: json['deskripsi'],
      kategori: Kategori.fromString(json['kategori']),
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      // --- for name & profile ---
      namaPembuat: json['namaPembuat'],
      profileImagePembuat: json['profileImagePembuat'],
      // --- for status & tanggapan ---
      status: json['status'],
      tanggapan: json['tanggapan'],
    );
  }

// Mendapatkan tampilan nama kategori dari enum Kategori.
  String get kategoriString => kategori.displayName;

// Mengonversi objek Pengaduan menjadi data JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'alamat': alamat,
      'gambar': gambar,
      'deskripsi': deskripsi,
      'kategori': Kategori.kategoriToString(kategori),
      'latitude': latitude,
      'longitude': longitude,
      // Format ISO 8601 -> format standar untuk representasi tanggal dan waktu
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      // --- for name & profile ---
      'namaPembuat': namaPembuat,
      'profileImagePembuat': profileImagePembuat,
      // --- for status & tanggapan ---
      'status': status,
      'tanggapan': tanggapan,
    };
  }

  String get dateMessage {
    if (createdAt == updatedAt) {
      return 'Dibuat Pada : $createdAtFormatted';
    } else {
      return 'Diperbarui Pada : $updatedAtFormatted';
    }
  }

  // Metode untuk mengonversi tanggal menjadi format yang sesuai
  String get createdAtFormatted {
    final DateFormat formatter = DateFormat('EEEE, d MMMM. HH:mm', 'id_ID');
    return formatter.format(createdAt);
  }

  String get updatedAtFormatted {
    final DateFormat formatter = DateFormat('EEEE, d MMMM. HH:mm', 'id_ID');
    return formatter.format(updatedAt);
  }
}
