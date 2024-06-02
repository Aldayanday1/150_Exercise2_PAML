import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kulinerjogja/presentation/controllers/kuliner_controller.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';
import 'package:kulinerjogja/presentation/views/home_page/widgets/card_category_widget.dart';
import 'package:kulinerjogja/presentation/views/home_page/widgets/card_kuliner.dart';
import 'package:kulinerjogja/presentation/views/home_page/widgets/card_slider_widget.dart';
import 'package:kulinerjogja/presentation/views/home_page/widgets/floating_button.dart';
import 'package:kulinerjogja/presentation/views/search_page/widgets/search_widget.dart';
import 'package:lottie/lottie.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final KulinerController _controller = KulinerController();

  List<Kuliner>? _allKuliner;
  String _selectedCategory = "";

  @override
  void initState() {
    super.initState();
    _loadAllKuliner();
  }

  Future<void> _refreshData() async {
    await _loadAllKuliner();
    setState(() {});
  }

  Future<void> _loadAllKuliner() async {
    _allKuliner = await _controller.getAllKuliner();
    print('Total kuliner: ${_allKuliner?.length ?? 0}');
    setState(() {});
  }

  Future<List<Kuliner>> _getFutureByCategory() async {
    if (_selectedCategory.isEmpty) {
      return _allKuliner ?? [];
    }
    Kategori selectedKategori =
        Kategori.fromString(_selectedCategory.toUpperCase());
    return _allKuliner
            ?.where((kuliner) => kuliner.kategori == selectedKategori)
            .toList() ??
        [];
  }

  void _loadKategori(String category) {
    setState(() {
      _selectedCategory = category;
      print('Kategori dipilih: $_selectedCategory');
    });
  }

  void _resetCategory() {
    setState(() {
      _selectedCategory = '';
      print('Kategori direset');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 70),
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 0, left: 20),
                      child: Text(
                        "Hi, Aldi Raihan !",
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 25,
                          color: Color.fromARGB(255, 66, 66, 66),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SearchWidget(),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 0, left: 20),
                      child: Text(
                        "Near from you",
                        style: GoogleFonts.roboto(
                          fontSize: 18.38,
                          color: Color.fromARGB(255, 66, 66, 66),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    AutoSlideCards(kulinerList: _allKuliner ?? []),
                    ThreeCardsRow(
                      selectedCategory: _selectedCategory,
                      onCategoryTap: _loadKategori,
                      onReset: _resetCategory,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 5, left: 20),
                      child: Text(
                        "List of Category",
                        style: GoogleFonts.roboto(
                          fontSize: 18.38,
                          color: Color.fromARGB(255, 66, 66, 66),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    FutureBuilder<List<Kuliner>>(
                      future: _getFutureByCategory(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 80, bottom: 180),
                              child: Container(
                                child: Text(
                                  "Maaf, Tidak Tersedia.",
                                  style: GoogleFonts.roboto(
                                    fontSize: 13.5,
                                    color: Color.fromARGB(255, 66, 66, 66),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 100.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(top: 10),
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                Kuliner kuliner = snapshot.data![index];
                                // Memeriksa apakah data baru atau diperbarui
                                return buildKulinerCard(context, kuliner);
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingButton(),
        ),
      ],
    );
  }
}
