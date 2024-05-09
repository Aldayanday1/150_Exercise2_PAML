import 'package:flutter/material.dart';
import 'package:kulinerjogja/model/kuliner.dart';

class DetailView extends StatefulWidget {
  final Kuliner kuliner;

  const DetailView({super.key, required this.kuliner});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
