import 'package:flutter/material.dart';
import 'package:virgil/screens/chat_screen.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context){
                      return const ChatScreen();
                    })
                );
              }, child: const Text('Chat Screen'))
            ],
          ),
        ),
      ),
    );
  }
}
