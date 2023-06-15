import 'package:get/get.dart';

class GameController extends GetxController {
  List<String> board = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    buildBoard();
  }

  void buildBoard() {
    for (int i = 0; i < 17 * 17; i++) {
      if ((i ~/ 17) % 2 == 0) {
        if (i % 2 == 0) {
          if (i == 8) {
            board.add('p1');
          } else if (i == 280) {
            board.add('p2');
          } else {
            board.add('path');
          }
        } else {
          board.add('vertical empty fence');
        }
      } else {
        if (i % 2 == 0) {
          board.add('horizontal empty fence');
        } else {
          board.add('square empty fence');
        }
      }
    }
    print(board);
  }
}
