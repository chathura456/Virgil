import 'package:flutter/material.dart';
import 'package:virgil/models/chat_model.dart';
import 'package:virgil/proviers/models_provider.dart';
import 'package:virgil/services/api_services.dart';

class ChatProvider with ChangeNotifier{
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList{
    return chatList;
  }
  void addUserMessage({
    required String msg
}){
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void>sendMessageAndGetAnswers({required String msg,required String chosenModel})async{
    chatList.addAll(await ApiServices.sendMessages(message: msg, modelId: chosenModel));
    notifyListeners();
  }
}