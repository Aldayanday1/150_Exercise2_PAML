import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistem_pengaduan/domain/model/pengaduan.dart';
import 'package:sistem_pengaduan/presentation/views/map_page/map_static_detail.dart';

class DetailView extends StatefulWidget {
  final Pengaduan pengaduan;
  final bool isNew;

  const DetailView({
    Key? key,
    required this.pengaduan,
    this.isNew = true,
  }) : super(key: key);

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  Widget build(BuildContext context) {
    // ----------- STATUS COLOR TEXT -----------

    Color statusColor;
    String statusText = widget.pengaduan.status ?? 'Pending';

    switch (statusText.toUpperCase()) {
      case 'PROGRESS':
        statusColor = Colors.blue;
        statusText = 'In Progress';
        break;
      case 'DONE':
        statusColor = Colors.green;
        statusText = 'Done';
        break;
      default:
        statusColor = Colors.orange;
        statusText = 'Pending';
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                // ----------- BACKGROUND IMAGE -----------
                Hero(
                  tag: 'unique_tag_1${widget.pengaduan.id}',
                  child: ClipPath(
                    clipper: BottomHalfCircleClipper(),
                    child: Container(
                      height: 500,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF6A1B9A),
                            Color(0xFF8E24AA),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Image.network(
                        widget.pengaduan.gambar,
                        height: 500,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.1),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 310, // Ubah jarak di sini
                  child: Center(
                    child: Text(
                      "Detail Screen",
                      style: GoogleFonts.roboto(
                        fontSize: 20.0,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 75,
                  left: 30,
                  child: SizedBox(
                    width: 40, // Lebar `Container`
                    height: 40, // Tinggi `Container`
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.3), // Transparansi
                      ),
                      padding: EdgeInsets.only(left: 5), // Menghapus padding
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        iconSize: 16, // Mengurangi ukuran ikon
                        color: Color.fromARGB(255, 255, 255, 255),
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 50, bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ----------- TITLE -----------
                  Text(
                    widget.pengaduan.judul,
                    style: GoogleFonts.roboto(
                      fontSize: 25.0,
                      color: Color.fromARGB(255, 66, 66, 66),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),

                  // ----------- DESCRIPTION -----------

                  Padding(
                    padding: const EdgeInsets.only(bottom: 25, top: 20),
                    child: Row(
                      children: [
                        Text(
                          "Deskripsi",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                        SizedBox(width: 16),
                        Container(
                          height: 1,
                          width: 239, // Lebar garis horizontal di samping teks
                          color: Colors.grey[400], // Warna garis horizontal
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.pengaduan.deskripsi,
                    style: GoogleFonts.roboto(
                      fontSize: 14.0,
                      color: Color.fromARGB(255, 66, 66, 66),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Text(
                  //   'Kategori : ${widget.pengaduan.kategoriString}',
                  //   style: GoogleFonts.roboto(
                  //     fontSize: 14.0,
                  //     color: Color.fromARGB(255, 66, 66, 66),
                  //   ),
                  // ),
                  // SizedBox(height: 10),

                  // ----------- LOCATION TEXT -----------

                  Row(
                    children: [
                      Image.asset(
                        'assets/location.png',
                        color: Color.fromARGB(255, 66, 66,
                            66), // Opsi: Tambahkan untuk menerapkan warna ke gambar
                        width:
                            16, // Opsi: Sesuaikan ukuran gambar sesuai kebutuhan
                        height: 16,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.5),
                          child: Text(
                            widget.pengaduan.alamat,
                            style: GoogleFonts.roboto(
                              fontSize: 14.0,
                              color: Color.fromARGB(255, 66, 66, 66),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ----------- PROFILE -----------

                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 1.0, top: 3),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          widget.pengaduan.profileImagePembuat,
                          width: 16,
                          height: 16,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Dibuat oleh : ${widget.pengaduan.namaPembuat}',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Color.fromARGB(255, 66, 66, 66),
                        ),
                      ),
                    ]),
                  ),

                  // ----------- DATE MESSAGE -----------

                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0, top: 18),
                    child: Text(
                      widget.pengaduan.dateMessage,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Color.fromARGB(255, 66, 66, 66),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ----------- MAPS -----------

            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 0),
              child: GestureDetector(
                onVerticalDragUpdate: (ltlng) {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      height: 220,
                      child: StaticMap(
                        location: LatLng(widget.pengaduan.latitude,
                            widget.pengaduan.longitude),
                        // onLocationChanged: (ltlng, strng) {},
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ----------- STATUS TEXT -----------

            Padding(
              padding: const EdgeInsets.only(left: 53.0, bottom: 15, top: 25),
              child: Row(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Status : $statusText",
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: Color.fromARGB(255, 66, 66, 66),
                      ),
                    ),
                  ],
                ),
              ]),
            ),

            // ----------- TANGGAPAN ADMIN -----------

            Padding(
              padding: EdgeInsets.only(left: 40, top: 0, right: 40, bottom: 50),
              child: Column(
                children: [
                  if (widget.pengaduan.tanggapan != null)
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/profile.png',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(
                                              25), // Adjust the curve radius here
                                          bottomLeft: Radius.circular(
                                              25), // Adjust the curve radius here
                                          bottomRight: Radius.circular(
                                              25), // Adjust the curve radius here
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 9,
                                            offset: Offset(5, 5),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Petugas",
                                              style: GoogleFonts.roboto(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 66, 66, 66),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              widget.pengaduan.tanggapan!,
                                              style: GoogleFonts.roboto(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 66, 66, 66),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            // Row(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.start,
                                            //   children: [
                                            //     Container(
                                            //       width: 9,
                                            //       height: 9,
                                            //       decoration: BoxDecoration(
                                            //         shape: BoxShape.circle,
                                            //         color: statusColor,
                                            //       ),
                                            //     ),
                                            //     SizedBox(width: 8),
                                            //     Text(
                                            //       statusText,
                                            //       style: GoogleFonts.roboto(
                                            //         fontSize: 13,
                                            //         color: Color.fromARGB(
                                            //             255, 66, 66, 66),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BottomHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height); // Ubah jarak di sini
    path.arcToPoint(
      Offset(size.width, size.height), // Ubah jarak di sini
      radius: Radius.circular(size.width * 2),
      clockwise: true,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
