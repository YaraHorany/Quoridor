import 'package:get/get.dart';
import 'package:quoridor/controllers/game_controller.dart';

class GameControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameController>(() => GameController());
  }
}
