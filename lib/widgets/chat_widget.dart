import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virgil/proviers/chat_provides.dart';
import 'package:virgil/services/asset_manager.dart';
import 'package:virgil/widgets/text_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key, required this.msg, required this.chatIndex}) : super(key: key);

  final String msg;
  final int chatIndex;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {

    int lastIndex = -5;
    bool added = true;

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context,listen: false);
    return Column(
      children: [
        widget.chatIndex!=0?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.asset(
                  AssetManager.botImage,
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(width: 10,),
               Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(15),
                   color: Theme.of(context).colorScheme.tertiary,
                 ),
                 constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.75),
                  child:
                  widget.chatIndex==(chatProvider.chatList.length-1) &&
                  chatProvider.checkLastID != widget.chatIndex
                      ?
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 18),
                    child: DefaultTextStyle(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.normal,
                          fontSize: 16
                          ,height: 1.6),
                      child: AnimatedTextKit(
                        repeatForever: false,
                        isRepeatingAnimation: false,
                        displayFullTextOnTap: true,
                        onTap: (){
                          setState(() {
                            lastIndex = widget.chatIndex;
                            added = false;
                          });
                          chatProvider.setCheckLastID(lastIndex);
                          print(chatProvider.checkLastID);
                        },
                        onFinished: (){
                          if(added){
                            setState(() {
                              lastIndex = widget.chatIndex;
                            });
                            chatProvider.setCheckLastID(lastIndex);
                            print(chatProvider.checkLastID);
                          }
                          else{
                            print('not added');
                          }

                        },
                        totalRepeatCount: 1,
                        animatedTexts: [TyperAnimatedText(widget.msg.trim())],
                      ),
                    ),
                  )
                      :
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 18),
                    child: Text(
                      widget.msg.trim(),
                      style: TextStyle(
                        height: 1.6,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
            ],),
        )
            :
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  //color: Theme.of(context).colorScheme.onTertiary,
                  color: const Color(0xFF17e1af),
                ),
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.6),
                    child:
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 18),
                      child: TextWidget(label: widget.msg.trim(),
                        textAlign: TextAlign.left,
                        fontWeight: FontWeight.w500,
                        textHeight: 1.6,
                        fontSize: 16,
                      ),
                    ),
                  ),
              const SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Image.asset(
                  AssetManager.userImage,
                  height: 30,
                  width: 30,
                ),
              ),

            ],),
        ),
      ],
    );
  }
}

/*
Material(
          color: chatIndex ==0?Theme.of(context).colorScheme.onTertiary:Theme.of(context).colorScheme.tertiary,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
            child: chatIndex!=0?
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chatIndex!=0?
              Image.asset(
                AssetManager.botImage,
              height: 30,
                width: 30,
              ):
                const SizedBox.shrink(),
              const SizedBox(width: 10,),
              Expanded(
                  child: Container(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: DefaultTextStyle(
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.normal,fontSize: 16
                        ,height: 1.6),
                          child: AnimatedTextKit(
                            repeatForever: false,
                            isRepeatingAnimation: false,
                            displayFullTextOnTap: true,
                            stopPauseOnTap: true,
                            totalRepeatCount: -1,
                            animatedTexts: [TyperAnimatedText(msg.trim())],)),
                    ),
                  ),
              ),

                // chatIndex==0? const SizedBox.shrink():
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       mainAxisSize: MainAxisSize.min,
                //       children: const [
                //         Icon(Icons.thumb_up_alt_outlined,
                //         color: Colors.white),
                //         SizedBox(width: 5,),
                //         Icon(Icons.thumb_down_alt_outlined,
                //             color: Colors.white),
                //       ],
                //     )
            ],)
                :
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(width: 88,),
                Expanded(
                  child: TextWidget(label: msg,
                    textAlign: TextAlign.end,

                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  )
                ),
                const SizedBox(width: 10,),
                Image.asset(
                  AssetManager.userImage,
                  height: 30,
                  width: 30,
                ),

              ],),
          ),
        )
 */