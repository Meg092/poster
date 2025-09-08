import 'package:get/get.dart';

import 'template_puzzle_logic.dart';

class TemplatePuzzleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TemplatePuzzleLogic());
  }
}