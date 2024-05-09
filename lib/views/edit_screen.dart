import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kulinerjogja/controllers/kuliner_controller.dart';
import 'package:kulinerjogja/model/kuliner.dart';
import 'package:kulinerjogja/views/home_screen.dart';
import 'package:kulinerjogja/views/map_screen.dart';

class EditKuliner extends StatefulWidget {
  const EditKuliner({super.key});

  @override
  State<EditKuliner> createState() => _EditKulinerState();
}

class _EditKulinerState extends State<EditKuliner> {
  File? _image;
  final _imagePicker = ImagePicker();
  String? _alamat;
  int _idKuliner = 0;

  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _deskripsi = TextEditingController();

  Future<void> getImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  String? _validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kolom ini tidak boleh kosong';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 61, 61, 61),
      appBar: AppBar(
        title: Text("Edit Screen"),
      ),
      body: Column(
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
                            color: Color.fromARGB(255, 219, 0, 0),
                          ),
                        )
                      : Text(_alamat!),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          final selectedAddress = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(
                                currentAddress: _alamat,
                                onLocationSelected: (selectedAddress) {
                                  setState(() {
                                    _alamat = selectedAddress;
                                  });
                                },
                              ),
                            ),
                          );
                          if (selectedAddress != null) {
                            setState(() {
                              _alamat = selectedAddress;
                            });
                          }
                        },
                        child: _alamat == null
                            ? const Text('Pilih Alamat')
                            : const Text('Ubah Alamat'),
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
                                  SnackBar(
                                      content: Text('Alamat harus dipilih')),
                                );
                              } else if (_formKey.currentState!.validate()) {
                                if (_image != null) {
                                  var result =
                                      await KulinerController().updateKuliner(
                                    Kuliner(
                                      id: _idKuliner,
                                      nama: _nama.text,
                                      deskripsi: _deskripsi.text,
                                      alamat: _alamat!,
                                      gambar: '',
                                    ),
                                    _image,
                                  );
                                } else {
                                  var result =
                                      await KulinerController().updateKuliner(
                                    Kuliner(
                                      id: _idKuliner,
                                      nama: _nama.text,
                                      deskripsi: _deskripsi.text,
                                      alamat: _alamat!,
                                      gambar: '',
                                    ),
                                    null,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result['message'])),
                                  );
                                }
                              }
                            },
                            child: const Text("Simpan"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
