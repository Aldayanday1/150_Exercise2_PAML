import 'package:flutter/material.dart';
import 'package:sistem_pengaduan/data/services/pengaduan_service.dart';
import 'package:sistem_pengaduan/presentation/views/search_page/search_screen.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman pencarian saat widget diklik
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(
              pengaduanService: PengaduanService(),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 20, right: 20),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 240, 240, 240),
            border: Border.all(color: Color.fromARGB(255, 255, 255, 255)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
              ),
              SizedBox(width: 8),
              Text('Cari...'),
            ],
          ),
        ),
      ),
    );
  }
}
