import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SizesProvider with ChangeNotifier{

  String _currentSize = '512x512';

final String key1 = 'size';
late SharedPreferences _preferences1;

  String get currentSize => _currentSize;

  SizesProvider(){
    _loadFromPrefs1();
  }

  void setCurrentSize (String newSize){
    _currentSize  = newSize;
    _saveToPrefs1(newSize);
    notifyListeners();
  }
  _initPrefs1()async{
    _preferences1 = await SharedPreferences.getInstance();
  }
  _loadFromPrefs1()async{
    await _initPrefs1();
    _currentSize = _preferences1.getString(key1) ?? '512x512';

    notifyListeners();
  }
  _saveToPrefs1(String currentSize)async{
    await _initPrefs1();
    _currentSize = currentSize;
    _preferences1.setString(key1, currentSize);
  }

}