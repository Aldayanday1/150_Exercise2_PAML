// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sistem_pengaduan/data/services/user_service.dart';
import 'package:sistem_pengaduan/domain/model/pengaduan.dart';
import 'package:sistem_pengaduan/domain/model/status_laporan.dart';
import 'package:sistem_pengaduan/presentation/views/auth_pages/login_admin_page/login_page.dart';
import 'package:sistem_pengaduan/presentation/views/map_page/map_static_detail.dart';

class EditPengaduanAdmin extends StatefulWidget {
  final Pengaduan pengaduan;

  const EditPengaduanAdmin({
    Key? key,
    required this.pengaduan,
  }) : super(key: key);

  @override
  State<EditPengaduanAdmin> createState() => _EditPengaudanViewState();
}

class _EditPengaudanViewState extends State<EditPengaduanAdmin> {
  late StatusLaporan _statusLaporan;

  final _statusController = TextEditingController();
  final _tanggapanController = TextEditingController();

  final ApiService _service = ApiService();

  bool showMap =
      false; // State untuk menentukan apakah kartu peta harus ditampilkan

  // ------------ INITIALIZE DATA ---------------

  @override
  void initState() {
    super.initState();
    // Mendeklarasikan _statusLaporan dengan atau tanpa gambar
    _statusLaporan = StatusLaporan(
      id: widget.pengaduan.id,
      statusSebelumnya: widget.pengaduan.status ?? 'Pending',
      statusBaru: widget.pengaduan.status ?? 'Pending',
      tanggapan: widget.pengaduan.tanggapan ?? '',
      changedAt: DateTime.now(),
    );

    // Menginisialisasi nilai controller
    _statusController.text = _statusLaporan.statusBaru;
    _tanggapanController.text = _statusLaporan.tanggapan;
  }

  //---------- UPDATE STATUS ADUAN ---------

  void _updateStatusLaporan() async {
    try {
      String newStatus = _statusController.text;
      String newResponse = _tanggapanController.text;

      if (_statusLaporan.statusBaru == newStatus &&
          _statusLaporan.tanggapan == newResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak ada perubahan untuk disimpan.')),
        );
        return;
      }

      _statusLaporan.statusBaru = newStatus;
      _statusLaporan.tanggapan = newResponse;

      print(
          'Mengirim permintaan update status laporan: ${_statusLaporan.toJson()}');

      // Panggil method untuk update status laporan
      await _service.updateStatusLaporan(_statusLaporan.id, _statusLaporan);

      // Tampilkan snackbar jika sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status laporan berhasil diperbarui')),
      );

      // Update state untuk menampilkan perubahan status di UI
      setState(() {
        widget.pengaduan.status = _statusLaporan.statusBaru;
        widget.pengaduan.tanggapan = _statusLaporan.tanggapan;
        widget.pengaduan.gambar =
            _statusLaporan.gambar; // update gambar di widget pengaduan
      });
    } catch (e) {
      if (e.toString().contains('Token tidak valid')) {
        // ------- BREAK SESSION EDIT STATUS -------
        // Token tidak valid, arahkan pengguna ke halaman login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => AdminLoginPage(),
            settings: RouteSettings(
              arguments: 'Session habis, silakan login kembali',
            ),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

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
                ClipPath(
                  clipper: BottomHalfCircleClipper(),
                  child: Container(
                    height: 450,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(82, 250, 250, 250),
                          Color.fromARGB(132, 0, 7, 65),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 70),
                  child: Card(
                    elevation: 4, // Elevation untuk efek shadow
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Bulatan sudut card
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(10), // Bulatan sudut gambar
                      child: Container(
                        height: 390,
                        width: 300,
                        child: Stack(
                          children: [
                            // ----------- BACKGROUND IMAGE -----------
                            Center(
                              child: Hero(
                                tag: 'unique_tag_3_${widget.pengaduan.id}',
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
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.5, 1.0],
                                  ),
                                ),
                              ),
                            ),

                            // ----------- TITLE AND BACK BUTTON -----------
                            Positioned(
                              top: 23,
                              left: 23,
                              child: SizedBox(
                                width: 35,
                                height: 35,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                  child: IconButton(
                                    icon: Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Icon(Icons.arrow_back_ios),
                                    ),
                                    iconSize: 16,
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              left: 15,
                              bottom: 310,
                              child: Center(
                                child: Text(
                                  "Edit Pengaduan",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 15, bottom: 25),
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
                          width: 225, // Lebar garis horizontal di samping teks
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
                  Row(
                    children: [
                      Image.asset(
                        'assets/category.png',
                        color: Color.fromARGB(255, 66, 66,
                            66), // Opsi: Tambahkan untuk menerapkan warna ke gambar
                        width:
                            16, // Opsi: Sesuaikan ukuran gambar sesuai kebutuhan
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.5),
                        child: Text(
                          'Kategori : ${widget.pengaduan.kategoriString}',
                          style: GoogleFonts.roboto(
                            fontSize: 14.0,
                            color: Color.fromARGB(255, 66, 66, 66),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

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
                onTap: () {
                  setState(() {
                    showMap =
                        !showMap; // Toggle nilai showMap saat teks ditekan
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50, // Tinggi teks "Click to see Maps"
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            color: Colors.white.withOpacity(
                                0.9), // Warna latar belakang dengan opasitas 90%
                          ),
                          child: Text(
                            'Click to See Maps',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          height: showMap
                              ? 220
                              : 0, // Mengatur tinggi kartu peta berdasarkan showMap
                          child: Visibility(
                            visible: showMap,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withOpacity(
                                    0.9), // Warna latar belakang dengan opasitas 90%
                              ),
                              child: StaticMap(
                                location: LatLng(
                                  widget.pengaduan.latitude,
                                  widget.pengaduan.longitude,
                                ),
                                // onLocationChanged: (ltlng, strng) {},
                              ),
                            ),
                          ),
                        ),
                      ],
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

                  // ----------- UPDATE FORM -----------

                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 50),
                    child: Row(
                      children: [
                        Text(
                          "Edit Status & Tanggapan",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                        SizedBox(width: 16),
                        Container(
                          height: 1,
                          width: 150, // Lebar garis horizontal di samping teks
                          color: Colors.grey[400], // Warna garis horizontal
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Text(
                            'Ubah Status',
                            style: GoogleFonts.roboto(
                              fontSize:
                                  11.0, // Ukuran font yang sedikit lebih besar
                              color: Colors.grey[700], // Warna garis horizontal
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(0.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(
                                      0, 3), // shadow direction: bottom right
                                ),
                              ],
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _statusController.text,
                              items:
                                  ['PENDING', 'PROGRESS', 'DONE'].map((status) {
                                Color statusColor;
                                switch (status) {
                                  case 'PENDING':
                                    statusColor = Colors.orange;
                                    break;
                                  case 'PROGRESS':
                                    statusColor = Colors.blue;
                                    break;
                                  case 'DONE':
                                    statusColor = Colors.green;
                                    break;
                                  default:
                                    statusColor = Colors.black;
                                }

                                return DropdownMenuItem(
                                  value: status,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: statusColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        status.substring(0, 1) +
                                            status.substring(1).toLowerCase(),
                                        style: TextStyle(
                                            color: statusColor, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _statusController.text = value!;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      50), // Menyesuaikan radius agar lebih bulat
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(0, 255, 255, 255),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 12.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Material(
                          elevation: 5,
                          shadowColor: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Tanggapan",
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blueGrey[700],
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 50),
                                hintText: "Masukkan Tanggapan",
                                hintStyle: TextStyle(fontSize: 13),
                                filled: true,
                                fillColor:
                                    Colors.white.withOpacity(0.7), // Efek kaca
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              controller: _tanggapanController,
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                color: Color.fromARGB(255, 66, 66, 66),
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines:
                                  null, // Membuat TextFormField mendukung multiple lines
                              minLines: 1, // Minimum number of lines
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: Material(
                                elevation: 5,
                                shadowColor: Colors.black.withOpacity(1),
                                borderRadius: BorderRadius.circular(50),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: _updateStatusLaporan,
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white.withOpacity(
                                          0.7), // Transparansi pada warna latar belakang
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Save",
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.blueGrey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
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
    path.lineTo(0, size.height * 0.75); // Ubah jarak sesuai keinginan
    path.arcToPoint(
      Offset(size.width, size.height * 0.75),
      radius: Radius.circular(size.width),
      clockwise: false,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
