import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kulinerjogja/presentation/views/detail_page/widgets/floating_button.dart';
import 'package:kulinerjogja/presentation/views/edit_page/edit_screen.dart';
import 'package:kulinerjogja/presentation/views/home_page/home_screen.dart';
import 'package:kulinerjogja/presentation/views/map_page/map_static.dart';

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
                  tag: 'unique_tag_hero_${widget.kuliner.id}',
                  child: ClipPath(
                    clipper: BottomHalfCircleClipper(),
                    child: Image.network(
                      widget.kuliner.gambar,
                      height: 500,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 305, // Ubah jarak di sini
                  child: Center(
                    child: Text(
                      "Detail Screen",
                      style: GoogleFonts.roboto(
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
                  ),
                ),
                Positioned.fill(
                  bottom: 305, // Ubah jarak di sini
                  left: 330,
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      color: Color.fromARGB(
                          255, 54, 54, 54), // pastikan warna ikon terlihat
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
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(40),
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
                  SizedBox(height: 20),
                  Text(
                    widget.kuliner.deskripsi,
                    style: GoogleFonts.roboto(
                      fontSize: 14.0,
                      color: Color.fromARGB(255, 66, 66, 66),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Kategori : ${widget.kuliner.kategoriString}',
                    style: GoogleFonts.roboto(
                      fontSize: 14.0,
                      color: Color.fromARGB(255, 66, 66, 66),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 66, 66, 66),
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.kuliner.alamat,
                          style: GoogleFonts.roboto(
                            fontSize: 14.0,
                            color: Color.fromARGB(255, 66, 66, 66),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(widget.kuliner.dateMessage),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
              child: GestureDetector(
                onVerticalDragUpdate: (ltlng) {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      height: 220,
                      child: StaticMap(
                        location: LatLng(
                            widget.kuliner.latitude, widget.kuliner.longitude),
                        // onLocationChanged: (ltlng, strng) {},
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
