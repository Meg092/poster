import 'package:get/get.dart';

import 'poster_third_logic.dart';

class PosterThirdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PosterThirdLogic());
  }
}
