import 'package:intl/intl.dart';

// Enumeration untuk merepresentasikan berbagai kategori kuliner.
// Setiap kategori memiliki metode untuk mendapatkan tampilan nama kategorinya.
// Terdapat juga metode untuk mengonversi string kategori menjadi enum dan sebaliknya.
// SERIALISASI DATA
enum Kategori {
  // ignore: constant_identifier_names
  MAKANAN,
  // ignore: constant_identifier_names
  MINUMAN,
  // ignore: constant_identifier_names
  KUE,
  // ignore: constant_identifier_names
  DESSERT,
  // ignore: constant_identifier_names
  SNACK,
  // ignore: constant_identifier_names
  BREAD,
  // ignore: constant_identifier_names
  TEA,
  // ignore: constant_identifier_names
  COFFEE,
  // ignore: constant_identifier_names
  MILK,
  // ignore: constant_identifier_names
  JUICE;

  // Mendapatkan tampilan nama kategori.
  String get displayName {
    switch (this) {
      case Kategori.MAKANAN:
        return 'Makanan';
      case Kategori.MINUMAN:
        return 'Minuman';
      case Kategori.KUE:
        return 'Transportasi';
      case Kategori.DESSERT:
        return 'Dessert';
      case Kategori.SNACK:
        return 'Snack';
      case Kategori.BREAD:
        return 'Bread';
      case Kategori.TEA:
        return 'Tea';
      case Kategori.COFFEE:
        return 'Coffee';
      case Kategori.MILK:
        return 'Milk';
      case Kategori.JUICE:
        return 'Juice';
      default:
        throw Exception('Unknown category: $this');
    }
  }

// Mengonversi string kategori menjadi enum Kategori.
  static Kategori fromString(String kategori) {
    switch (kategori) {
      case 'MAKANAN':
        return Kategori.MAKANAN;
      case 'MINUMAN':
        return Kategori.MINUMAN;
      case 'KUE':
        return Kategori.KUE;
      case 'DESSERT':
        return Kategori.DESSERT;
      case 'SNACK':
        return Kategori.SNACK;
      case 'BREAD':
        return Kategori.BREAD;
      case 'TEA':
        return Kategori.TEA;
      case 'COFFEE':
        return Kategori.COFFEE;
      case 'MILK':
        return Kategori.MILK;
      case 'JUICE':
        return Kategori.JUICE;
      default:
        throw Exception('Unknown category: $kategori');
    }
  }

// Mengonversi enum Kategori menjadi string kategori.
  static String kategoriToString(Kategori kategori) {
    switch (kategori) {
      case Kategori.MAKANAN:
        return 'MAKANAN';
      case Kategori.MINUMAN:
        return 'MINUMAN';
      case Kategori.KUE:
        return 'KUE';
      case Kategori.DESSERT:
        return 'DESSERT';
      case Kategori.SNACK:
        return 'SNACK';
      case Kategori.BREAD:
        return 'BREAD';
      case Kategori.TEA:
        return 'TEA';
      case Kategori.COFFEE:
        return 'COFFEE';
      case Kategori.MILK:
        return 'MILK';
      case Kategori.JUICE:
        return 'JUICE';
      default:
        throw Exception('Unknown category: $kategori');
    }
  }
}

// Kelas model untuk merepresentasikan data kuliner.
class Kuliner {
  int id;
  String nama;
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

  Kuliner({
    required this.id,
    required this.nama,
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

// Mengonversi data JSON menjadi objek Kuliner.
  factory Kuliner.fromJson(Map<String, dynamic> json) {
    return Kuliner(
      id: json['id'],
      nama: json['nama'],
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

// Mengonversi objek Kuliner menjadi data JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
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
