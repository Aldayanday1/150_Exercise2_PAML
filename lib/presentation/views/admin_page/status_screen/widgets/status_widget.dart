import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistem_pengaduan/domain/model/pengaduan.dart';
import 'package:sistem_pengaduan/presentation/controllers/pengaduan_controller.dart';
import 'package:sistem_pengaduan/presentation/views/admin_page/status_screen/status_screen.dart';

class PengaduanStatusCard extends StatelessWidget {
  final String status;

  PengaduanStatusCard({required this.status});

  final PengaduanController _statusController = PengaduanController();

  Future<List<Pengaduan>> _loadPengaduanByStatus() {
    return _statusController.getPengaduanByStatus(status);
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case "PENDING":
        return Colors.orange;
      case "PROGRESS":
        return Colors.blue;
      case "DONE":
        return Colors.green;
      default:
        return Colors.grey;
    }
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
    final Color color = _getStatusColor(status);
    return FutureBuilder<List<Pengaduan>>(
      future: _loadPengaduanByStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          int itemCount = snapshot.data?.length ?? 0;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PengaduanStatusPage(status: status),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 255, 255, 255)
                        .withOpacity(0.6),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      color: color,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$itemCount',
                                style: GoogleFonts.roboto(
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                _formatStatus(status),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
