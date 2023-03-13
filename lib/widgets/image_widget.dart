import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'package:virgil/constants/theme_data.dart';

class ImageWidget extends StatefulWidget {
  const ImageWidget({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;


  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Container(

    decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
                    boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 0,
                    // changes position of shadow
                  ),
                ]),
      child: Wrap(
          children: [
            Screenshot(
              controller: screenshotController,
              child: Image.network(
                widget.imageUrl,
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
                  var loadPrc = (downSize! / expSize!).toDouble() * 100;
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
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      downloadImg();
                    },
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
                  width: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () async{
                    await shareImage();
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
          ]
      ),
    );
  }
  downloadImg() async {
    var result = await Permission.storage.request();
    if(result.isGranted){
      const folderName = 'Virgil Gallery';
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final path = Directory('storage/emulated/0/$folderName');
      if(await path.exists()){
        await screenshotController.captureAndSave(path.path,delay: const Duration(milliseconds: 100),
            fileName: fileName,
            pixelRatio: 1.0
        );
        Fluttertoast.showToast(msg: 'Image is Downloaded');
      }
      else{
        await path.create();
        await screenshotController.captureAndSave(path.path,delay: const Duration(milliseconds: 100),
            fileName: fileName,
            pixelRatio: 1.0
        );
        Fluttertoast.showToast(msg: 'Image is Downloaded');

      }
    }else{
      Fluttertoast.showToast(msg: 'Permission Denied');
    }
  }
  shareImage()async{
    await screenshotController.capture(
        delay: const Duration(microseconds: 100),
        pixelRatio: 1.0
    ).then((Uint8List? img) async {
      if(img!=null){
        final directory = (await getApplicationDocumentsDirectory()).path;
        const fileName = 'share.png';
        final imagePath = await File('$directory/$fileName').create();
        await imagePath.writeAsBytes(img);

        Share.shareFiles([imagePath.path]);
      }else{
        print('Failed to take a screenshot');
      }
    });
  }
}
