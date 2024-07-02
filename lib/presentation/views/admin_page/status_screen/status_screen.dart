import 'package:flutter/material.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';
import 'package:kulinerjogja/presentation/controllers/kuliner_controller.dart';
import 'package:kulinerjogja/presentation/views/admin_page/card_kuliner.dart';

class KulinerStatusPage extends StatelessWidget {
  final String status;

  KulinerStatusPage({required this.status});

  final KulinerController _controller = KulinerController();

  Future<List<Kuliner>> _loadKulinerByStatus() {
    return _controller.getKulinerByStatus(status);
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
      body: FutureBuilder<List<Kuliner>>(
        future: _loadKulinerByStatus(),
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
                final kuliner = data[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildKulinerCardAdmin(context, kuliner),
                );
              },
            );
          }
        },
      ),
    );
  }
}
