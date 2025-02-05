import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.deepPurple,
      secondary: Colors.purpleAccent,
      surface: Colors.grey[900]!,
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.lightBlueAccent,
      surface: Colors.grey[200]!,
    ),
  );
}


  final Map<String, Color> typeColors = {
    "normal": Colors.grey,
    "fire": Colors.red,
    "water": Colors.blue,
    "electric": Colors.yellow,
    "grass": Colors.green,
    "ice": Colors.cyan,
    "fighting": Colors.orange,
    "poison": Colors.purple,
    "ground": Colors.brown,
    "flying": Colors.lightBlueAccent,
    "psychic": Colors.purpleAccent,
    "bug": Colors.lightGreen,
    "rock": const Color.fromARGB(255, 61, 41, 34),
    "ghost": Colors.deepPurple,
    "dragon": Colors.indigo,
    "dark": Colors.black,
    "steel": Colors.blueGrey,
    "fairy": Colors.pinkAccent,
  };
