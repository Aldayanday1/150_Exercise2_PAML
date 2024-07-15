import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import 'package:sistem_pengaduan/domain/model/pengaduan.dart';
import 'package:sistem_pengaduan/presentation/views/admin_page/category_screen/category_screen.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key, required this.pengaduanList});

  final List<Pengaduan> pengaduanList;

  void _navigateToCategoryPage(BuildContext context, Kategori category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryPage(
          category: category,
          pengaduanList: pengaduanList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const categories = Kategori.values;

    final Map<Kategori, int> categoryCounts = {};
    for (var category in categories) {
      categoryCounts[category] =
          pengaduanList.where((pengaduan) => pengaduan.kategori == category).length;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final count = categoryCounts[category] ?? 0;
          return GestureDetector(
            onTap: () => _navigateToCategoryPage(context, category),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 65.0),
                          child: Text(
                            '$count', // Large count text
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              fontSize: 30.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 5.0),
                          child: Text(
                            category.displayName, // Small category text
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              fontSize: 12.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
