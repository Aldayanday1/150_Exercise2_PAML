import 'package:flutter/material.dart';
import 'package:kulinerjogja/domain/model/kuliner.dart';

class RadioButton extends StatefulWidget {
  // ----- MENAMBAHKAN PARAMETER selectedKategori DAN onKategoriSelected KEDALAM KONSTRUKTOR RADIO BUTTON
  final Kategori? selectedKategori;
  final Function(Kategori?) onKategoriSelected;

//konstruktor parameter
  const RadioButton(
      {super.key, this.selectedKategori, required this.onKategoriSelected});

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RadioListTile<Kategori>(
          title: const Text('Makanan'),
          // value -> nilai ini terkait dengan masing-masing opsi dalam grup radio button
          value: Kategori.MAKANAN,
          // groupValue -> mengelompokkan keseluruhan radio button dalam value yg sama
          groupValue: widget.selectedKategori,
          onChanged: widget.onKategoriSelected,
        ),
        RadioListTile<Kategori>(
          title: const Text("Minuman"),
          value: Kategori.MINUMAN,
          groupValue: widget.selectedKategori,
          onChanged: widget.onKategoriSelected,
        ),
        RadioListTile<Kategori>(
          title: const Text("Kue"),
          value: Kategori.KUE,
          groupValue: widget.selectedKategori,
          onChanged: widget.onKategoriSelected,
        ),
        RadioListTile<Kategori>(
          title: const Text("Dessert"),
          value: Kategori.DESSERT,
          groupValue: widget.selectedKategori,
          onChanged: widget.onKategoriSelected,
        ),
        RadioListTile<Kategori>(
          title: const Text("Snack"),
          value: Kategori.SNACK,
          groupValue: widget.selectedKategori,
          onChanged: widget.onKategoriSelected,
        ),
        RadioListTile<Kategori>(
          title: const Text("Bread"),
          value: Kategori.BREAD,
          groupValue: widget.selectedKategori,
          onChanged: widget.onKategoriSelected,
        ),
        RadioListTile<Kategori>(
          title: const Text("Tea"),
          value: Kategori.TEA,
          groupValue: widget.selectedKategori,
          onChanged: widget.onKategoriSelected,
        ),
        RadioListTile<Kategori>(
          title: const Text("Coffee"),
          value: Kategori.COFFEE,
          groupValue: widget.selectedKategori,
          onChanged: widget.onKategoriSelected,
        ),
        RadioListTile<Kategori>(
          title: const Text("Juice"),
          value: Kategori.JUICE,
          groupValue: widget.selectedKategori,
          onChanged: widget.onKategoriSelected,
        ),
      ],
    );
  }
}
