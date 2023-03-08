import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virgil/providers/image_count_provider.dart';
import 'package:virgil/widgets/text_widget.dart';

class ImageCountDropdown extends StatefulWidget {
  const ImageCountDropdown({Key? key}) : super(key: key);

  @override
  State<ImageCountDropdown> createState() => _ImageCountDropdownState();
}


class _ImageCountDropdownState extends State<ImageCountDropdown> {
  late ImageCountProvider countProvider;
  int? currentCount ;
  var count = [1,2,3,4,5,6,7,8,9,10];
  @override
  Widget build(BuildContext context) {
    countProvider = Provider.of<ImageCountProvider>(context);
    currentCount = countProvider.currentNo;
    print(currentCount);
    return FittedBox(
      child: DropdownButton(
          dropdownColor: Theme.of(context).colorScheme.primary,
          icon: Icon(Icons.arrow_drop_down_sharp,color: Theme.of(context).colorScheme.onPrimary,),
          items: List<DropdownMenuItem<String>>.generate(
              10,
                  (index) => DropdownMenuItem(
                  value: count[index].toString(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(count[index].toString(),
                      style: TextStyle(
                        color:Theme.of(context).colorScheme.onPrimary,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ))),
          value: currentCount.toString(),
          onChanged: (value){
            setState(() {
              currentCount = int.parse(value.toString());
              countProvider.setCurrentNo(currentCount!);
            });
            print(currentCount);
          }),
    );
  }
}

/*
FittedBox(
      child: DropdownButton(
          dropdownColor: Theme.of(context).colorScheme.primary,
          icon: Icon(Icons.arrow_drop_down_sharp,color: Theme.of(context).colorScheme.onPrimary,),
          items: List<DropdownMenuItem<String>>.generate(
              10,
                  (index) => DropdownMenuItem(
                  value: count[index].toString(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(count[index].toString(),
                      style: TextStyle(
                        color:Theme.of(context).colorScheme.onPrimary,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ))),
          value: currentCount.toString(),
          onChanged: (value){
            setState(() {
              currentCount = int.parse(value.toString());
              countProvider.setCurrentNo(currentCount!);
            });

            print(currentCount);
          }),
    );
 */