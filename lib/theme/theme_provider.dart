import 'package:flutter/material.dart';
import 'theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = AppThemes.darkTheme;

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData = (_themeData == AppThemes.darkTheme)
        ? AppThemes.lightTheme
        : AppThemes.darkTheme;
    notifyListeners();
  }
}
