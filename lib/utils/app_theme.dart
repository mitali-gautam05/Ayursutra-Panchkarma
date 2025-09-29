import 'package:flutter/material.dart';

class AppTheme {
  static final Color primary = Colors.teal.shade700;
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: Colors.grey[50],
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
