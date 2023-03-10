import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:virgil/providers/chat_provides.dart';
import 'package:virgil/providers/models_provider.dart';
import 'package:virgil/providers/tts_provider.dart';
import 'package:virgil/services/asset_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:virgil/services/tts_service.dart';
import 'package:virgil/widgets/chat_widget.dart';
import 'package:virgil/widgets/text_widget.dart';
import 'package:virgil/services/services.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'image_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with AutomaticKeepAliveClientMixin{
  bool _isTyping = false;
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late ScrollController _scrollController;


  @override
  void initState() {
    // TODO: implement initState
    textEditingController = TextEditingController();
    _scrollController = ScrollController();
    focusNode = FocusNode();
    super.initState();
    if(isNotEmpty==true){
      setState(() {
        isNotEmpty == false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool isListen = false;
  bool isNotEmpty = false;
  bool micVisible = true;
  bool isSpeak = true;
  SpeechToText speechToText = SpeechToText();
  late String userInput;

  //List<ChatModel>chatList = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final modelsProvider = Provider.of<ModelsProvider>(context,listen: false);
    final chatProvider = Provider.of<ChatProvider>(context);
    final ttsProvider = Provider.of<TtsProvider>(context,listen: false);

    return Scaffold(
      backgroundColor:Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Image.asset(AssetManager.appName,height: 20),
        //title: Image.asset(AssetManager.appName,height: 20,),
        elevation: 2.0,
        // leading: Padding(
        //   padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
        //   child: Image.asset(AssetManager.openAILogo),
        // ),

        actions: [
          // IconButton(onPressed: (){
          //   themeProvider.toggleTheme();
          // },
          //   icon: Icon(themeProvider.darkTheme?Icons.dark_mode:Icons.light_mode,
          //   color: Colors.white,),
          // ),
          IconButton(onPressed: (){
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context){
                return const ImageScreen();
              })
            );
          },
            icon: const Icon(Icons.image,
              color: Colors.white,),
          ),
    IconButton(onPressed: (){
      setState(() {

        if(ttsProvider.isSpeak){
          TextToSpeech.mute();
        }else{
          TextToSpeech.initTTS();
        }
        ttsProvider.toggleSpeak();

      });
    },
    icon: Icon(ttsProvider.isSpeak?Icons.volume_up:Icons.volume_off,color: Colors.white,),),
          // Switch(
          // value: themeProvider.darkTheme,
          // onChanged: (value){
          //   themeProvider.toggleTheme();
          // }),
          IconButton(
              onPressed: () {
               Services.showModalSheet(context: context);
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                addRepaintBoundaries: false,
                addAutomaticKeepAlives: true,
                controller: _scrollController,
                itemCount: chatProvider.getChatList.isNotEmpty?chatProvider.getChatList.length:1,
                itemBuilder: (context, index) {
                  return chatProvider.getChatList.isNotEmpty?ChatWidget(
                    msg: chatProvider.getChatList[index].msg,
                    chatIndex: chatProvider.getChatList[index].chatIndex,
                  )
                  :
                  Container(
                    height: MediaQuery.of(context).size.height*0.7,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.text_snippet,
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
                          "Just enter your question or idea, and I'll do my best to assist you. \nI am always learning, so don't hesitate to ask me anything...",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondary
                                  .withOpacity(0.6),
                              height: 1.6,
                              fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                  ;
                },
              ),
            ),
            _isTyping? SpinKitThreeBounce(
                color: Theme.of(context).colorScheme.onSecondary,
                size: 18,
              ):const SizedBox.shrink(),
            const SizedBox(
              height: 15,
            ),
            Column(
              //color: Theme.of(context).colorScheme.onSurface,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Visibility(
                          maintainState: true,
                          visible: micVisible,
                          child: AvatarGlow(
                            endRadius: 35.0,
                            animate: isListen,
                            duration: const Duration(milliseconds: 2000),
                            repeat: true,
                            repeatPauseDuration: const Duration(milliseconds: 200),
                            showTwoGlows: true,
                            glowColor: Theme.of(context).colorScheme.onSecondary,
                            child: GestureDetector(
                              onTapDown: (details) async{
                                if(!isListen){
                                  var available = await speechToText.initialize();
                                  if(available){
                                    setState(() {
                                      isListen = true;
                                      speechToText.listen(
                                          onResult: (result){
                                            setState(() {
                                              userInput = result.recognizedWords;
                                              textEditingController.text =userInput;
                                              //textEditingController.text = result.recognizedWords;
                                            });
                                          }
                                      );
                                    });
                                  }
                                }

                              },
                              onTapUp: (details) async{
                                setState(() {
                                  isListen = false;
                                });
                                await speechToText.stop();
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Theme.of(context).colorScheme.onSecondary,
                                child:  Icon(isListen?Icons.mic:Icons.mic_none,color: Theme.of(context).colorScheme.primary,),
                              ),
                            ),
                          )
                      ),
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,),
                          focusNode: focusNode,
                          controller: textEditingController,
                          cursorColor:Theme.of(context).colorScheme.onPrimary,
                          onTap: (){
                            setState(() {
                              isListen = false;
                              //micVisible = false;
                              if(textEditingController.text.isEmpty){
                                  micVisible = true;
                              }else{
                                  micVisible = false;
                              }

                            });
                          },
                          onChanged: (value){
                            if(textEditingController.text.isEmpty){
                              setState(() {
                                micVisible = true;
                              });
                            }else{
                              setState(() {
                                micVisible = false;
                              });
                            }
                          },
                          onSubmitted: (value) async {
                            setState(() {
                              isNotEmpty = true;
                              micVisible=true;
                            });
                            await sentMessageIst(
                                modelsProvider: modelsProvider,
                                ttsProvider: ttsProvider,
                                chatProvider: chatProvider);

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
                              hintText: 'How can I assist you?',
                              hintStyle: TextStyle(color: Theme.of(context)
                                  .colorScheme
                                  .onSecondary
                                  .withOpacity(0.4),)
                          ),

                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            isNotEmpty = true;
                            micVisible=true;
                            isListen = false;
                          });
                          await sentMessageIst(
                              modelsProvider: modelsProvider,
                              ttsProvider: ttsProvider,
                              chatProvider: chatProvider);
                          setState(() {
                            scrollList();
                          });
                        },
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.onSecondary,
                          size: 30,
                        ),),
                    ],
                  ),

                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void scrollList() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2), curve: Curves.easeOut);
  }

  Future<void> sentMessageIst(
      {required ModelsProvider modelsProvider,
        required TtsProvider ttsProvider,
      required ChatProvider chatProvider
      }) async {
    if(_isTyping){
      Fluttertoast.showToast(msg: 'You cannot send multiple messages at a time.');
      return;
    }
    if(textEditingController.text.isEmpty){
      Fluttertoast.showToast(msg: 'Please Type a message.');
      return;
    }
    try {
      String msg1 = textEditingController.text;
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(msg: msg1);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
        count: chatProvider.chatList.length,
        ttsProvider: ttsProvider,
          msg: msg1,
          chosenModel: modelsProvider.getCurrentModel);
      setState(() {
      });
    } catch (error) {
      Fluttertoast.showToast(msg: '"error $error"');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
       scrollList();
        _isTyping = false;
      });
    }

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
