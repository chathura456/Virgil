import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:virgil/providers/size_provider.dart';
import 'package:virgil/widgets/text_widget.dart';

class SizesDropdown extends StatefulWidget {
  const SizesDropdown({Key? key}) : super(key: key);

  @override
  State<SizesDropdown> createState() => _SizesDropdownState();
}

class _SizesDropdownState extends State<SizesDropdown> {
  String? currentSize;
  var sizes = ['Small (256x256)','Medium (512x512)','Large (1024x1024)'];
  var values = ['256x256','512x512','1024x1024'];
  @override
  Widget build(BuildContext context) {
    final sizesProvider = Provider.of<SizesProvider>(context,listen: false);
    currentSize = sizesProvider.currentSize;
   // print(currentSize);
    return FittedBox(
      child: DropdownButton(
          dropdownColor: Theme.of(context).colorScheme.primary,
          icon: Icon(Icons.arrow_drop_down_sharp,color: Theme.of(context).colorScheme.onPrimary,),
          items: List<DropdownMenuItem<String>>.generate(
              3,
                  (index) => DropdownMenuItem(
                  value: values[index],
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(sizes[index],
                      style: TextStyle(
                        color:Theme.of(context).colorScheme.onPrimary,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ))),
          value: currentSize,
          onChanged: (value){
            setState(() {
              //currentSize=value.toString();
              currentSize = value.toString();
            });
            sizesProvider.setCurrentSize(value.toString());
            print(currentSize);
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
              3,
                  (index) => DropdownMenuItem(
                  value: values[index],
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(sizes[index],
                      style: TextStyle(
                        color:Theme.of(context).colorScheme.onPrimary,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ))),
          value: currentSize,
          onChanged: (value){
            setState(() {
              //currentSize=value.toString();
              currentSize = value.toString();
            });
            sizesProvider.setCurrentSize(value.toString());
            print(currentSize);
          }),
    );
 */