import 'package:flutter/material.dart';

class Preference {
  final int pid;
  final String title;
  final String imgUrl;
  bool isSelected;
  List<int> choices = [];

  Preference({
    @required this.pid,
    this.title,
    this.imgUrl,
    this.isSelected,
    this.choices,
  });
}
