import 'package:flutter/material.dart';
import 'package:virgil/constants/my_constansts.dart';
import 'package:virgil/widgets/drop_down.dart';
import 'package:virgil/widgets/text_widget.dart';

class Services{
  static Future<void>showModalSheet({required context})async{
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        backgroundColor: myBackgroundColor,
        context: context,
        builder: (context){
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Flexible(child: TextWidget(label: 'chosen model :',fontSize: 16,)),
            Flexible(
                flex: 2,
                child: ModelsDropdownWidget())
          ],
        ),
      );
    });
  }
}