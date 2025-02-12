import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      // Background
      surface: Colors.white,
      // Text
      primary: Colors.black,
      // HintText
      secondary: Color.fromRGBO(32, 32, 32, 1),
      // TextFormField Background
      inversePrimary: Color.fromRGBO(217, 217, 217, 1),
    ));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      // Background
      surface: Colors.black,
      // Text
      primary: Colors.white,
      //HintText
      secondary: Color.fromRGBO(223, 223, 223, 1),
      // TextFormField Background
      inversePrimary: Color.fromRGBO(38, 38, 38, 1),
    ));

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
