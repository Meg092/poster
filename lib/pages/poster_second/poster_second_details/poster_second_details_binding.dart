import 'package:get/get.dart';

import 'poster_second_details_logic.dart';

class PosterSecondDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PosterSecondDetailsLogic());
  }
}
