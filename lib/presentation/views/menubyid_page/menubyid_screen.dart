import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistem_pengaduan/domain/model/pengaduan.dart';
import 'package:sistem_pengaduan/presentation/controllers/pengaduan_controller.dart';
import 'package:sistem_pengaduan/presentation/views/admin_page/edit_pengaduan/edit_pengaduan_screen.dart';
import 'package:sistem_pengaduan/presentation/views/auth_pages/login_user_page/login_page.dart';
import 'package:sistem_pengaduan/presentation/views/detail_page/detail_screen.dart';
import 'package:sistem_pengaduan/presentation/views/edit_page/edit_screen.dart';
import 'package:sistem_pengaduan/presentation/views/home_page/home_screen.dart';

class MyPengaduanPage extends StatefulWidget {
  const MyPengaduanPage({super.key});

  @override
  _MyPengaduanPageState createState() => _MyPengaduanPageState();
}

class _MyPengaduanPageState extends State<MyPengaduanPage> {
  final PengaduanController _userController = PengaduanController();
  late Future<List<Pengaduan>> _pengaduanFuture;

  @override
  void initState() {
    super.initState();
    _pengaduanFuture = _userController.getMyPengaduan();
  }

  // ------------------- SNACKBAR SESSION BREAK -------------------

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Laporan'),
      ),
      body: FutureBuilder<List<Pengaduan>>(
        future: _pengaduanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // -------BREAK SESSION-------

            // Jika error karena token tidak valid, arahkan ke halaman login
            if (snapshot.error.toString().contains('Token tidak valid')) {
              Future.microtask(
                () {
                  _showSnackBar('Session habis, silakan login kembali');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                },
              );
              return SizedBox.shrink(); // Mengembalikan widget kosong sementara
            }
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada pengaduan'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Pengaduan pengaduan = snapshot.data![index];
                return buildPengaduanCard(context, pengaduan);
              },
            );
          }
        },
      ),
    );
  }

  Widget buildPengaduanCard(BuildContext context, Pengaduan pengaduan) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailView(
              pengaduan: pengaduan,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      pengaduan.gambar,
                      width: 85.0,
                      height: 85.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pengaduan.judul,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          pengaduan.deskripsi,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black54,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16.0,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                pengaduan.alamat,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 31,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.8),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPengaduan(
                                pengaduan: pengaduan,
                              ),
                              settings: RouteSettings(arguments: pengaduan),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 17,
                        ),
                        label: Text(
                          "Edit",
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 1),
                  Expanded(
                    child: Container(
                      height: 31,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Konfirmasi"),
                                content: Text(
                                    "Anda yakin ingin menghapus data ini?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(false); // Return false
                                    },
                                    child: Text('Tidak'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      var result = await PengaduanController()
                                          .deletePengaduan(pengaduan.id);
                                      Navigator.of(context)
                                          .pop(); // Close the dialog

                                      if (result['success']) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomeView()),
                                        );
                                      }
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(result['message']),
                                        ),
                                      );
                                    },
                                    child: Text("Ya"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 17,
                        ),
                        label: Text(
                          "Delete",
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
