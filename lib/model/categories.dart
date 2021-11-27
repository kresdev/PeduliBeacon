import 'package:flutter/material.dart';

class  Category{

  String name;
  IconData icon;

  Category(this.name, this.icon);
}

List <Category> categoryIcon = [
  Category('Pendaftaran Vaksin', Icons.medication_outlined),
  Category('Scan Beacon', Icons.bluetooth),
  Category('Teledokter', Icons.phonelink_ring_sharp),
  Category('Info Penting', Icons.info_outline_rounded),
  Category('Diary Perjalanan', Icons.menu_book_outlined),
  Category('Paspor Digital', Icons.note_alt_outlined)
];