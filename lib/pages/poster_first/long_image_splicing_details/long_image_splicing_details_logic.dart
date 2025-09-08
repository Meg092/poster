import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poster/db_poster/db_poster.dart';

enum StitchType { vertical, horizontal }

class LongImageSplicingDetailsLogic extends GetxController {
  StitchType stitchType = StitchType.vertical;

  DBPoster dbPoster = Get.find();

  bool isCapture = false;

  List<XFile> selectedImages = [];

  Future<void> pickImages() async {
    try {
      final List<XFile>? images = await ImagePicker()
          .pickMultiImage(imageQuality: 90, maxWidth: 1024, limit: 9);
      if (images != null && images.isNotEmpty) {
        selectedImages = images;
        update();
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              'There is a problem with selecting the picture. Please try again by choosing another one');
    }
  }
}
