import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:virgil/constants/api_data.dart';
import 'package:virgil/models/chat_model.dart';
import 'package:virgil/models/models.dart';
import 'package:virgil/services/tts_service.dart';

class ApiServices{
  static Future<List<ModelsModel>>getModels()async {
    try{
      var response = await http.get(Uri.parse('$BASE_URL/models'),
      headers: {'Authorization': 'Bearer $API_KEY'},
      );
      Map jsonResponse = jsonDecode(response.body);
      if(jsonResponse['error']!=null){
        throw HttpException(jsonResponse['error']['message']);
      }
      //print('jsonResponse $jsonResponse');
      List temp = [];
      for (var value in jsonResponse['data']){
        temp.add(value);
        //print('temp ${value['id']}');
      }
      return ModelsModel.modelsFromSnapshot(temp);
    }catch(error){
      print("error $error");
      rethrow;
    }
  }
  //send messages fct
  static Future<List<ChatModel>>sendMessages({required String message, required String modelId})async {
    try{
      var response = await http.post(Uri.parse('$BASE_URL/completions'),
        headers: {'Authorization': 'Bearer $API_KEY',
          'Content-Type' : 'application/json',
        },
        body: jsonEncode({
          "model": modelId,
          "prompt": message,
          "max_tokens": 200
        })
      );
      Map jsonResponse = jsonDecode(response.body);
      if(jsonResponse['error']!=null){
        throw HttpException(jsonResponse['error']['message']);
      }
      List<ChatModel>chatList=[];
      if(jsonResponse['choices'].length >0){

        // print("response ${jsonResponse['choices'][0]['text']}");
        chatList = List.generate(jsonResponse['choices'].length, (index) {
         return ChatModel(
            msg: jsonResponse['choices'][index]['text'],
            chatIndex: 1);

        }
        );
        //TextToSpeech.speak(jsonResponse['choices'][0]['text']);
      }
      return chatList;
    }catch(error){
      print("error $error");
      rethrow;
    }

  }
}