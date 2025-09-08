import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PreviewPhoto extends StatelessWidget {
  const PreviewPhoto(this.imageData,{super.key});

  final Uint8List imageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: Stack(
        children: [
          PhotoView(
            imageProvider: MemoryImage(imageData),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 4,
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon:const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      )),
    );
  }
}
