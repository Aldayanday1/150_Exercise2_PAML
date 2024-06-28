import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kulinerjogja/domain/model/user_profile.dart';
import 'package:kulinerjogja/presentation/controllers/kuliner_controller.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';
import 'package:kulinerjogja/presentation/controllers/user_controller.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/login_user_page/login_page.dart';
import 'package:kulinerjogja/presentation/views/home_page/widgets/card_category_widget.dart';
import 'package:kulinerjogja/presentation/views/home_page/widgets/card_kuliner.dart';
import 'package:kulinerjogja/presentation/views/home_page/widgets/card_slider_widget.dart';
import 'package:kulinerjogja/presentation/views/home_page/widgets/floating_button.dart';
import 'package:kulinerjogja/presentation/views/search_page/widgets/search_widget.dart';
import 'package:kulinerjogja/presentation/views/user_profile.dart/user_profile_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
// --------------------------- INITIALIZE DATA ---------------------------

  late Future<UserProfile?> _userProfileFuture;

  final UserController _usercontroller = UserController();

  @override
  void initState() {
    super.initState();
    // get all kuliner
    _loadAllKuliner();
    // get user Profile
    _userProfileFuture = _usercontroller.getUserProfile();
  }

  Future<void> _refreshData() async {
    await _loadAllKuliner();
    setState(() {
      _userProfileFuture = _usercontroller.getUserProfile();
    });
  }

  // --------------------------- LOAD ALL DATA ---------------------------
  List<Kuliner>? _allKuliner;

  final KulinerController _controller = KulinerController();

  Future<void> _loadAllKuliner() async {
    _allKuliner = await _controller.getAllKuliner();
    print('Total kuliner: ${_allKuliner?.length ?? 0}');
    setState(() {});
  }

// --------------------------- CATEGORY ---------------------------

  String _selectedCategory = "";

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

  // ------------------- SNACKBAR SESSION BREAK -------------------

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 0, left: 20),

                        // ------------------- USER PROFILE -------------------

                        child: FutureBuilder<UserProfile?>(
                          future: _userProfileFuture,
                          builder: (context, snapshot) {
                            // memperbarui tampilan sesuai dengan status
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              // -------BREAK SESSION-------
                              // Jika error karena token tidak valid, arahkan ke halaman login
                              if (snapshot.error
                                  .toString()
                                  .contains('Token tidak valid')) {
                                Future.microtask(
                                  () {
                                    _showSnackBar(
                                        'Session habis, silakan login kembali');
                                    Navigator.pushAndRemoveUntil( 
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                );
                                return SizedBox
                                    .shrink(); // Mengembalikan widget kosong sementara
                              }
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              UserProfile userProfile = snapshot.data!;
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage:
                                            AssetImage('assets/menu_bar.png'),
                                      ),
                                      Text(
                                        "Home Page",
                                        style: GoogleFonts.leagueSpartan(
                                          fontSize: 20,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Container(
                                        child: userProfile.profileImage ==
                                                'http://192.168.56.1:8080/images/profile.png'
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20.0),
                                                child: CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage: NetworkImage(
                                                      userProfile.profileImage),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              UserProfilePage(),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      blurRadius: 8,
                                                      offset: Offset(-8, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20.0),
                                                  child: CircleAvatar(
                                                    radius: 18,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    backgroundImage:
                                                        NetworkImage(userProfile
                                                            .profileImage),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                UserProfilePage(),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: SearchWidget(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Welcome, ${userProfile.nama}",
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 66, 66, 66),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Center(child: Text('No data available'));
                            }
                          },
                        ),
                      ),

                      // ---------------------- SLIDE CARDS ----------------------

                      AutoSlideCards(kulinerList: _allKuliner ?? []),

                      // ------------------- SELECTED CARD ROW -------------------

                      ThreeCardsRow(
                        selectedCategory: _selectedCategory,
                        onCategoryTap: _loadKategori,
                        onReset: _resetCategory,
                      ),

                      // ------------------- LIST OF CATEGORY -------------------

                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 5, left: 20),
                        child: Text(
                          "List of Category",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
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
          ),

          // ------------------- FLOATING BUTTON -------------------

          floatingActionButton: FloatingButton(),
        ),
      ],
    );
  }
}
