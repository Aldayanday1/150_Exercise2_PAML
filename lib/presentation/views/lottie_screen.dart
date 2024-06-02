import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kulinerjogja/presentation/views/home_page/home_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
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
          Positioned.fill(
            child: Center(
              child: Lottie.network(
                'https://lottie.host/9d0bbb96-6a35-4baf-88ea-ceaa80ae9b07/uldMBV0vzi.json',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Positioned.fill(
          //   child: Center(
          //     child: FloatingActionButton(
          //       onPressed: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => HomeView(),
          //             ));
          //       },
          //       child: Icon(Icons.send),
                
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
