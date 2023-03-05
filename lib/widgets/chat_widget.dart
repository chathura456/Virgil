import 'package:flutter/material.dart';
import 'package:virgil/constants/theme_data.dart';
import 'package:virgil/services/asset_manager.dart';
import 'package:virgil/widgets/text_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class ChatWidget extends StatelessWidget {
  const ChatWidget({Key? key, required this.msg, required this.chatIndex}) : super(key: key);

  final String msg;
  final int chatIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex ==0?Theme.of(context).colorScheme.onTertiary:Theme.of(context).colorScheme.tertiary,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
            child: chatIndex!=0?Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chatIndex!=0?
              Image.asset(
                AssetManager.botImage,
              height: 30,
                width: 30,
              ):const SizedBox.shrink(),
              const SizedBox(width: 10,),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18),
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
                          totalRepeatCount: 0,
                          animatedTexts: [TyperAnimatedText(msg.trim())],)),
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
      ],
    );
  }
}
