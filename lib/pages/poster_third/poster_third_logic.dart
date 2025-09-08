import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:poster/db_poster/db_poster.dart';

import '../../db_poster/poster_entity.dart';

class PosterThirdLogic extends GetxController {
  DBPoster dbPoster = Get.find<DBPoster>();

  var list = <PosterEntity>[].obs;

  var selectedList = <PosterEntity>[].obs;

  var isEdit = false.obs;

  getData() async {
    list.value = await dbPoster.getPosterAllData();
  }

  deleteData() async {
    if (selectedList.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select data to delete');
      return;
    }
    Get.dialog(AlertDialog(
      title: const Text(
        'Warm reminder',
        textAlign: TextAlign.center,
      ),
      content: const Text(
        'Do you want to delete this data?',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () async {
            await dbPoster
                .deletePosters(selectedList.map((e) => e.id).toList());
            await getData();
            Get.back();
          },
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ));
  }

  void saveImage(PosterEntity entity) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final result = await ImageGallerySaver.saveImage(entity.image);
      bool isSuccess = result['isSuccess'];
      if (isSuccess) {
        Fluttertoast.showToast(msg: 'Save successfully');
      }
    } else {
      Get.dialog(AlertDialog(
        title: const Text(
          'Access permission photo library for add pictures to album',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              openAppSettings();
              Get.back();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ));
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }
}
