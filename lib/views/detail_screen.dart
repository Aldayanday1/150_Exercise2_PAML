import 'package:flutter/material.dart';
import 'package:kulinerjogja/controllers/kuliner_controller.dart';
import 'package:kulinerjogja/model/kuliner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kulinerjogja/views/edit_screen.dart';
import 'package:kulinerjogja/views/home_screen.dart';

class DetailView extends StatefulWidget {
  final Kuliner kuliner;

  const DetailView({super.key, required this.kuliner});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  final KulinerController _controller = KulinerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 61, 61, 61),
      appBar: AppBar(
        title: Text("Detail Kuliner"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'image${widget.kuliner.id}',
              child: Image.network(
                widget.kuliner.gambar,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                color: Color.fromARGB(255, 255, 252, 244),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.kuliner.nama,
                        style: GoogleFonts.roboto(
                          fontSize: 45.0,
                          color: Color.fromARGB(255, 66, 66, 66),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        widget.kuliner.alamat,
                        style: GoogleFonts.roboto(
                          fontSize: 14.0,
                          color: Color.fromARGB(255, 66, 66, 66),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.kuliner.deskripsi,
                        style: GoogleFonts.roboto(
                          fontSize: 14.0,
                          color: Color.fromARGB(255, 66, 66, 66),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              backgroundColor:
                  Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Konfirmasi"),
                      content:
                          Text("Apakah Anda yakin ingin menghapus data ini?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Tidak"),
                        ),
                        TextButton(
                          onPressed: () async {
                            var result = await _controller
                                .deleteKuliner(widget.kuliner.id);
                            if (result['success']) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result['message'])),
                              );
                              Navigator.pop(context);
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
                            Navigator.pop(context);
                          },
                          child: Text("Ya"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.delete),
            ),
            SizedBox(
              width: 20,
            ),
            FloatingActionButton(
              backgroundColor:
                  Color.fromARGB(255, 255, 250, 250).withOpacity(0.8),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditKuliner(),
                    settings: RouteSettings(arguments: widget.kuliner),
                  ),
                );
              },
              child: Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
