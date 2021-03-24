import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final setLightTheme = _buildLightTheme();
final setDarkTheme = _buildDarkTheme();

ThemeData _buildLightTheme() {
   Color lightPrimary = Colors.white;
   Color lightAccent = Colors.lime[600];
   Color lightBG = Colors.white;
  return ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      color: Colors.lime[700],
    ),
  );
}

ThemeData _buildDarkTheme() {
  Color darkPrimary = Color(0xff1f1f1f);
  Color darkAccent = Colors.teal[700];
  Color darkBG = Color(0xff121212);
  return ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      color: Colors.teal[700],
    ),
  );
}
