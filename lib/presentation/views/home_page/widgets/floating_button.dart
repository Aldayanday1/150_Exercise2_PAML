import 'package:flutter/material.dart';
import 'package:kulinerjogja/presentation/views/home_page/home_screen.dart';
import 'package:kulinerjogja/presentation/views/qna_page/qna_page.dart';
import 'package:kulinerjogja/presentation/views/form_kuliner_page/form_kuliner_screen.dart';

class FloatingButton extends StatefulWidget {
  @override
  _FloatingButtonState createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    // Hanya update _selectedIndex jika indeks baru berbeda dengan yang sebelumnya
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
    // Navigate to different pages based on the selected index
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomeView()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QnAPage()));
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormKuliner()),
        );
        break;
      case 3:
        // Navigate to settings
        break;
      case 4:
        // Navigate to profile
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                55.0, 0.0, 25.0, 3.0), // Adjust the bottom padding
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: SizedBox(
                height: 65,
                child: BottomAppBar(
                  shape: CircularNotchedRectangle(),
                  notchMargin: 1.0, // Ubah notch margin menjadi lebih kecil
                  color: Color.fromARGB(255, 41, 41, 41),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.home),
                          color: _selectedIndex == 0
                              ? Color.fromARGB(255, 167, 161, 255)
                              : Color.fromARGB(255, 255, 157, 230),
                          onPressed: () => _onItemTapped(0),
                        ),
                        IconButton(
                          icon: Icon(Icons.help),
                          color: _selectedIndex == 1
                              ? Color.fromARGB(255, 167, 161, 255)
                              : Color.fromARGB(255, 255, 157, 230),
                          onPressed: () => _onItemTapped(1),
                        ),
                        SizedBox(width: 60),
                        IconButton(
                          icon: Icon(Icons.notes_outlined),
                          color: _selectedIndex == 3
                              ? Color.fromARGB(255, 167, 161, 255)
                              : Color.fromARGB(255, 255, 157, 230),
                          onPressed: () => _onItemTapped(3),
                        ),
                        IconButton(
                          icon: Icon(Icons.person),
                          color: _selectedIndex == 4
                              ? Color.fromARGB(255, 167, 161, 255)
                              : Color.fromARGB(255, 255, 157, 230),
                          onPressed: () => _onItemTapped(4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 8, // Adjust the position of the floating action button
          left: 30,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () => _onItemTapped(
                    2), // Set onPressed to call _onItemTapped(2) for the middle button
                backgroundColor: Colors.transparent,
                elevation: 15,
                child: Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 167, 161, 255),
                        Color.fromARGB(255, 255, 157, 230),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
