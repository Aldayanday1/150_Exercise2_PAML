import 'package:flutter/material.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';
import 'package:kulinerjogja/presentation/views/admin_page/card_kuliner.dart';
import 'package:kulinerjogja/presentation/views/home_page/widgets/card_kuliner.dart';

class CategoryPage extends StatelessWidget {
  final Kategori category;
  final List<Kuliner> kulinerList;

  const CategoryPage({required this.category, required this.kulinerList});

  @override
  Widget build(BuildContext context) {
    // ---------------------- FILTERING LIST ----------------------

    final filteredKulinerList =
        kulinerList.where((kuliner) => kuliner.kategori == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(" ${category.displayName}"),
      ),

      // ---------------  TAMPILAN DARI CATEGORY CARD ---------------

      body: filteredKulinerList.isEmpty
          ? Center(child: Text("No kuliner available in this category"))
          : ListView.builder(
              itemCount: filteredKulinerList.length,
              itemBuilder: (context, index) {
                Kuliner kuliner = filteredKulinerList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildKulinerCardAdmin(context, kuliner),
                );
              },
            ),
    );
  }
}
