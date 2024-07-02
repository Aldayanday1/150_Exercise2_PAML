import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/login_admin_page/login_page.dart';
import 'package:kulinerjogja/presentation/views/auth_pages/login_user_page/login_page.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Lottie.network(
                'https://lottie.host/622b70c5-e4ad-44f9-b0ae-cd2a2241ac49/NPNSeOC9Q2.json',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: 0,
            right: 0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 37.0),
                child: AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText(
                      'Hi, ',
                      textStyle: GoogleFonts.poppins(
                        fontSize: 55.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TypewriterAnimatedText(
                      'Welcome to our Public Service',
                      textStyle: GoogleFonts.poppins(
                        fontSize: 38.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      speed: Duration(milliseconds: 150),
                    ),
                    TypewriterAnimatedText(
                      'Enhancement Reporting System',
                      textStyle: GoogleFonts.poppins(
                        fontSize: 38.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      speed: Duration(milliseconds: 150),
                    ),
                  ],
                  totalRepeatCount: 999,
                  pause: Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Column(
          //     children: [
          //       Container(
          //         color: Color.fromARGB(255, 255, 255, 255),
          //         height: 150,
          //       )
          //     ],
          //   ),
          // ),
          Positioned(
            bottom: 17,
            left: 24,
            right: 24,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Login as User",
                      style: GoogleFonts.poppins(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminLoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login as Admin",
                        style: GoogleFonts.poppins(
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


          // Positioned.fill(
          //   child: Center(
          //     child: Lottie.network(
          //       'https://lottie.host/9d0bbb96-6a35-4baf-88ea-ceaa80ae9b07/uldMBV0vzi.json',
          //       width: 200,
          //       height: 200,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),