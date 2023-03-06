import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virgil/constants/theme_data.dart';
import 'package:virgil/proviers/theme_provider.dart';
import 'package:virgil/widgets/drop_down.dart';
import 'package:virgil/widgets/text_widget.dart';

class Services{
  static Future<void>showModalSheet({required context})async{
    final themeProvider = Provider.of<ThemeProvider>(context,listen: false);
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        //backgroundColor: Theme.of(context).colorScheme.tertiary,
        context: context,
        builder: (context){
      return SizedBox(
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Flexible(child: TextWidget(label: 'Chosen Model :',fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )),
                    const Flexible(
                        flex: 2,
                        child: ModelsDropdownWidget())
                  ],
                ),
              ),
              const SizedBox(height: 1,),

              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Row(
                  children: [
                    Text('Dark Mode',style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                    ),),
                    const SizedBox(width: 20,),
                    // SwitchListTile(value: value, onChanged: onChanged),
                Switch.adaptive(
                  thumbColor: MaterialStateColor.resolveWith((states) => Theme.of(context).colorScheme.onPrimary,),
                          value: themeProvider.darkTheme,
                          onChanged: (value){
                        themeProvider.toggleTheme();
                      }),

                  ],
                ),
              )
            ],
          )
      );
    });
  }
}
