import 'package:get/get.dart';

import 'poster_second_logic.dart';

class PosterSecondBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PosterSecondLogic());
  }
}
