import 'package:flutter/material.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';
import 'package:kulinerjogja/presentation/views/detail_page/detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildKulinerCard(BuildContext context, Kuliner kuliner,
    {bool isNew = true}) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailView(kuliner: kuliner),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(8, 8), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  kuliner.gambar,
                  width: 85.0,
                  height: 85.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kuliner.nama,
                      style: GoogleFonts.roboto(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 66, 66, 66),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      kuliner.deskripsi,
                      style: GoogleFonts.roboto(
                        fontSize: 12.0,
                        color: Color.fromARGB(255, 66, 66, 66),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      kuliner.alamat,
                      style: GoogleFonts.roboto(
                        fontSize: 12.0,
                        color: Color.fromARGB(255, 66, 66, 66),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
