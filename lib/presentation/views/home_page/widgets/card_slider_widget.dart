import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';
import 'package:kulinerjogja/presentation/views/detail_page/detail_screen.dart';

class AutoSlideCards extends StatefulWidget {
  final List<Kuliner> kulinerList;

  AutoSlideCards({required this.kulinerList});

  @override
  _AutoSlideCardsState createState() => _AutoSlideCardsState();
}

class _AutoSlideCardsState extends State<AutoSlideCards> {
  late Timer _timer;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);

    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < widget.kulinerList.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
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
            height: MediaQuery.of(context).size.height / 2.1,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.kulinerList.length,
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
                        height: Curves.easeOut.transform(value) * 500,
                        width: Curves.easeOut.transform(value) * 400,
                        child: child,
                      ),
                    );
                  },
                  child: buildCard(widget.kulinerList[index]),
                );
              },
            ),
          ),
          SizedBox(height: 5),
          buildIndicator(),
        ],
      ),
    );
  }

  Widget buildCard(Kuliner kuliner) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailView(kuliner: kuliner),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Stack(
            children: [
              Image.network(
                kuliner.gambar,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(143, 0, 0, 0),
                        Color.fromARGB(0, 10, 10, 10)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double
                            .infinity, // Make sure the text takes up the full width
                        child: Text(
                          kuliner.nama,
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 3.0,
                                color: Colors.black,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis, // Handle overflow
                          maxLines:
                              2, // Optional: specify the max number of lines
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              kuliner.alamat,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.kulinerList.length,
        (index) => Container(
          width: 7.0,
          height: 7.0,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Color.fromARGB(255, 78, 78, 78)
                : const Color.fromARGB(255, 175, 175, 175),
          ),
        ),
      ),
    );
  }
}
