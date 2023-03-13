import 'dart:io';

import 'package:flutter/material.dart';

class ViewImage extends StatefulWidget {
  const ViewImage({Key? key}) : super(key: key);

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  List imageList = [];

  @override
  void initState() {
    // TODO: implement initState
    getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text('Virgil Gallery',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          elevation: 2.0,
          centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        ),
      body: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8
      ),
          itemCount: imageList.length,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              onTap: (){
                popImage(imageList[index]);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.file(imageList[index]),
              ),
            );
          }),

    );
  }
  getImages()async {
    final directory = Directory('storage/emulated/0/Virgil Gallery');
    imageList = directory.listSync();
    print(imageList);
  }
  popImage(filepath){
    showDialog(context: context, builder: (context)=>Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.file(filepath,
        fit: BoxFit.cover,
        ),
      ),
    ));
  }
}
