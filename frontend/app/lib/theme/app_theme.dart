import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFF020617);

  static const surface = Color(0xFF0F172A);

  static const card = Color(0xFF111C34);

  static const primary = Color(0xFF60A5FA);

  static const secondaryText = Color(0xFF94A3B8);

  static const border = Color(0x1FFFFFFF);

  static BorderRadius cardRadius = BorderRadius.circular(24);

  static List<BoxShadow> softShadow = [
    BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10)),
  ];
}
