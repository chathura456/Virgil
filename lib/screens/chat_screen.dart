import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virgil/constants/my_constansts.dart';
import 'package:virgil/models/chat_model.dart';
import 'package:virgil/proviers/chat_provides.dart';
import 'package:virgil/proviers/models_provider.dart';
import 'package:virgil/services/api_services.dart';
import 'package:virgil/services/asset_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:virgil/widgets/chat_widget.dart';
import 'package:virgil/widgets/text_widget.dart';
import 'package:virgil/services/services.dart';

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

  //List<ChatModel>chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(AssetManager.appName,height: 20,),
        elevation: 2.0,
        // leading: Padding(
        //   padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
        //   child: Image.asset(AssetManager.openAILogo),
        // ),
        actions: [
          IconButton(
              onPressed: () async {
                await Services.showModalSheet(context: context);
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
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              )
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        focusNode: focusNode,
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sentMessageIst(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider);
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: 'How can I help you',
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await sentMessageIst(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider);
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ),
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
