import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier{
  final String key = 'theme';
  late SharedPreferences _preferences;
  late bool _darkTheme;
  bool get darkTheme => _darkTheme;

  ThemeProvider(){
    _darkTheme = false;
    _loadFromPrefs();
  }
  toggleTheme(){
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }
  _initPrefs()async{
    _preferences = await SharedPreferences.getInstance();
  }
  _loadFromPrefs()async{
    await _initPrefs();
    _darkTheme = _preferences.getBool(key) ?? true;
    notifyListeners();
  }
  _saveToPrefs()async{
    await _initPrefs();
    _preferences.setBool(key, _darkTheme);
  }

}