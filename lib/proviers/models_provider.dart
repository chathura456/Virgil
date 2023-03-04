import 'package:flutter/cupertino.dart';
import 'package:virgil/models/models.dart';
import 'package:virgil/services/api_services.dart';

class ModelsProvider with ChangeNotifier{
  String currentModel = 'text-davinci-003';

  String get getCurrentModel{
    return currentModel;
  }
  void setCurrentModel (String newModel){
    currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];

  List <ModelsModel> get getModelsList {
    return modelsList;
  }
  Future<List<ModelsModel>> getAllModels()async{
    modelsList = await ApiServices.getModels();
    return modelsList;
  }
}