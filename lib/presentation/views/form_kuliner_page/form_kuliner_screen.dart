import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kulinerjogja/presentation/controllers/kuliner_controller.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';
import 'package:kulinerjogja/presentation/views/home_page/home_screen.dart';
import 'package:kulinerjogja/presentation/views/map_page/map_screen.dart';
import 'package:kulinerjogja/presentation/views/map_page/map_static.dart';
import 'package:kulinerjogja/presentation/views/form_kuliner_page/widgets/radio_button.dart';

class FormKuliner extends StatefulWidget {
  const FormKuliner({Key? key}) : super(key: key);

  @override
  State<FormKuliner> createState() => _FormKulinerState();
}

class _FormKulinerState extends State<FormKuliner> {
  File? _image;
  final _imagePicker = ImagePicker();
  String? _alamat;
  LatLng? _selectedLocation;

  final int _idKuliner = 0;

  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _deskripsi = TextEditingController();

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

  Kategori? selectedKategori;

  String? _validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kolom ini tidak boleh kosong';
    }
    return null;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        title: Text("Form Kuliner", style: GoogleFonts.openSans()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 50, right: 50, top: 50, bottom: 110),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nama",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Masukkan Nama",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: _nama,
                  validator: _validateText,
                ),
                SizedBox(height: 16),
                Text(
                  "Deskripsi",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Masukkan Deskripsi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: _deskripsi,
                  validator: _validateText,
                ),
                SizedBox(height: 16),
                RadioButton(
                  selectedKategori: selectedKategori,
                  onKategoriSelected: (Kategori? value) {
                    setState(() {
                      selectedKategori = value;
                    });
                  },
                ),
                Text(
                  "Alamat",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Color.fromARGB(255, 243, 243, 243),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _alamat == null
                            ? Text(
                                'Alamat kosong !',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 192, 95, 95),
                                ),
                              )
                            : Text(_alamat!),
                        SizedBox(height: 8),
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
                              child: Stack(
                                children: [
                                  _selectedLocation != null
                                      ? StaticMap(location: _selectedLocation!)
                                      : Center(
                                          child:
                                              Text("Tap untuk pilih Alamat!")),
                                  GestureDetector(
                                    onTap: _navigateToMapScreen,
                                    behavior: HitTestBehavior.translucent,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Gambar",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  child: _image == null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25.0),
                          child: Text(
                            "Tidak ada gambar yang dipilih!",
                            style: TextStyle(
                              color: Color.fromARGB(255, 192, 95, 95),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Container(
                            width: 300,
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
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: getImage,
                      child: Text("Pilih Gambar"),
                    ),
                    ElevatedButton(
                      onPressed: takePhoto,
                      child: Text("Ambil Foto"),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async {
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
                                  longitude:
                                      _selectedLocation?.longitude ?? 0.0,
                                  createdAt: now,
                                  updatedAt: now,
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
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result['message'])),
                                );
                              }
                            }
                          }
                        },
                        child: const Text("Simpan"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingButton(),
    );
  }
}
