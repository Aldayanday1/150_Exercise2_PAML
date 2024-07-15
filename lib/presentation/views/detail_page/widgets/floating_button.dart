import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:ui';

import 'package:sistem_pengaduan/domain/model/pengaduan.dart';
import 'package:sistem_pengaduan/presentation/controllers/pengaduan_controller.dart';
import 'package:sistem_pengaduan/presentation/views/auth_pages/login_user_page/login_page.dart';
import 'package:sistem_pengaduan/presentation/views/home_page/home_screen.dart'; // Import dart:ui untuk menggunakan ImageFilter

class ActionButtons extends StatefulWidget {
  final Pengaduan pengaduan;

  ActionButtons({required this.pengaduan});

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  final PengaduanController _controller = PengaduanController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25, left: 20),
      child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300), child: _buildExpandedButton()),
    );
  }

  Widget _buildExpandedButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Konfirmasi"),
                  content: Text("Apakah Anda yakin ingin menghapus data ini?"),
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
                            // menerima nilai dari id dari parameter onPressedDelete -> utk kemudian data "id" dari variable pengaduan mana sih yg ingin dihapus
                            .deletePengaduan(widget.pengaduan.id);
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
                            duration:
                                Duration(seconds: 3), // Durasi flushbar tampil
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
                                    .withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(2, 2),
                              ),
                            ],
                            // Custom widget to create glass look
                            messageText: ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 18.0),
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
                          // -------BREAK SESSION-------
                        } else if (result['message'] ==
                            'Token tidak valid. Silakan login kembali.') {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                              settings: RouteSettings(
                                arguments:
                                    'Session habis, silakan login kembali',
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          // Tampilkan Flushbar dari atas
                          Flushbar(
                            flushbarStyle: FlushbarStyle.FLOATING,
                            message: result['message'],
                            duration:
                                Duration(seconds: 3), // Durasi flushbar tampil
                            flushbarPosition:
                                FlushbarPosition.TOP, // Posisi di atas
                            margin: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 27.0),
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
                                filter:
                                    ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
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
      ],
    );
  }
}
