import 'dart:async';
import 'package:flutter/material.dart';

class AutoSlideCards extends StatefulWidget {
  @override
  _AutoSlideCardsState createState() => _AutoSlideCardsState();
}

class _AutoSlideCardsState extends State<AutoSlideCards> {
  late Timer _timer;
  late PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Mengatur timer untuk menggeser slide setiap 3 detik
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < 2) {
        // Jika belum di slide terakhir, lanjutkan ke slide berikutnya
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      } else {
        // Jika sudah di slide terakhir, kembali ke slide pertama dengan animasi
        _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });

    // Mendengarkan perubahan halaman untuk memperbarui indikator
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Memastikan timer dihentikan saat widget dihapus
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3.2, // Tinggi slide
            child: PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                      value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                    }
                    return Center(
                      child: SizedBox(
                        height: Curves.easeOut.transform(value) * 250,
                        width: Curves.easeOut.transform(value) * 350,
                        child: child,
                      ),
                    );
                  },
                  child: buildCard(index),
                );
              },
              itemCount: 3, // Jumlah card
            ),
          ),
          SizedBox(height: 8), // Padding antara slider dan indikator
          buildIndicator(), // Indikator titik-titik
        ],
      ),
    );
  }

  Widget buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Colors.blue
                : Colors.grey, // Warna titik aktif atau non-aktif
          ),
        ),
      ),
    );
  }

  Widget buildCard(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        gradient: _getGradient(),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Card(
        color: Colors
            .transparent, // Set card color to transparent to see BoxDecoration
        elevation: 0, // Remove card default shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Text(
            'Slide ${index + 1}',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// Fungsi untuk mengatur warna tiap slide
Color _getColor(int index) {
  switch (index) {
    case 0:
      return Color.fromARGB(255, 255, 100, 216);
    case 1:
      return Color.fromARGB(255, 189, 118, 255);
    case 2:
      return Color.fromARGB(255, 123, 113, 255);
    default:
      return Color.fromARGB(255, 106, 186, 255); // Default color
  }
}

LinearGradient _getGradient() {
  return LinearGradient(
    colors: [
      Color.fromARGB(255, 123, 113, 255), // Biru
      Color.fromARGB(255, 255, 100, 216), // Ungu agak pink
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
