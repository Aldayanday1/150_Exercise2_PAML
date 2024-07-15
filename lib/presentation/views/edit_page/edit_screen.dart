import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sistem_pengaduan/domain/model/pengaduan.dart';
import 'package:sistem_pengaduan/presentation/controllers/pengaduan_controller.dart';
import 'package:sistem_pengaduan/presentation/views/auth_pages/login_user_page/login_page.dart';
import 'package:sistem_pengaduan/presentation/views/detail_page/detail_screen.dart';
import 'package:sistem_pengaduan/presentation/views/form_pengaduan_page/widgets/radio_button.dart';
import 'package:sistem_pengaduan/presentation/views/home_page/home_screen.dart';
import 'package:sistem_pengaduan/presentation/views/map_page/map_static_edit.dart';

class EditPengaduan extends StatefulWidget {
  final Pengaduan pengaduan;
  const EditPengaduan({Key? key, required this.pengaduan}) : super(key: key);

  @override
  State<EditPengaduan> createState() => _EditPengaduanState();
}

class _EditPengaduanState extends State<EditPengaduan> {
  // -------- IMAGE PICKER --------
  File? _image;
  final _imagePicker = ImagePicker();

  // ----------- GET IMAGE -------------

  Future<void> getImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

// ----------- GET PHOTO -------------

  Future<void> takePhoto() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  // ------------ VALIDATE TEXT ---------------

  String? _validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kolom ini tidak boleh kosong';
    }
    return null;
  }

  // ------------ INITIALIZE DATA ---------------

  final _formKey = GlobalKey<FormState>();

  // terkait dengan id pengaduan dengan settingan default -> 0
  int _idPengaduan = 0;
  final _judul = TextEditingController();
  final _deskripsi = TextEditingController();
  Kategori? selectedKategori;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeData();
  }

  @override
  void didUpdateWidget(EditPengaduan oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeData();
  }

  void _initializeData() {
    var arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is Pengaduan) {
      Pengaduan pengaduan = arguments;
      _idPengaduan = pengaduan.id;
      _judul.text = pengaduan.judul;
      _deskripsi.text = pengaduan.deskripsi;
      selectedKategori = pengaduan.kategori;
      _image = File(pengaduan.gambar);
      setState(() {
        _alamat = pengaduan.alamat;
        _selectedLocation = LatLng(pengaduan.latitude, pengaduan.longitude);
      });
    }
  }

  //--------- CHANGES LOCATION MAPS ---------

  String? _alamat;
  LatLng? _selectedLocation;

  void _onLocationChanged(LatLng location, String address) {
    setState(() {
      _selectedLocation = location;
      _alamat = address;
    });
  }

  //---------- UPDATE PENGADUAN ---------

  Future<void> _updatePengaduan() async {
    if (_formKey.currentState?.validate() == true) {
      DateTime now = DateTime.now();

      var pengaduan = Pengaduan(
        id: _idPengaduan,
        judul: _judul.text,
        deskripsi: _deskripsi.text,
        alamat: _alamat!,
        latitude: _selectedLocation?.latitude ?? 0.0,
        longitude: _selectedLocation?.longitude ?? 0.0,
        gambar: _image != null && _image!.path != widget.pengaduan.gambar
            ? _image!.path
            : '',
        kategori: selectedKategori!,
        createdAt: widget.pengaduan.createdAt,
        updatedAt: now,
        namaPembuat: '',
        profileImagePembuat: '',
        status: '',
        tanggapan: '',
      );

      var result = await PengaduanController().updatePengaduan(
        pengaduan,
        _image != null && _image!.path != widget.pengaduan.gambar ? _image : null,
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeView(),
          ),
        );

        // ------- BREAK SESSION -------
      } else if (result['message'] ==
          'Token tidak valid. Silakan login kembali.') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
            settings: RouteSettings(
              arguments: 'Session habis, silakan login kembali',
            ),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: 'unique_tag_2_${widget.pengaduan.id}',
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
                    bottom: 310,
                    child: Center(
                      child: Text(
                        "Edit Screen",
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
                              MaterialPageRoute(
                                builder: (context) => DetailView(
                                  pengaduan: widget.pengaduan,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, bottom: 16),
                      child: Row(
                        children: [
                          Text(
                            "Form",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueGrey[700],
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            height: 1,
                            width:
                                220, // Lebar garis horizontal di samping teks
                            color: Colors.grey[400], // Warna garis horizontal
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // ----------- TEXTFIELD JUDUL ----------------

                    Material(
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Judul",
                            labelStyle: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueGrey[700],
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            hintText: "Masukkan Judul",
                            hintStyle: TextStyle(fontSize: 13),
                            filled: true,
                            fillColor:
                                Colors.white.withOpacity(0.7), // Efek kaca
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              // borderSide: BorderSide.none,
                            ),
                          ),
                          controller: _judul,
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: Color.fromARGB(255, 66, 66, 66),
                            fontWeight: FontWeight.normal,
                          ),
                          validator: _validateText,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // ----------- TEXTFIELD DESKRIPSI ----------------

                    Material(
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Deskripsi",
                            labelStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueGrey[700],
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            hintText: "Masukkan Deskripsi",
                            hintStyle: TextStyle(fontSize: 13),
                            filled: true,
                            fillColor:
                                Colors.white.withOpacity(0.7), // Efek kaca
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              // borderSide: BorderSide.none,
                            ),
                          ),
                          controller: _deskripsi,
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: Color.fromARGB(255, 66, 66, 66),
                            fontWeight: FontWeight.normal,
                          ),
                          validator: _validateText,
                          maxLines:
                              null, // Membuat TextFormField mendukung multiple lines
                          minLines: 1, // Minimum number of lines
                        ),
                      ),
                    ),

                    // ----------- CATEGORY / RADIO BUTTON ----------------

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, bottom: 16, top: 40),
                      child: Row(
                        children: [
                          Text(
                            "Kategori",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueGrey[700],
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            height: 1,
                            width:
                                220, // Lebar garis horizontal di samping teks
                            color: Colors.grey[400], // Warna garis horizontal
                          ),
                        ],
                      ),
                    ),
                    RadioButton(
                      selectedKategori: selectedKategori,
                      onKategoriSelected: (Kategori? value) {
                        setState(() {
                          selectedKategori = value;
                        });
                      },
                    ),

                    // ----------- MAPS ----------------

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, bottom: 16, top: 40),
                      child: Row(
                        children: [
                          Text(
                            "Alamat",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueGrey[700],
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            height: 1,
                            width:
                                220, // Lebar garis horizontal di samping teks
                            color: Colors.grey[400], // Warna garis horizontal
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Color.fromARGB(255, 243, 243, 243),
                        child: Container(
                          height: 200,
                          child: _selectedLocation != null
                              ? StaticMapEdit(
                                  location: _selectedLocation!,
                                  onLocationChanged: _onLocationChanged,
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    if (_alamat != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 15),
                        child: Text(
                          "Alamat Diperbarui : $_alamat",
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 13,
                            color: Color.fromARGB(255, 87, 87, 87),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),

                    // ----------- GAMBAR ----------------

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, bottom: 18, top: 40),
                      child: Row(
                        children: [
                          Text(
                            "Gambar",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueGrey[700],
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            height: 1,
                            width:
                                220, // Lebar garis horizontal di samping teks
                            color: Colors.grey[400], // Warna garis horizontal
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 450,
                      child: _image == null
                          ? Text(
                              "Tidak ada gambar yang dipilih!",
                              style: TextStyle(
                                color: Color.fromARGB(255, 192, 95, 95),
                              ),
                            )
                          : Container(
                              width: double
                                  .infinity, // Membuat gambar sesuai dengan lebar layar
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: _image!.path.startsWith('http')
                                    ? Image.network(
                                        _image!.path,
                                        fit: BoxFit.cover,
                                        height: 300, // Setel tinggi pada gambar
                                        width: double
                                            .infinity, // Lebar gambar sesuai layar
                                      )
                                    : Image.file(
                                        _image!,
                                        fit: BoxFit.cover,
                                        height: 300, // Setel tinggi pada gambar
                                        width: double
                                            .infinity, // Lebar gambar sesuai layar
                                      ),
                              ),
                            ),
                    ),
                    SizedBox(height: 16),

                    // ----------- BUTTON TAKE IMAGE -----------

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Material(
                                elevation: 5,
                                shadowColor: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(50),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: getImage,
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
                                          Icon(Icons.image,
                                              size:
                                                  20), // Icon untuk "Select Image"
                                          SizedBox(width: 8),
                                          Text(
                                            "Select Image",
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
                            SizedBox(width: 16),

                            // ----------- BUTTON TAKE PHOTOS -----------

                            Expanded(
                              child: Material(
                                elevation: 5,
                                shadowColor: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(50),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: takePhoto,
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
                                          Icon(Icons.camera_alt,
                                              size:
                                                  20), // Icon untuk "Take Photo"
                                          SizedBox(width: 8),
                                          Text(
                                            "Take Photo",
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
                        SizedBox(height: 26),

                        // ----------- BUTTON SAVE UPDATE -----------

                        Row(
                          children: [
                            Expanded(
                              child: Material(
                                elevation: 5,
                                shadowColor: Colors.black.withOpacity(1),
                                borderRadius: BorderRadius.circular(50),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: _updatePengaduan,
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
                        // Konten lainnya di sini
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
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
