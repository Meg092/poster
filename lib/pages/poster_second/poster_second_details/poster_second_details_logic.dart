import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poster/db_poster/db_poster.dart';
import 'package:poster/db_poster/poster_entity.dart';

class PosterSecondDetailsLogic extends GetxController {

  int type = Get.arguments;

  DBPoster dbPoster = Get.find<DBPoster>();

  Uint8List? image;

  void imageSelected() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
          imageQuality: 90, maxWidth: 1024, source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        image = imageBytes;
        update();
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Please check album permissions or select a new image');
      return;
    }
  }

  void addData(GlobalKey globalKey) async {
    if (image == null) {
      Fluttertoast.showToast(msg: 'Please select an image');
      return;
    }
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0); // pixelRatio 控制图像质量
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List();
      await dbPoster.insertPoster(PosterEntity(id: 0, createdTime: DateTime.now(), image: bytes!));
      Fluttertoast.showToast(msg: 'Added successfully');
      Get.back();
    } catch (e) {
      print("Get render error: $e");
    }


  }

}
