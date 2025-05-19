import 'package:flutter/material.dart';

final Color jungleGreen = Color(0xFF29AB87);

final ThemeData appTheme = ThemeData(
  primaryColor: jungleGreen,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: jungleGreen,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: jungleGreen,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: jungleGreen,
      foregroundColor: Colors.white,
      textStyle: TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: jungleGreen, width: 2),
    ),
  ),
);