import 'package:flutter/material.dart';
import 'package:sistem_pengaduan/domain/model/pengaduan.dart';
import 'package:sistem_pengaduan/presentation/views/admin_page/card_pengaduan.dart';

class CategoryPage extends StatelessWidget {
  final Kategori category;
  final List<Pengaduan> pengaduanList;

  const CategoryPage({required this.category, required this.pengaduanList});

  @override
  Widget build(BuildContext context) {
    // ---------------------- FILTERING LIST ----------------------

    final filteredPengaduanList = pengaduanList
        .where((pengaduan) => pengaduan.kategori == category)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(" ${category.displayName}"),
      ),

      // ---------------  TAMPILAN DARI CATEGORY CARD ---------------

      body: filteredPengaduanList.isEmpty
          ? Center(child: Text("No Pengaduan available in this category"))
          : ListView.builder(
              itemCount: filteredPengaduanList.length,
              itemBuilder: (context, index) {
                Pengaduan pengaduan = filteredPengaduanList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildPengaduanCardAdmin(context, pengaduan),
                );
              },
            ),
    );
  }
}
