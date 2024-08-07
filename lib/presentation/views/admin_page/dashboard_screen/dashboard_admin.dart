import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistem_pengaduan/domain/model/daily_graph.dart';
import 'package:sistem_pengaduan/domain/model/pengaduan.dart';
import 'package:sistem_pengaduan/presentation/controllers/pengaduan_controller.dart';
import 'package:sistem_pengaduan/presentation/controllers/user_controller.dart';
import 'package:sistem_pengaduan/presentation/views/admin_page/category_screen/widgets/category_grid_widget.dart';
import 'package:sistem_pengaduan/presentation/views/admin_page/dashboard_screen/widgets/graph_widget.dart';
import 'package:sistem_pengaduan/presentation/views/admin_page/status_screen/widgets/status_widget.dart';
import 'package:sistem_pengaduan/presentation/views/auth_pages/login_admin_page/login_page.dart';
import 'package:sistem_pengaduan/presentation/views/search_page/widgets/search_widget.dart';

import '../../../../data/services/pengaduan_service.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({Key? key}) : super(key: key);

  @override
  State<DashboardAdmin> createState() => _HomeViewState();
}

class _HomeViewState extends State<DashboardAdmin> {
// --------------------------- INITIALIZE DATA --------------------------

  @override
  void initState() {
    super.initState();
    _loadAllPengaduan();
    _refreshGraph();
  }

  Future<void> _refreshData() async {
    await _loadAllPengaduan();
    await _refreshGraph();
    setState(() {});
  }

  // --------------------------- LOAD ALL DATA ---------------------------

  List<Pengaduan>? _allPengaduan;

  final PengaduanController _controller = PengaduanController();

  Future<void> _loadAllPengaduan() async {
    _allPengaduan = await _controller.getAllPengaduan();
    print('Total pengaduan: ${_allPengaduan?.length ?? 0}');
    setState(() {});
  }

  // ------------------- ANIMATED GRAPH -------------------

  late Future<List<PengaduanDaily>> futurePengaduanGraph;

  Future<void> _refreshGraph() async {
    futurePengaduanGraph = PengaduanService().fetchDailyPengaduanCount();
  }

  // ------------------- SNACKBAR SESSION BREAK -------------------

  // void _showSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message)),
  //   );
  // }

  // ------------------- LOGOUT FUNCTION -------------------

  final UserController userController = UserController();

  // Method to show the logout confirmation dialog
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Ya'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout(); // Call the logout method
              },
            ),
          ],
        );
      },
    );
  }

// Method to handle logout
  Future<void> _logout() async {
    try {
      await userController.logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AdminLoginPage()),
        // Menghapus semua route dari stack
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      // Handle logout error
      print('Error during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
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
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 27.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),

                        // ------------------- HEADER -------------------

                        Padding(
                          padding:
                              EdgeInsets.only(top: 15, bottom: 0, left: 20),
                          child: Column(
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
                                    "Dashboard Admin",
                                    style: GoogleFonts.leagueSpartan(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 66, 66, 66),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.logout),
                                    color: Color.fromARGB(255, 66, 66, 66),
                                    onPressed: () {
                                      _showLogoutConfirmationDialog();
                                    },
                                  ),
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                child: SearchWidget(),
                              ),
                            ],
                          ),
                        ),

                        // // -------------------- SLIDE CARDS --------------------

                        // AutoSlideCardsAdmin(pengaduanList: _allPengaduan ?? []),

                        // ------------------- TOTAL PENGADUAN -------------------

                        Padding(
                          padding:
                              EdgeInsets.only(top: 20, bottom: 20, left: 22),
                          child: FutureBuilder<List<Pengaduan>>(
                            future: _controller.getAllPengaduan(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (snapshot.hasData) {
                                final totalPengaduan = snapshot.data!.length;
                                return Padding(
                                  padding: const EdgeInsets.only(left: 7.0),
                                  child: RichText(
                                      text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '$totalPengaduan',
                                        style: GoogleFonts.roboto(
                                          fontSize:
                                              46, // Ukuran teks untuk angka
                                          color: const Color.fromARGB(
                                              255, 66, 66, 66),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                8), // Menambahkan jarak antara angka dan teks
                                      ),
                                      TextSpan(
                                        text: ' Total Pengaduan',
                                        style: GoogleFonts.roboto(
                                          fontSize:
                                              12, // Ukuran teks untuk label
                                          color: const Color.fromARGB(
                                              255, 66, 66, 66),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  )),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),

                        // ------------------- ANIMATED GRAPH -------------------

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: PengaduanChart(
                            futurePengaduanGraph: futurePengaduanGraph,
                          ),
                        ),

                        // ------------------------  STATUS CATEGORY ------------------------

                        Padding(
                          padding: const EdgeInsets.only(
                              top: 27.0, left: 35, bottom: 5),
                          child: Text(
                            "Status Category",
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 15,
                              color: Color.fromARGB(255, 87, 87, 87),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),

                        PengaduanStatusCard(status: "PENDING"),
                        PengaduanStatusCard(status: "PROGRESS"),
                        PengaduanStatusCard(status: "DONE"),

                        // ------------------- LIST OF GRID -------------------

                        Padding(
                          padding: const EdgeInsets.only(top: 45.0, left: 35),
                          child: Text(
                            "List of Complaint",
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 15,
                              color: Color.fromARGB(255, 87, 87, 87),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        FutureBuilder<List<Pengaduan>>(
                          future: _controller.getAllPengaduan(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // While waiting for data, show a loading indicator
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              // If there's an error, show an error message
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              // Once data is loaded, show CategoryGrid
                              return CategoryGrid(
                                  pengaduanList: _allPengaduan ?? []);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
