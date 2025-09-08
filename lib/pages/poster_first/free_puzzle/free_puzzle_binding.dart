import 'package:get/get.dart';

import 'free_puzzle_logic.dart';

class FreePuzzleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FreePuzzleLogic());
  }
}