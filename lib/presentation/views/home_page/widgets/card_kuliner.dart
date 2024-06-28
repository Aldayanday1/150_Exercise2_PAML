import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';
import 'package:kulinerjogja/presentation/views/detail_page/detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildKulinerCard(BuildContext context, Kuliner kuliner) {
  // ----------- STATUS COLOR TEXT -----------

  Color statusColor;
  String statusText = kuliner.status ?? 'PENDING';

  switch (statusText.toUpperCase()) {
    case 'PROGRESS':
      statusColor = Colors.yellow;
      break;
    case 'DONE':
      statusColor = Colors.green;
      break;
    default:
      statusColor = Colors.red;
      statusText = 'PENDING';
  }

  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailView(
            kuliner: kuliner,
          ),
        ),
      );
    },
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
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    kuliner.gambar,
                    width: 85.0,
                    height: 110.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ------------- NAMA -------------

                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Text(
                          kuliner.nama,
                          style: GoogleFonts.roboto(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 66, 66, 66),
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: 10),

                      // ------------- DESKRIPSI -------------

                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Text(
                          kuliner.deskripsi,
                          style: GoogleFonts.roboto(
                            fontSize: 12.0,
                            color: Color.fromARGB(255, 66, 66, 66),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: 14),

                      // ------------- LOCATION -------------

                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: const Color.fromARGB(255, 94, 94, 94),
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 30),
                              child: Text(
                                kuliner.alamat,
                                style: GoogleFonts.roboto(
                                  fontSize: 12.0,
                                  color: Color.fromARGB(255, 66, 66, 66),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //------------- CREATED BY -------------
                      SizedBox(height: 10),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                              kuliner.profileImagePembuat,
                              width: 16,
                              height: 16,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Dibuat oleh : ${kuliner.namaPembuat}',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Color.fromARGB(255, 66, 66, 66),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 8, // Lebar garis vertikal
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
