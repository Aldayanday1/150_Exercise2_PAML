import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormKuliner extends StatefulWidget {
  const FormKuliner({super.key});

  @override
  State<FormKuliner> createState() => _FormKulinerState();
}

class _FormKulinerState extends State<FormKuliner> {
  File? _image;
  final _imagePicker = ImagePicker();
  String? _alamat;

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
