import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  static final Color primary = Color(0xFF124191);
  static final Color cardColor = Color(0xFF37334d);
  static final Color addCardColor = Color(0xFF03DAC5);
  static final Color text = Color.fromRGBO(39, 105, 171, 1);
  static final List<Color> iconColors = [
    Color(0xFF64B5F6),
    Color(0xFF27cf53),
    Color(0xFFf3a643),
    Color(0xFF526BC2),
    Color(0xFF03DAC5)
  ];

  static TextStyle headerStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .headline5
      .copyWith(color: Colors.white, fontWeight: FontWeight.bold);

  static TextStyle cardTitleStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .subtitle1
      .copyWith(color: Colors.white, fontWeight: FontWeight.bold);

  static TextStyle buttonStyle(BuildContext context) =>
      Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.grey);
}