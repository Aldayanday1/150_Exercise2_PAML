import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kulinerjogja/presentation/views/detail_page/widgets/floating_button.dart';
import 'package:kulinerjogja/presentation/views/map_static.dart';

class DetailView extends StatefulWidget {
  final Kuliner kuliner;

  const DetailView({super.key, required this.kuliner});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
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
                      SizedBox(height: 15),
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
                      SizedBox(height: 0),
                      Text(
                        widget.kuliner.kategoriString,
                        style: GoogleFonts.roboto(
                          fontSize: 14.0,
                          color: Color.fromARGB(255, 66, 66, 66),
                        ),
                      ),
                      SizedBox(height: 0),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  height: 200,
                  child: StaticMap(
                    location: LatLng(
                        widget.kuliner.latitude, widget.kuliner.longitude),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ActionButtons(
        // menerima nilai dari varibale mana sih yang akan diambil/peroleh datanya, dalam hal ini variable "kuliner"
        kuliner: widget.kuliner,
      ),
    );
  }
}
