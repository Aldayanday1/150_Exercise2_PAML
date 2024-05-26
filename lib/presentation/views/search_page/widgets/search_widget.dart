import 'package:flutter/material.dart';
import 'package:kulinerjogja/data/services/kuliner_service.dart';
import 'package:kulinerjogja/presentation/views/search_page/search_screen.dart';

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman pencarian saat widget diklik
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(
              kulinerService: KulinerService(),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
