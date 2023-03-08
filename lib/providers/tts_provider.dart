import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virgil/services/tts_service.dart';

class TtsProvider with ChangeNotifier{
  final String key = 'tts';
  late SharedPreferences _preferences;
  late bool _isSpeak;
  bool get isSpeak => _isSpeak;

  TtsProvider(){
    _isSpeak = true;
    _loadFromPrefs();
  }
  toggleSpeak(){
    _isSpeak = !_isSpeak;
    _saveToPrefs();
    notifyListeners();
  }
  _initPrefs()async{
    _preferences = await SharedPreferences.getInstance();
  }
  _loadFromPrefs()async{
    await _initPrefs();
    _isSpeak = _preferences.getBool(key) ?? true;
    notifyListeners();
  }
  _saveToPrefs()async{
    await _initPrefs();
    _preferences.setBool(key, _isSpeak);
  }
}