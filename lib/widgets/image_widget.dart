import 'package:flutter/material.dart';

import 'package:virgil/constants/theme_data.dart';

class ImageWidget extends StatefulWidget {
  const ImageWidget({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  bool _imageLoaded = false;
  @override
  Widget build(BuildContext context) {
    return Image.network(
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
        );
  }
}
