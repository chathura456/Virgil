import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:virgil/constants/theme_data.dart';
import 'package:virgil/providers/image_count_provider.dart';
import 'package:virgil/providers/theme_provider.dart';
import 'package:virgil/screens/chat_screen.dart';
import 'package:virgil/services/asset_manager.dart';
import 'package:virgil/services/services.dart';
import 'package:virgil/widgets/image_count_dropdown.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);


  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late FocusNode focusNode;
  late TextEditingController textEditingController;
  bool _isTyping = false;
  bool isListen = false;
  bool micVisible = true;
  SpeechToText speechToText = SpeechToText();
  late String userInput;

  @override
  void initState() {
    focusNode = FocusNode();
    textEditingController = TextEditingController();
    const ImageCountDropdown();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context,listen: false);
    return Scaffold(
      backgroundColor:Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Image.asset(AssetManager.appName,height: 20),
        elevation: 2.0,

        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context){
                  return const ChatScreen();
                })
            );
          },
            icon: const Icon(Icons.text_snippet,
              color: Colors.white,),
          ),
          IconButton(onPressed: (){
            themeProvider.toggleTheme();
          },
            icon: Icon(themeProvider.darkTheme?Icons.dark_mode:Icons.light_mode,
            color: Colors.white,),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  Services.showImageOptions(context: context);
                });

              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ))
        ],
      ),
      body:    Column(
              children: [
                Expanded(
                  child: Container(
                      //color: Colors.orange,
                    ),

                ),

                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)
                    ),
                  ),
                      //constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height*0.5),

                          child: Wrap(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 25,),
                                        Expanded(
                                          child: TextField(
                                            textAlignVertical: TextAlignVertical.center,
                                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,),
                                            focusNode: focusNode,
                                            controller: textEditingController,
                                            cursorColor:Theme.of(context).colorScheme.onPrimary,
                                            onTap: (){
                                            },
                                            onChanged: (value){
                                              if(textEditingController.text.isEmpty){
                                              }else{
                                              }
                                            },
                                            onSubmitted: (value) async {

                                            },
                                            decoration: InputDecoration(
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary,),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary,),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                hintText: 'Enter your prompt...',
                                                hintStyle: const TextStyle(color: Colors.grey)
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 25,),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15,),
                                  SizedBox(
                                    width: 250,
                                    height: 48,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: newColor,
                                          shape: const StadiumBorder(),
                                        ),
                                        onPressed: (){},
                                        child: const Text(
                                          'Generate AI Image',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20
                                          ),
                                        )),
                                  ),
                                  const SizedBox(height: 30,),
                                ],
                              ),
                            ],
                          ),
                    ),


              ],
            ),



    );
  }
}
