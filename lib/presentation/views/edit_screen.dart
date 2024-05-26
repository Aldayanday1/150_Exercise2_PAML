import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kulinerjogja/presentation/controllers/kuliner_controller.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';
import 'package:kulinerjogja/presentation/views/home_page/home_screen.dart';
import 'package:kulinerjogja/presentation/views/map_screen.dart';
import 'package:kulinerjogja/presentation/views/map_static.dart';
import 'package:kulinerjogja/presentation/views/register_page/widgets/radio_button.dart';

class EditKuliner extends StatefulWidget {
  const EditKuliner({Key? key}) : super(key: key);

  @override
  State<EditKuliner> createState() => _EditKulinerState();
}

class _EditKulinerState extends State<EditKuliner> {
  File? _image;
  final _imagePicker = ImagePicker();
  String? _alamat;
  LatLng? _selectedLocation;

  // terkait dengan id kuliner dengan settingan default -> 0
  int _idKuliner = 0;

  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _deskripsi = TextEditingController();

  // ------------ IMAGE ---------------

  Future<void> getImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Kategori? selectedKategori;

  // ------------ VALIDATE TEXT ---------------

  String? _validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kolom ini tidak boleh kosong';
    }
    return null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeData();
  }

  @override
  void didUpdateWidget(EditKuliner oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeData();
  }

  void _initializeData() {
    var arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is Kuliner) {
      Kuliner kuliner = arguments;
      _idKuliner = kuliner.id;
      _nama.text = kuliner.nama;
      _deskripsi.text = kuliner.deskripsi;
      selectedKategori = kuliner.kategori;
      _image = File(kuliner.gambar);
      setState(() {
        _alamat = kuliner.alamat;
        _selectedLocation = LatLng(
            kuliner.latitude,
            kuliner
                .longitude); // Pastikan Kuliner memiliki latitude dan longitude
      });
    }
  }

  // void _updateLocation(LatLng newPosition) {
  //   setState(() {
  //     _selectedLocation = newPosition;
  //   });
  // }

  void _navigateToMapScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          onLocationSelected: (selectedLocation, selectedAddress) {
            // Update koordinat geografis dan alamat yang dipilih dari peta.
            setState(() {
              _selectedLocation = selectedLocation;
              _alamat = selectedAddress;
            });
            // Pop navigator untuk kembali ke halaman edit.
            Navigator.pop(context);
          },
          currentLocation: _selectedLocation,
          currentAddress: _alamat,
        ),
      ),
    );

    // Setelah kembali dari layar penuh, perbarui lokasi yang terpilih.
    // setState(() {
    //   _selectedLocation = selectedLocation;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 61, 61, 61),
      appBar: AppBar(
        title: Text("Edit Screen"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25),
        child: Card(
          color: Color.fromARGB(255, 255, 252, 244),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(25),
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
                  // ----------- RADIO BUTTON ----------------
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
                  GestureDetector(
                    onTap: _navigateToMapScreen,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Color.fromARGB(255, 243, 243, 243),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          height: 200,
                          child: _selectedLocation != null
                              ? StaticMap(
                                  location: _selectedLocation!,
                                )
                              : Center(
                                  child:
                                      CircularProgressIndicator()), // loading indicator while waiting for the location to be resolved
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Teks untuk menampilkan alamat yang diperbarui
                  if (_alamat != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Alamat diperbarui: $_alamat',
                        style: TextStyle(
                          color: Color.fromARGB(255, 74, 177, 77),
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
                    height: 150,
                    child: _image == null
                        ? Text(
                            "Tidak ada gambar yang dipilih!",
                            style: TextStyle(
                              color: Color.fromARGB(255, 192, 95, 95),
                            ),
                          )
                        : Container(
                            width: 300,
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
                                    )
                                  : Image.file(
                                      _image!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: getImage,
                        child: Text("Pilih Gambar"),
                      ),
                      SizedBox(width: 25),
                      ElevatedButton(
                        onPressed: () async {
                          if (_alamat == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Alamat harus dipilih')),
                            );
                          } else if (_formKey.currentState?.validate() ==
                              true) {
                            var kuliner = Kuliner(
                              id: _idKuliner,
                              nama: _nama.text,
                              deskripsi: _deskripsi.text,
                              alamat: _alamat!,
                              latitude: _selectedLocation?.latitude ?? 0.0,
                              longitude: _selectedLocation?.longitude ?? 0.0,
                              gambar: '',
                              kategori: selectedKategori!,
                            );
                            var result =
                                await KulinerController().updateKuliner(
                              kuliner,
                              _image,
                            );
                            if (result['success']) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeView(),
                                ),
                              );
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result['message'])),
                            );
                          }
                        },
                        child: const Text("Simpan"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
