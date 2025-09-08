import 'package:get/get.dart';

import '../poster_first/poster_first_logic.dart';
import '../poster_second/poster_second_logic.dart';
import '../poster_third/poster_third_logic.dart';
import 'poster_tab_logic.dart';

class PosterTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PosterTabLogic());
    Get.lazyPut(() => PosterFirstLogic());
    Get.lazyPut(() => PosterSecondLogic());
    Get.lazyPut(() => PosterThirdLogic());
  }
}
