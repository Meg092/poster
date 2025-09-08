import 'package:get/get.dart';

import 'poster_create_logic.dart';

class PosterCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      PosterCreateLogic(),
      permanent: true,
    );
  }
}
