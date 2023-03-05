import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:virgil/constants/theme_data.dart';
import 'package:virgil/services/api_services.dart';
import 'package:virgil/widgets/text_widget.dart';
import 'package:virgil/proviers/models_provider.dart';

class ModelsDropdownWidget extends StatefulWidget {
  const ModelsDropdownWidget({Key? key}) : super(key: key);

  @override
  State<ModelsDropdownWidget> createState() => _ModelsDropdownWidgetState();
}

class _ModelsDropdownWidgetState extends State<ModelsDropdownWidget> {
  String? currentModel;
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context,listen: false);
    currentModel = modelsProvider.getCurrentModel;
    return FutureBuilder(
      future: modelsProvider.getAllModels(),
        builder: (context, snapshots){
        if(snapshots.hasError){
          return Center(
            child: TextWidget(label: snapshots.hasError.toString(),),
          );
        }
        return snapshots.data == null || snapshots.data!.isEmpty? FittedBox(
          child: SpinKitThreeBounce(
            color: Theme.of(context).colorScheme.onPrimary,
            size: 18,
          ),
        )
            :
        FittedBox(
          child: DropdownButton(
              dropdownColor: Theme.of(context).colorScheme.primary,
              icon: Icon(Icons.arrow_drop_down_sharp,color: Theme.of(context).colorScheme.onPrimary,),
              items: List<DropdownMenuItem<String>>.generate(
                  snapshots.data!.length,
                      (index) => DropdownMenuItem(
                      value: snapshots.data![index].id,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                          child: Text(snapshots.data![index].id,
                          style: TextStyle(
                            color:Theme.of(context).colorScheme.onPrimary,
                            fontSize: 15,
                          ),
                            textAlign: TextAlign.center,
                          ),
                      ))),
              value: currentModel,
              onChanged: (value){
                setState(() {
                  currentModel=value.toString();
                });
                modelsProvider.setCurrentModel(value.toString());
              }),
        );
        },

    );
  }
}

/*

* */