import 'package:flutter/material.dart';

class EditKuliner extends StatefulWidget {
  const EditKuliner({super.key});

  @override
  State<EditKuliner> createState() => _EditKulinerState();
}

class _EditKulinerState extends State<EditKuliner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 61, 61, 61),
      appBar: AppBar(
        title: Text("Edit Screen"),
      ),
    );
  }
}
