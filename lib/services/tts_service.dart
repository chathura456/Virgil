import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech{
  static FlutterTts tts = FlutterTts();

  static initTTS(){
    tts.setLanguage('en-US');
  }

  static mute(){
    tts.pause();
  }
  static speak(String text) async{
    await tts.awaitSpeakCompletion(true);
    tts.speak(text);
  }
}