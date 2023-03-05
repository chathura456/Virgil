import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier{
  final String key = 'theme';
  late SharedPreferences preferences;
  late bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeProvider(){
    _darkTheme = true;
  }
  toggleTheme(){
    _darkTheme = !_darkTheme;
    notifyListeners();
  }

}