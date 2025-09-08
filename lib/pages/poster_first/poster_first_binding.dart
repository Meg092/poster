import 'package:get/get.dart';

import 'poster_first_logic.dart';

class PosterFirstBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PosterFirstLogic());
  }
}
