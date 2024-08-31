import 'package:flutter/material.dart';

const keyColor = Color(0xFF509a72);

final defaultLightColorScheme = ColorScheme.fromSeed(
  seedColor: keyColor,
  brightness: Brightness.light,
  surface: Colors.white,
);

final defaultDarkColorScheme = ColorScheme.fromSeed(
  seedColor: keyColor,
  brightness: Brightness.dark,
  surface: Colors.black,
);
