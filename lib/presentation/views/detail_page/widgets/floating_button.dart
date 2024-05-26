import 'package:flutter/material.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:kulinerjogja/presentation/controllers/kuliner_controller.dart';
import 'package:kulinerjogja/presentation/views/edit_screen.dart';
import 'package:kulinerjogja/presentation/views/home_page/home_screen.dart';
// import 'package:another_flushbar/flushbar.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'dart:ui'; // Import dart:ui untuk menggunakan ImageFilter

class ActionButtons extends StatefulWidget {
  final Kuliner kuliner;

  ActionButtons({required this.kuliner});

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  final KulinerController _controller = KulinerController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            backgroundColor:
                Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Konfirmasi"),
                    content:
                        Text("Apakah Anda yakin ingin menghapus data ini?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Return false
                        },
                        child: Text('Tidak'),
                      ),
                      TextButton(
                        onPressed: () async {
                          var result = await _controller
                              // menerima nilai dari id dari parameter onPressedDelete -> utk kemudian data "id" dari variable kuliner mana sih yg ingin dihapus
                              .deleteKuliner(widget.kuliner.id);
                          // Navigasi ke HomeView setelah delete berhasil
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomeView()),
                          );
                          if (result['success']) {
                            // Tampilkan Flushbar dari atas
                            await Flushbar(
                              flushbarStyle: FlushbarStyle.FLOATING,
                              message: result['message'],
                              duration: Duration(
                                  seconds: 3), // Durasi flushbar tampil
                              flushbarPosition:
                                  FlushbarPosition.TOP, // Posisi di atas
                              margin: EdgeInsets.symmetric(
                                  horizontal: 40.0, vertical: 29.0),
                              padding: EdgeInsets
                                  .zero, // Set padding to zero to use custom container padding
                              borderRadius: BorderRadius.circular(15.0),
                              backgroundColor: Colors
                                  .transparent, // Make background transparent
                              boxShadows: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 170, 170, 170)
                                      .withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(2, 2),
                                ),
                              ],
                              // Custom widget to create glass look
                              messageText: ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 5.0, sigmaY: 5.0),
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.0),
                                    child: Center(
                                      child: ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return LinearGradient(
                                            colors: [
                                              Color.fromARGB(167, 0, 82, 170),
                                              Color.fromARGB(186, 82, 0, 189),
                                            ],
                                          ).createShader(bounds);
                                        },
                                        child: Text(
                                          result['message'],
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ).show(context);
                          } else {
                            // Tampilkan Flushbar dari atas
                            Flushbar(
                              flushbarStyle: FlushbarStyle.FLOATING,
                              message: result['message'],
                              duration: Duration(
                                  seconds: 3), // Durasi flushbar tampil
                              flushbarPosition:
                                  FlushbarPosition.TOP, // Posisi di atas
                              margin: EdgeInsets.symmetric(
                                  horizontal: 40.0, vertical: 27.0),
                              padding: EdgeInsets
                                  .zero, // Set padding to zero to use custom container padding
                              borderRadius: BorderRadius.circular(15.0),
                              backgroundColor: Colors
                                  .transparent, // Make background transparent
                              boxShadows: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 143, 143, 143)
                                      .withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(2, 2),
                                ),
                              ],
                              // Custom widget to create glass look
                              messageText: ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 5.0, sigmaY: 5.0),
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.0),
                                    child: Center(
                                      child: ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return LinearGradient(
                                            colors: [
                                              Color.fromARGB(225, 0, 108, 224),
                                              Color.fromARGB(223, 96, 0, 223),
                                            ],
                                          ).createShader(bounds);
                                        },
                                        child: Text(
                                          result['message'],
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ).show(context);
                          }
                        },
                        child: Text("Ya"),
                      )
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.delete),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            backgroundColor:
                Color.fromARGB(255, 255, 250, 250).withOpacity(0.8),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditKuliner(),
                    settings: RouteSettings(arguments: widget.kuliner),
                  ),
                );
            },
            child: Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
