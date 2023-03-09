import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:virgil/constants/theme_data.dart';
import 'package:virgil/providers/image_count_provider.dart';
import 'package:virgil/providers/size_provider.dart';
import 'package:virgil/providers/theme_provider.dart';
import 'package:virgil/screens/chat_screen.dart';
import 'package:virgil/services/api_services.dart';
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
  bool isLoaded = false;
  bool isListen = false;
  bool micVisible = true;
  bool isSubmitted = false;
  bool isButtonShow = true;
  SpeechToText speechToText = SpeechToText();
  late String imageUrl;

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
    final sizesProvider = Provider.of<SizesProvider>(context,listen: false);
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
                  child: ListView.builder(
                    itemCount: 1,
                      itemBuilder: (context,index){
                    return SizedBox(
                          width: MediaQuery.of(context).size.width*0.7,
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isLoaded?Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                         // changes position of shadow
                                      ),
                                    ]
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //const SizedBox(height: 25,),
                                      isLoaded?Image.network(imageUrl,fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress){
                                        int? expSize;
                                        int? downSize;
                                        expSize = loadingProgress?.expectedTotalBytes;
                                        downSize = loadingProgress?.cumulativeBytesLoaded;
                                        if(expSize!=null&& downSize!=null){
                                          var loadPrc = (downSize/expSize).toDouble()*100;
                                          var loadingPerString = loadPrc.toStringAsFixed(2);

                                          return SizedBox(
                                            height: MediaQuery.of(context).size.height*0.5,
                                            width: MediaQuery.of(context).size.width*0.7,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('$loadingPerString%',
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.onSecondary,
                                                    fontSize: 40,
                                                  ),
                                                ),
                                                const SizedBox(height: 10,),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.5,
                                                  height: MediaQuery.of(context).size.width*0.5,
                                                  child: CircularProgressIndicator(
                                                    value: loadPrc/100,
                                                    //valueColor: Animation.fromValueListenable(listenable);
                                                    semanticsLabel: '$loadingPerString%',
                                                    backgroundColor: Theme.of(context).colorScheme.background,
                                                    strokeWidth: 15,
                                                    color: Theme.of(context).colorScheme.onSecondary,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }else{
                                          return child;
                                        }

                                      },):const SizedBox.shrink(),
                                    ],
                                  ),
                                ):
                                SizedBox(
                                  height: MediaQuery.of(context).size.height*0.5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      (isSubmitted)?
                                      SpinKitCircle(
                                        color: Theme.of(context).colorScheme.onSecondary,
                                        size: 68,
                                      ):
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.image,
                                              color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),
                                              size: MediaQuery.of(context).size.height*0.3,
                                            ),
                                            Text('Enter a hint or description to generate an image that fits your idea.',
                                              style: TextStyle(color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),
                                                fontSize: 18
                                              ),
                                              textAlign: TextAlign.center,

                                            )
                                          ],
                                        )  
                                    ],
                                  ),
                                ),
                                
                            
                                


                              ],
                            ),
                          ),
                            //color: Colors.orange,
                          );
                  }),
                  // child: SizedBox(
                  //   width: MediaQuery.of(context).size.width*0.7,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Container(
                  //           child:  isLoaded?
                  //           Image.network(imageUrl):
                  //           SpinKitThreeBounce(
                  //             color: Theme.of(context).colorScheme.onSecondary,
                  //             size: 18,
                  //           ),
                  //         ),
                  //
                  //
                  //       ],
                  //     ),
                  //   ),
                  //     //color: Colors.orange,
                  //   ),

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
                                              setState(() {
                                                isSubmitted = false;
                                              });
                                            },
                                            onSubmitted: (value) async {
                                              setState(() {
                                                isLoaded = false;
                                                isSubmitted = true;
                                                isButtonShow = false;
                                              });
                                              if(textEditingController.text.isNotEmpty){
                                                imageUrl = await ApiServices.generateImage(textEditingController.text, 1, sizesProvider.currentSize);
                                                setState(() {
                                                  textEditingController.clear();
                                                  isLoaded = true;
                                                  isButtonShow = true;
                                                });
                                              }

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
                                    child:
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: newColor,
                                          shape: const StadiumBorder(),
                                        ),
                                        onPressed: ()async{
                                          setState(() {
                                            isLoaded = false;
                                            isSubmitted = true;
                                            isButtonShow = false;
                                          });
                                          if(textEditingController.text.isNotEmpty){
                                            imageUrl = await ApiServices.generateImage(textEditingController.text, 1, sizesProvider.currentSize);
                                            setState(() {
                                              textEditingController.clear();
                                              isLoaded = true;
                                              isButtonShow = true;
                                            });
                                          }


                                        },
                                        child: isButtonShow?const Text(
                                          'Generate AI Image',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20
                                          ),
                                        ):
    Row(
      children: const [
        SpinKitCircle(
        color: Colors.white,
        size: 20,
        ),
        Text(
          'Please Wait',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20
          ),
        )
      ],
    ),
                                    )
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
