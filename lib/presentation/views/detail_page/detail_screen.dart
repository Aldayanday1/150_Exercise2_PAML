import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kulinerjogja/presentation/views/detail_page/widgets/floating_button.dart';
import 'package:kulinerjogja/presentation/views/edit_page/edit_screen.dart';
import 'package:kulinerjogja/presentation/views/home_page/home_screen.dart';
import 'package:kulinerjogja/presentation/views/map_page/map_static.dart';
import 'dart:math';

class DetailView extends StatefulWidget {
  final Kuliner kuliner;
  final bool isNew;

  const DetailView({Key? key, required this.kuliner, this.isNew = true})
      : super(key: key);

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'unique_tag_${widget.kuliner.id}',
                  child: ClipPath(
                    clipper: ReverseWaveClipper(),
                    child: Image.network(
                      widget.kuliner.gambar,
                      height: 500,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 310,
                  child: Center(
                    child: Text(
                      "Detail Screen",
                      style: GoogleFonts.comfortaa(
                        fontSize: 24.0,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 72,
                    left: 30,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeView(),
                          ),
                        );
                      },
                    )),
                Positioned.fill(
                  bottom: 315,
                  left: 330,
                  child: Center(
                      child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditKuliner(
                            kuliner: widget.kuliner,
                          ),
                          settings: RouteSettings(arguments: widget.kuliner),
                        ),
                      );
                    },
                  )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.kuliner.nama,
                      style: GoogleFonts.roboto(
                        fontSize: 25.0,
                        color: Color.fromARGB(255, 66, 66, 66),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      widget.kuliner.deskripsi,
                      style: GoogleFonts.roboto(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 66, 66, 66),
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      widget.kuliner.kategoriString,
                      style: GoogleFonts.roboto(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 66, 66, 66),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.kuliner.alamat,
                      style: GoogleFonts.roboto(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 66, 66, 66),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Di dalam widget DetailView:
                    Text(widget.kuliner.dateMessage),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 130),
              child: GestureDetector(
                onVerticalDragUpdate: (ltlng) {},
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
                      // onLocationChanged: (ltlng, strng) {},
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ActionButtons(
        // menerima nilai dari varibale yang akan diambil/peroleh datanya, dalam hal ini variable "kuliner"
        kuliner: widget.kuliner,
      ),
    );
  }
}

class ReverseWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height); // Titik awal kiri bawah

    for (var i = 0; i < size.width.toInt(); i += 10) {
      var x = i.toDouble();
      var y = -sin((i / size.width) * 2 * pi) * 20 + size.height * 0.9;
      path.lineTo(x, y); // Menambahkan titik ke path
    }

    path.lineTo(size.width, size.height); // Titik akhir kanan bawah
    path.lineTo(size.width, 0); // Titik akhir kanan atas
    path.close(); // Menutup path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
