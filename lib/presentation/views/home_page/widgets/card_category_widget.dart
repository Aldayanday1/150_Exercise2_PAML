import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThreeCardsRow extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategoryTap;
  final VoidCallback onReset;

  const ThreeCardsRow({
    required this.selectedCategory,
    required this.onCategoryTap,
    required this.onReset,
  });

  @override
  State<ThreeCardsRow> createState() => _ThreeCardsRowState();
}

class _ThreeCardsRowState extends State<ThreeCardsRow> {
  String _lastSelectedCategory = '';

  void _handleCardTap(String category) {
    if (_lastSelectedCategory == category) {
      widget.onReset();
      _lastSelectedCategory = '';
    } else {
      widget.onCategoryTap(category);
      _lastSelectedCategory = category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            buildCard("Infrastruktur", widget.selectedCategory == "Makanan",
                () => _handleCardTap("Makanan")),
            buildCard("Lingkungan", widget.selectedCategory == "Minuman",
                () => _handleCardTap("Minuman")),
            buildCard("Transportasi", widget.selectedCategory == "Kue",
                () => _handleCardTap("Kue")),
            buildCard(
                "Keamanan dan Ketertiban",
                widget.selectedCategory == "Dessert",
                () => _handleCardTap("Dessert")),
            buildCard("Kesehatan", widget.selectedCategory == "Snack",
                () => _handleCardTap("Snack")),
            buildCard("Pendidikan", widget.selectedCategory == "Bread",
                () => _handleCardTap("Bread")),
            buildCard("Sosial", widget.selectedCategory == "Tea",
                () => _handleCardTap("Tea")),
            buildCard(
                "Perizinan dan Regulasi",
                widget.selectedCategory == "Coffee",
                () => _handleCardTap("Coffee")),
            buildCard("Birokrasi", widget.selectedCategory == "Milk",
                () => _handleCardTap("Milk")),
            buildCard("Lainnya", widget.selectedCategory == "Juice",
                () => _handleCardTap("Juice")),
          ],
        ),
      ),
    );
  }

  Widget buildCard(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color.fromARGB(255, 235, 235, 235),
                    blurRadius: 10.0,
                    offset: Offset(0, 0),
                  )
                ]
              : [],
        ),
        child: Card(
          color: isSelected
              ? Color.fromARGB(255, 61, 61, 61)
              : Color.fromARGB(255, 255, 255, 255),
          elevation: isSelected ? 0 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          Color.fromARGB(255, 146, 146, 146), // Biru
                          Color.fromARGB(255, 204, 204, 204), // Ungu agak pink
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Center(
                child: Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 10.0,
                    color: isSelected
                        ? Color.fromARGB(255, 255, 255, 255)
                        : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
