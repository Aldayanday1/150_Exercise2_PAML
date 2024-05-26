// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:kulinerjogja/presentation/controllers/kuliner_controller.dart';
// import 'package:kulinerjogja/domain/model/kuliner.dart';
// import 'package:kulinerjogja/presentation/views/home_page/home_screen.dart';
// import 'package:kulinerjogja/presentation/views/home_page/widgets/floating_button.dart';
// import 'package:kulinerjogja/presentation/views/map_screen.dart';
// import 'package:kulinerjogja/presentation/views/register_page/widgets/radio_button.dart';

// class FormKuliner extends StatefulWidget {
//   const FormKuliner({Key? key}) : super(key: key);

//   @override
//   State<FormKuliner> createState() => _FormKulinerState();
// }

// class _FormKulinerState extends State<FormKuliner> {
//   File? _image;
//   final _imagePicker = ImagePicker();
//   String? _alamat;

//   // terkait dengan id kuliner dengan settingan default -> 0
//   final int _idKuliner = 0;

//   final _formKey = GlobalKey<FormState>();
//   final _nama = TextEditingController();
//   final _deskripsi = TextEditingController();

//   // ------------ IMAGE ---------------

//   Future<void> getImage() async {
//     final XFile? pickedFile =
//         await _imagePicker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       }
//     });
//   }

//   Kategori? selectedKategori;

//   // ------------ VALIDATE TEXT ---------------

//   String? _validateText(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Kolom ini tidak boleh kosong';
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 61, 61, 61),
//       appBar: AppBar(
//         title: Text("Form Kuliner", style: GoogleFonts.openSans()),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(25),
//           child: Card(
//             color: Color.fromARGB(255, 255, 252, 244),
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(25), // Reduced padding here
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Nama",
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     TextFormField(
//                       decoration: InputDecoration(
//                         hintText: "Masukkan Nama",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       controller: _nama,
//                       validator: _validateText,
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       "Deskripsi",
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     TextFormField(
//                       maxLines: 1,
//                       decoration: InputDecoration(
//                         hintText: "Masukkan Deskripsi",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       controller: _deskripsi,
//                       validator: _validateText,
//                     ),
//                     SizedBox(height: 16),
//                     // ----------- RADIO BUTTON ----------------
//                     RadioButton(
//                       selectedKategori: selectedKategori,
//                       onKategoriSelected: (Kategori? value) {
//                         setState(() {
//                           selectedKategori = value;
//                         });
//                       },
//                     ),
//                     Text(
//                       "Alamat",
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Card(
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       color: Color.fromARGB(255, 243, 243, 243),
//                       child: Padding(
//                         padding:
//                             const EdgeInsets.all(12), // Reduced padding here
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _alamat == null
//                                 ? Text(
//                                     'Alamat kosong !',
//                                     style: TextStyle(
//                                       color: Color.fromARGB(255, 219, 0, 0),
//                                     ),
//                                   )
//                                 : Text(_alamat!),
//                             SizedBox(height: 8),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 TextButton(
//                                   onPressed: () async {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => MapScreen(
//                                           onLocationSelected:
//                                               (selectedAddress) {
//                                             setState(() {
//                                               _alamat = selectedAddress;
//                                             });
//                                           },
//                                           currentAddress: _alamat!,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   child: Text('Pilih Alamat'),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       "Gambar",
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Container(
//                       child: _image == null
//                           ? Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 25.0),
//                               child: Text(
//                                 "Tidak ada gambar yang dipilih!",
//                                 style: TextStyle(
//                                   color: Color.fromARGB(255, 192, 95, 95),
//                                 ),
//                               ),
//                             )
//                           : Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 15.0),
//                               child: Container(
//                                 width: 300,
//                                 child: Card(
//                                   elevation: 10,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   clipBehavior: Clip.antiAlias,
//                                   child: Image.file(
//                                     _image!,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                     ),
//                     SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ElevatedButton(
//                           onPressed: getImage,
//                           child: Text("Pilih Gambar"),
//                         ),
//                         SizedBox(width: 25),
//                         ElevatedButton(
//                           onPressed: () async {
//                             if (_alamat == null) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text('Alamat harus dipilih'),
//                                 ),
//                               );
//                             } else if (selectedKategori == null) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text('Kategori harus dipilih'),
//                                 ),
//                               );
//                             } else if (_formKey.currentState!.validate()) {
//                               var result = await KulinerController().addKuliner(
//                                 Kuliner(
//                                   id: _idKuliner,
//                                   nama: _nama.text,
//                                   alamat: _alamat!,
//                                   gambar: _image?.path ?? '',
//                                   deskripsi: _deskripsi.text,
//                                   kategori: selectedKategori!,
//                                 ),
//                                 _image,
//                               );

//                               if (result['success']) {
//                                 _nama.clear();
//                                 _deskripsi.clear();
//                                 setState(() {
//                                   _image = null;
//                                   _alamat = null;
//                                   selectedKategori = null;
//                                 });

//                                 // Tampilkan SnackBar sebelum melakukan navigasi
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text(result['message'])),
//                                 );

//                                 // Lakukan navigasi setelah SnackBar ditampilkan
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => HomeView(),
//                                   ),
//                                 );
//                               } else {
//                                 // Tampilkan pesan error jika terjadi kesalahan
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text(result['message'])),
//                                 );
//                               }
//                             }
//                           },
//                           child: const Text("Simpan"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingButton(),
//     );
//   }
// }
