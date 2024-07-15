class StatusLaporan {
  final int id;
  final String statusSebelumnya;
  String statusBaru;
  String tanggapan;
  final DateTime changedAt;
  String gambar;

  StatusLaporan({
    required this.id,
    required this.statusSebelumnya,
    required this.statusBaru,
    required this.tanggapan,
    required this.changedAt,
    this.gambar = '',
  });

  factory StatusLaporan.fromJson(Map<String, dynamic> json) {
    return StatusLaporan(
      id: json['id'],
      statusSebelumnya: json['statusSebelumnya'],
      statusBaru: json['statusBaru'],
      tanggapan: json['tanggapan'],
      changedAt: DateTime.parse(json['changedAt']),
      gambar: json['gambar'] ?? '', // Mengambil gambar dari JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'statusSebelumnya': statusSebelumnya,
      'statusBaru': statusBaru,
      'tanggapan': tanggapan,
      'changedAt': changedAt.toIso8601String(),
      'gambar': gambar,
    };
  }
}
