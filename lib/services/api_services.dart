import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:virgil/constants/api_data.dart';
import 'package:virgil/models/chat_model.dart';
import 'package:virgil/models/models.dart';
import 'package:virgil/proviers/tts_provider.dart';
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
  //send messages using chatGPT api
  static Future<List<ChatModel>>sendMessagesChatGPT({required String message, required String modelId,required TtsProvider ttsProvider})async {
    try{
      var response = await http.post(Uri.parse('$BASE_URL/chat/completions'),
        headers: {'Authorization': 'Bearer $API_KEY',
          'Content-Type' : 'application/json',
        },
        body: jsonEncode({
          "model": modelId,
          "messages": [
            {"role": "user",
            "content": message
            }
          ]
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
            msg: jsonResponse['choices'][index]['message']['content'],

            chatIndex: 1);

        }
        );
        if(ttsProvider.isSpeak){
          TextToSpeech.speak(jsonResponse['choices'][0]['message']['content']);
        }

      }
      return chatList;
    }catch(error){
      print("error $error");
      rethrow;
    }

  }

  //send message using normal api
  static Future<List<ChatModel>>sendMessages({required String message, required String modelId,required TtsProvider ttsProvider})async {
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
        if(ttsProvider.isSpeak){
          TextToSpeech.speak(jsonResponse['choices'][0]['text']);
        }else{
          TextToSpeech.mute();
        }
      }
      return chatList;
    }catch(error){
      print("error $error");
      rethrow;
    }

  }
}

/*

 */