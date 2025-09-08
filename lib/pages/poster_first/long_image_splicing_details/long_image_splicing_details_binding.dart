import 'package:get/get.dart';

import 'long_image_splicing_details_logic.dart';

class LongImageSplicingDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LongImageSplicingDetailsLogic());
  }
}
