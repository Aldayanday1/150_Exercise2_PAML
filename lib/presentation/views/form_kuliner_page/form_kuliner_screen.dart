import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kulinerjogja/presentation/controllers/kuliner_controller.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';
import 'package:kulinerjogja/presentation/views/home_page/home_screen.dart';
import 'package:kulinerjogja/presentation/views/map_page/map_screen.dart';
import 'package:kulinerjogja/presentation/views/form_kuliner_page/widgets/radio_button.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/login_user_page/login_page.dart';
import 'package:kulinerjogja/presentation/views/map_page/map_static_form.dart';

class FormKuliner extends StatefulWidget {
  const FormKuliner({Key? key}) : super(key: key);

  @override
  State<FormKuliner> createState() => _FormKulinerState();
}

class _FormKulinerState extends State<FormKuliner> {
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

  // ----------- VALIDATE TEXT -------------

  String? _validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kolom ini tidak boleh kosong';
    }
    return null;
  }

  // ----------- NAV TO MAPSCREEN -------------

  String? _alamat;
  LatLng? _selectedLocation;

  void _navigateToMapScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          onLocationSelected: (selectedLocation, selectedAddress) {
            setState(() {
              _selectedLocation = selectedLocation;
              _alamat = selectedAddress;
            });
          },
          currentLocation: _selectedLocation,
          currentAddress: _alamat,
        ),
      ),
    );
  }

  // ----------- ADD KULINER -------------

  final _formKey = GlobalKey<FormState>();

  final int _idKuliner = 0;
  final _nama = TextEditingController();
  final _deskripsi = TextEditingController();
  Kategori? selectedKategori;

  Future<void> _addKuliner() async {
    List<String> missingData = [];

    if (_nama.text.isEmpty &&
        _deskripsi.text.isEmpty &&
        _alamat == null &&
        selectedKategori == null &&
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada data yang diisi'),
        ),
      );
    } else {
      if (_nama.text.isEmpty) {
        missingData.add('Nama');
      }
      if (_deskripsi.text.isEmpty) {
        missingData.add('Deskripsi');
      }
      if (_alamat == null) {
        missingData.add('Alamat');
      }
      if (selectedKategori == null) {
        missingData.add('Kategori');
      }
      if (_image == null) {
        missingData.add('Gambar');
      }

      if (missingData.isNotEmpty) {
        String missingDataMessage = 'Harap isi data ';
        missingDataMessage += missingData.join(', ');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(missingDataMessage)),
        );
      } else {
        DateTime now = DateTime.now();
        var result = await KulinerController().addKuliner(
          Kuliner(
            id: _idKuliner,
            nama: _nama.text,
            alamat: _alamat!,
            gambar: _image?.path ?? '',
            deskripsi: _deskripsi.text,
            kategori: selectedKategori!,
            latitude: _selectedLocation?.latitude ?? 0.0,
            longitude: _selectedLocation?.longitude ?? 0.0,
            createdAt: now,
            updatedAt: now,
            namaPembuat: '',
            profileImagePembuat: '',
            status: '',
            tanggapan: '',
          ),
          _image,
        );

        if (result['success']) {
          _nama.clear();
          _deskripsi.clear();
          setState(() {
            _image = null;
            _alamat = null;
            selectedKategori = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeView(),
            ),
          );

          // -------BREAK SESSION-------
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          title: Text("Form Kuliner", style: GoogleFonts.openSans()),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding:
              const EdgeInsets.only(left: 50, right: 50, top: 50, bottom: 50),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 16),
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
                      width: 220, // Lebar garis horizontal di samping teks
                      color: Colors.grey[400], // Warna garis horizontal
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // ----------- TEXTFIELD NAMA ----------------

              Material(
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Nama",
                      labelStyle: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.blueGrey[700],
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      hintText: "Masukkan Nama",
                      hintStyle: TextStyle(fontSize: 13),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7), // Efek kaca
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        // borderSide: BorderSide.none,
                      ),
                    ),
                    controller: _nama,
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      hintText: "Masukkan Deskripsi",
                      hintStyle: TextStyle(fontSize: 13),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7), // Efek kaca
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
                padding: const EdgeInsets.only(left: 20.0, bottom: 16, top: 40),
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
                      width: 210, // Lebar garis horizontal di samping teks
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
                padding: const EdgeInsets.only(left: 20.0, bottom: 16, top: 40),
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
                      width: 220, // Lebar garis horizontal di samping teks
                      color: Colors.grey[400], // Warna garis horizontal
                    ),
                  ],
                ),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (_alamat != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: _navigateToMapScreen,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Color.fromARGB(255, 243, 243, 243),
                            child: Container(
                              height: 200,
                              child:
                                  StaticMapForm(location: _selectedLocation!),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25.0, bottom: 25, left: 15),
                          child: Text(
                            "Alamat: $_alamat",
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 13,
                              color: Color.fromARGB(255, 87, 87, 87),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(1),
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: _navigateToMapScreen,
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white.withOpacity(
                                  0.7), // Transparansi pada warna latar belakang
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.map, color: Colors.blueGrey[700]),
                                  SizedBox(width: 8),
                                  Text(
                                    "Select Address",
                                    style: TextStyle(
                                      fontSize: 13,
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

                // ----------- GAMBAR ----------------

                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, bottom: 16, top: 40),
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
                        width: 220, // Lebar garis horizontal di samping teks
                        color: Colors.grey[400], // Warna garis horizontal
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                if (_image != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Container(
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 16),
                Row(
                  children: [
                    // ----------- BUTTON TAKE IMAGE -----------

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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image,
                                      size: 20), // Icon untuk "Select Image"
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt,
                                      size: 20), // Icon untuk "Take Photo"
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

                // ----------- BUTTON SAVE DATA -----------

                Row(
                  children: [
                    Expanded(
                      child: Material(
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(1),
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: _addKuliner,
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white.withOpacity(
                                  0.7), // Transparansi pada warna latar belakang
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
            ]),
          ),
          // floatingActionButton: FloatingButton(),
        )));
  }
}
