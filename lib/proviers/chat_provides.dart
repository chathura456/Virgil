import 'package:flutter/material.dart';
import 'package:virgil/models/chat_model.dart';
import 'package:virgil/proviers/models_provider.dart';
import 'package:virgil/proviers/tts_provider.dart';
import 'package:virgil/services/api_services.dart';

class ChatProvider with ChangeNotifier{
  List<ChatModel> chatList = [];
  int lastID = -1;
  List<ChatModel> get getChatList{
    return chatList;
  }
  void addUserMessage({
    required String msg
}){
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  void setCheckLastID(int id){
    lastID = id;
    notifyListeners();
  }
  int get checkLastID{
    return lastID;
  }

  Future<void>sendMessageAndGetAnswers({required String msg,
    required String chosenModel,required TtsProvider ttsProvider,required int count
  }
      )
  async{
    if(chosenModel.toLowerCase().startsWith('gpt')){
      var reply = await ApiServices.sendMessagesChatGPT(message: msg, modelId: chosenModel,ttsProvider: ttsProvider,count: count);
      chatList.addAll(reply);
    }
    else{
      var reply = await ApiServices.sendMessages(message: msg, modelId: chosenModel,ttsProvider: ttsProvider,count: count);
      chatList.addAll(reply);
    }
    notifyListeners();
  }
}