import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virgil/proviers/chat_provides.dart';
import 'package:virgil/proviers/models_provider.dart';
import 'package:virgil/proviers/theme_provider.dart';
import 'package:virgil/services/asset_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:virgil/widgets/chat_widget.dart';
import 'package:virgil/widgets/text_widget.dart';
import 'package:virgil/services/services.dart';
import 'package:avatar_glow/avatar_glow.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
  bool micVisible = true;

  //List<ChatModel>chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context,listen: false);

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
          IconButton(onPressed: (){
            themeProvider.toggleTheme();
          }, icon: Icon(themeProvider.darkTheme?Icons.dark_mode:Icons.light_mode,color: Colors.white,),
          ),
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
            Flexible(
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: chatProvider.getChatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      msg: chatProvider.getChatList[index].msg,
                      chatIndex: chatProvider.getChatList[index].chatIndex,
                    );
                  }),
            ),
            if (_isTyping) ...[
              SpinKitThreeBounce(
                color: Theme.of(context).colorScheme.onSecondary,
                size: 18,
              )
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              color: Theme.of(context).colorScheme.tertiary,
              child: Padding(
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
                            repeatPauseDuration: const Duration(milliseconds: 100),
                            showTwoGlows: true,
                            glowColor: Theme.of(context).colorScheme.onSecondary,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Theme.of(context).colorScheme.onSecondary,
                              child: IconButton(
                                icon: Icon(Icons.mic,color: Theme.of(context).colorScheme.primary,),
                                onPressed: (){
                                  setState(() {
                                    isListen = !isListen;
                                  });

                                },
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                            )
                        ),
                     ),


                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,),
                        focusNode: focusNode,
                        controller: textEditingController,
                        cursorColor:Theme.of(context).colorScheme.onPrimary,
                        onTap: (){
                          setState(() {
                            micVisible = false;
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
                          await sentMessageIst(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider);
                          setState(() {
                            micVisible=true;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)
                          ),
                            hintText: 'How can I help you',
                            hintStyle: const TextStyle(color: Colors.grey)
    ),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await sentMessageIst(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider);
                          setState(() {
                            micVisible=true;
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
            )
          ],
        ),
      ),
    );
  }

  void scrollList() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.easeOut);
  }

  Future<void> sentMessageIst(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if(_isTyping){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: TextWidget(
              label: 'You cannot send multiple messages at a time. ',
            ),
            backgroundColor: Colors.red,
          ));
      return;
    }
    if(textEditingController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
        content: TextWidget(
          label: 'Please type a message',
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
    try {
      String msg1 = textEditingController.text;
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(msg: msg1);
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg1,
          chosenModel: modelsProvider.getCurrentModel);
      // chatList.addAll(await ApiServices.sendMessages(
      //     message: textEditingController.text,
      //     modelId: modelsProvider.getCurrentModel));
      setState(() {
        scrollList();
      });
    } catch (error) {
      print('error : $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isTyping = false;
        scrollList();
      });
    }
  }
}
