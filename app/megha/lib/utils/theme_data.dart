import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Color(0xfff9f8fd),
      primaryColor: Color(0xfff9f8fd),
      appBarTheme: AppBarTheme(backgroundColor: Color(0xfff9f8fd),toolbarTextStyle: TextStyle(color: Colors.black),elevation: 0)
    
      );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
      );
}
