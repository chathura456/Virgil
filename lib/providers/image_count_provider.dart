import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageCountProvider with ChangeNotifier{
  int _currentNo = 1;

  final String key1 = 'count';
  late SharedPreferences _preferences2;

  int get currentNo => _currentNo;

  ImageCountProvider() {

   _loadFromPrefs2();

  }

  void setCurrentNo (int newNo){
    _currentNo  = newNo;
    _saveToPrefs2(newNo);
    notifyListeners();
  }
  _initPrefs2()async{
    _preferences2 = await SharedPreferences.getInstance();
  }
  _loadFromPrefs2()async{
    await _initPrefs2();
    _currentNo = _preferences2.getInt(key1) ?? 1;

    notifyListeners();
  }

  _saveToPrefs2(int currentNo)async{
    await _initPrefs2();
    _currentNo = currentNo;
    _preferences2.setInt(key1, currentNo);
  }

  Future getCurrentNo()async{
    _preferences2 = await _initPrefs2();
    _currentNo = _preferences2.getInt(key1) ?? 1;

  }

}