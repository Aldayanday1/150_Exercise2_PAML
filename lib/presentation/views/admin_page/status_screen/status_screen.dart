import 'package:flutter/material.dart';
import 'package:sistem_pengaduan/domain/model/pengaduan.dart';
import 'package:sistem_pengaduan/presentation/controllers/pengaduan_controller.dart';
import 'package:sistem_pengaduan/presentation/views/admin_page/card_pengaduan.dart';

class PengaduanStatusPage extends StatelessWidget {
  final String status;

  PengaduanStatusPage({required this.status});

  final PengaduanController _controller = PengaduanController();

  Future<List<Pengaduan>> _loadPengaduanByStatus() {
    return _controller.getPengaduanByStatus(status);
  }

  String _formatStatus(String status) {
    switch (status.toUpperCase()) {
      case "PENDING":
        return "Pending";
      case "PROGRESS":
        return "Progress";
      case "DONE":
        return "Done";
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status ${_formatStatus(status)}'),
      ),
      body: FutureBuilder<List<Pengaduan>>(
        future: _loadPengaduanByStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data ?? [];
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final pengaduan = data[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildPengaduanCardAdmin(context, pengaduan),
                );
              },
            );
          }
        },
      ),
    );
  }
}
