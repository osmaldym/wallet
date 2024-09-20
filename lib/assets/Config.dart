import 'package:flutter/material.dart';

class Config {
  static ThemeMode themeMode = ThemeMode.light;

  static bool get isThemeDark { return themeMode == ThemeMode.dark; }
}