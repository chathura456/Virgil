
import 'dart:io';
import 'dart:typed_data';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
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
import 'package:virgil/widgets/image_widget.dart';

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
  bool isCompleted = false;
  SpeechToText speechToText = SpeechToText();
  late String imageUrl;
  late Image myImage;
  double loadPrc = 0.0;

  ScreenshotController screenshotController = ScreenshotController();

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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final sizesProvider = Provider.of<SizesProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Image.asset(AssetManager.appName, height: 20),
        elevation: 2.0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return const ChatScreen();
              }));
            },
            icon: const Icon(
              Icons.text_snippet,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              themeProvider.toggleTheme();
            },
            icon: Icon(
              themeProvider.darkTheme ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ),
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
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isLoaded
                            ? Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        // changes position of shadow
                                      ),
                                    ]),
                                    child: isLoaded?
                                        Container(
                                            width:  MediaQuery.of(context).size.width * 0.8,
                                          height:  MediaQuery.of(context).size.width * 0.8,
                                            child: Screenshot(
                                              controller: screenshotController,
                                              child: Image.network(
                                                imageUrl,
                                                // When the image finishes loading, set the _imageLoaded variable to true
                                                loadingBuilder: (BuildContext context, Widget child,
                                                    ImageChunkEvent? loadingProgress) {
                                                  int? expSize;
                                                  int? downSize;
                                                  expSize = loadingProgress?.expectedTotalBytes;
                                                  downSize = loadingProgress?.cumulativeBytesLoaded;
                                                  if (loadingProgress == null && mounted) {
                                                    return child;
                                                  }
                                                  loadPrc = (downSize! / expSize!).toDouble() * 100;
                                                  var loadingPerString = loadPrc.toStringAsFixed(2);
                                                  return Container(
                                                    color: Theme.of(context).colorScheme.background,
                                                    height: MediaQuery.of(context).size.width * 0.8,
                                                    width: MediaQuery.of(context).size.width * 0.8,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          '$loadingPerString%',
                                                          style: TextStyle(
                                                            color: Theme.of(context).colorScheme.onSecondary,
                                                            fontSize: 40,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        CircularProgressIndicator(
                                                          value: loadPrc / 100,
                                                          //valueColor: Animation.fromValueListenable(listenable);
                                                          semanticsLabel: '$loadingPerString%',
                                                          strokeWidth: 15,
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                        ),
                                                      ],
                                                    ),
                                                  );

                                                },
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                        )
                                    // Column(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.center,
                                    //   children: [
                                    //     //const SizedBox(height: 25,),
                                    //    myImage = Image.network(
                                    //             imageUrl,
                                    //             fit: BoxFit.cover,
                                    //             loadingBuilder: (context, child,
                                    //                 loadingProgress) {
                                    //               int? expSize;
                                    //               int? downSize;
                                    //               expSize = loadingProgress
                                    //                   ?.expectedTotalBytes;
                                    //               print(loadPrc);
                                    //               downSize = loadingProgress
                                    //                   ?.cumulativeBytesLoaded;
                                    //               if (expSize != null &&
                                    //                   downSize != null) {
                                    //                 loadPrc =
                                    //                     (downSize / expSize)
                                    //                             .toDouble() *
                                    //                         100;
                                    //                 var loadingPerString =
                                    //                     loadPrc
                                    //                         .toStringAsFixed(2);
                                    //
                                    //                 return SizedBox(
                                    //                   height:
                                    //                       MediaQuery.of(context)
                                    //                               .size
                                    //                               .height *
                                    //                           0.5,
                                    //                   width:
                                    //                       MediaQuery.of(context)
                                    //                               .size
                                    //                               .width *
                                    //                           0.7,
                                    //                   child: Column(
                                    //                     mainAxisAlignment:
                                    //                         MainAxisAlignment
                                    //                             .center,
                                    //                     children: [
                                    //                       Text(
                                    //                         '$loadingPerString%',
                                    //                         style: TextStyle(
                                    //                           color: Theme.of(
                                    //                                   context)
                                    //                               .colorScheme
                                    //                               .onSecondary,
                                    //                           fontSize: 40,
                                    //                         ),
                                    //                       ),
                                    //                       const SizedBox(
                                    //                         height: 10,
                                    //                       ),
                                    //                       Container(
                                    //                         width: MediaQuery.of(
                                    //                                     context)
                                    //                                 .size
                                    //                                 .width *
                                    //                             0.5,
                                    //                         height: MediaQuery.of(
                                    //                                     context)
                                    //                                 .size
                                    //                                 .width *
                                    //                             0.5,
                                    //                         color: Theme.of(
                                    //                             context)
                                    //                             .colorScheme
                                    //                             .background,
                                    //                         child:
                                    //                             CircularProgressIndicator(
                                    //                           value:
                                    //                               loadPrc / 100,
                                    //                           //valueColor: Animation.fromValueListenable(listenable);
                                    //                           semanticsLabel:
                                    //                               '$loadingPerString%',
                                    //                           // backgroundColor:
                                    //                           //     Theme.of(
                                    //                           //             context)
                                    //                           //         .colorScheme
                                    //                           //         .background,
                                    //                           strokeWidth: 15,
                                    //                           color: Theme.of(
                                    //                                   context)
                                    //                               .colorScheme
                                    //                               .onSecondary,
                                    //                         ),
                                    //                       )
                                    //                     ],
                                    //                   ),
                                    //                 );
                                    //               }
                                    //               else {
                                    //                 isCompleted = true;
                                    //                 return child;
                                    //               }
                                    //             },
                                    //           ),
                                    //
                                    //   ],
                                    // )
                                        :
                                    const SizedBox.shrink(),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.all(14),
                                              backgroundColor: newColor,
                                            ),
                                            label: const Text(
                                              'Download',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                            icon: const Icon(
                                              Icons.download,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () async{
                                            await shareImage();
                                            Fluttertoast.showToast(msg: 'Images Share Success');

                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(14),
                                            backgroundColor: newColor,
                                          ),
                                          label: const Text(
                                            'Share',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          icon: const Icon(
                                            Icons.share,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),


                                ],
                              )
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    (isSubmitted)
                                        ? SpinKitCircle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                            size: 68,
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.image,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary
                                                    .withOpacity(0.4),
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.3,
                                              ),
                                              Text(
                                                'Enter a hint or description to generate an image that fits your idea.',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondary
                                                        .withOpacity(0.4),
                                                    fontSize: 18),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          )
                                  ],
                                ),
                              ),

                        // Container(
                        //   decoration: BoxDecoration(boxShadow: [
                        //     BoxShadow(
                        //       color: Colors.grey.withOpacity(0.5),
                        //       spreadRadius: 2,
                        //       blurRadius: 2,
                        //       // changes position of shadow
                        //     ),
                        //   ]),
                        //   clipBehavior: Clip.antiAlias,
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       //const SizedBox(height: 25,),
                        //       Image.asset(
                        //         AssetManager.userImage,
                        //         fit: BoxFit.cover,
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(height: 25,),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: ElevatedButton.icon(
                        //
                        //         onPressed: () {},
                        //         style: ElevatedButton.styleFrom(
                        //           padding: const EdgeInsets.all(14),
                        //           backgroundColor: newColor,
                        //         ),
                        //         label: const Text(
                        //           'Download',
                        //           style: TextStyle(color: Colors.white
                        //               ,fontSize: 16),
                        //         ),
                        //         icon: const Icon(Icons.download,
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //     const SizedBox(width: 15,),
                        //     ElevatedButton.icon(
                        //       onPressed: () {},
                        //       style: ElevatedButton.styleFrom(
                        //         padding: const EdgeInsets.all(14),
                        //         backgroundColor: newColor,
                        //       ),
                        //       label: const Text(
                        //         'Share',
                        //         style: TextStyle(color: Colors.white
                        //             ,fontSize: 16),
                        //       ),
                        //       icon: const Icon(Icons.share,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  );
                  //color: Colors.orange,
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
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            //constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height*0.5),

            child: Wrap(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              focusNode: focusNode,
                              controller: textEditingController,
                              cursorColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              onTap: () {},
                              onChanged: (value) {
                                setState(() {
                                  isSubmitted = false;
                                  isCompleted = false;
                                });
                              },
                              onSubmitted: (value) async {
                                setState(() {
                                  isLoaded = false;
                                  isSubmitted = true;
                                  isButtonShow = false;

                                });
                                if (textEditingController.text.isNotEmpty) {
                                  imageUrl = await ApiServices.generateImage(
                                      textEditingController.text,
                                      1,
                                      sizesProvider.currentSize);
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
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: 'Enter your prompt...',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey)),
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                        width: 250,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: newColor,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () async {
                            setState(() {
                              isLoaded = false;
                              isSubmitted = true;
                              isButtonShow = false;
                            });
                            if (textEditingController.text.isNotEmpty) {
                              imageUrl = await ApiServices.generateImage(
                                  textEditingController.text,
                                  1,
                                  sizesProvider.currentSize);
                              setState(() {
                                textEditingController.clear();
                                isLoaded = true;
                                isButtonShow = true;
                              });
                            }
                          },
                          child: isButtonShow
                              ? const Text(
                                  'Generate AI Image',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              : Row(
                                  children: const [
                                    SpinKitCircle(
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    Text(
                                      'Please Wait',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  ],
                                ),
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  shareImage()async{
    await screenshotController.capture(
      delay: Duration(microseconds: 100),
      pixelRatio: 1.0
    ).then((Uint8List? img) async {
      if(img!=null){
        final directory = (await getApplicationDocumentsDirectory()).path;
        const fileName = 'share.png';
        final imagePath = await File('$directory/$fileName').create();
        await imagePath.writeAsBytes(img);

        Share.shareFiles([imagePath.path],text: 'Virgil - AI Image Generator');
      }else{
        print('Failed to take a screenshot');
      }
    });
  }
}
