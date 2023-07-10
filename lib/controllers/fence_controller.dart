import 'dart:async';
import 'package:get/get.dart';
import 'package:quoridor/models/fence_model.dart';
import 'package:quoridor/constants/game_constants.dart';
import 'package:quoridor/models/player_model.dart';
import 'package:quoridor/controllers/game_controller.dart';
import '../helpers.dart';

enum DragType {
  horizontalDrag,
  verticalDrag,
}

class FenceController extends GetxController {
  DragType? dragType;
  Timer? timer;
  RxString msg = "".obs;
  late Player player1;
  late Player player2;
  late List<FenceModel> fence;

  @override
  void onInit() {
    super.onInit();
    resetGame();
  }

  void resetGame() {
    msg.value = "";
    player1 = Get.find<GameController>().player1;
    player2 = Get.find<GameController>().player2;
    fence = Get.find<GameController>().fence;
  }

  int calcFenceIndex(int i) =>
      fence.indexWhere((element) => element.position == i);

  void drawTemporaryFence(int boardIndex) {
    if (!outOfFences()) {
      int index = calcFenceIndex(boardIndex);
      if (dragType == DragType.verticalDrag &&
          fence[index].type == FenceType.verticalFence &&
          isNotLastRow(boardIndex) &&
          isValid(true, boardIndex)) {
        updateTemporaryFence(boardIndex, true, true);
      } else if (dragType == DragType.horizontalDrag &&
          fence[index].type == FenceType.horizontalFence &&
          isNotLastColumn(boardIndex) &&
          isValid(false, boardIndex)) {
        updateTemporaryFence(boardIndex, false, true);
      }
    }
  }

  void removeTemporaryFence(int boardIndex) {
    if (!outOfFences()) {
      int index = calcFenceIndex(boardIndex);
      if (dragType == DragType.verticalDrag &&
          fence[index].type == FenceType.verticalFence &&
          isNotLastRow(boardIndex)) {
        updateTemporaryFence(boardIndex, true, false);
      } else if (dragType == DragType.horizontalDrag &&
          fence[index].type == FenceType.horizontalFence &&
          isNotLastColumn(boardIndex)) {
        updateTemporaryFence(boardIndex, false, false);
      }
    }
  }

  void drawFence(int boardIndex) {
    if (!outOfFences()) {
      int index = calcFenceIndex(boardIndex);
      if (dragType == DragType.verticalDrag &&
          fence[index].type == FenceType.verticalFence &&
          isNotLastRow(boardIndex) &&
          isValid(true, boardIndex)) {
        updateFence(boardIndex, true);
        Get.find<GameController>().switchTurns();
        update();
      } else if (dragType == DragType.horizontalDrag &&
          fence[index].type == FenceType.horizontalFence &&
          isNotLastColumn(boardIndex) &&
          isValid(false, boardIndex)) {
        updateFence(boardIndex, false);
        Get.find<GameController>().switchTurns();
        update();
      }
    } else {
      outOfFencesMsg();
    }
  }

  bool isValid(bool isVertical, int boardIndex) {
    if (isVertical) {
      return (fence[calcFenceIndex(boardIndex)].placed == false &&
          fence[calcFenceIndex(boardIndex + GameConstants.totalInRow)].placed ==
              false &&
          fence[calcFenceIndex(boardIndex + (GameConstants.totalInRow * 2))]
                  .placed ==
              false);
    } else {
      return (fence[calcFenceIndex(boardIndex)].placed == false &&
          fence[calcFenceIndex(boardIndex + 1)].placed == false &&
          fence[calcFenceIndex(boardIndex + 2)].placed == false);
    }
  }

  void updateTemporaryFence(int boardIndex, bool isVertical, bool val) {
    fence[calcFenceIndex(boardIndex)].temporaryFence = val;
    if (isVertical) {
      fence[calcFenceIndex(boardIndex + GameConstants.totalInRow)]
          .temporaryFence = val;
      fence[calcFenceIndex(boardIndex + (GameConstants.totalInRow * 2))]
          .temporaryFence = val;
    } else {
      fence[calcFenceIndex(boardIndex + 1)].temporaryFence = val;
      fence[calcFenceIndex(boardIndex + 2)].temporaryFence = val;
    }
    update();
  }

  void updateFence(int boardIndex, bool isVertical) {
    fence[calcFenceIndex(boardIndex)].placed = true;
    if (isVertical) {
      fence[calcFenceIndex(boardIndex + GameConstants.totalInRow)].placed =
          true;
      fence[calcFenceIndex(boardIndex + (GameConstants.totalInRow * 2))]
          .placed = true;
    } else {
      fence[calcFenceIndex(boardIndex + 1)].placed = true;
      fence[calcFenceIndex(boardIndex + 2)].placed = true;
    }
    update();
    updateFencesNum();
  }

  void updateFencesNum() {
    if (player1.turn) {
      player1.fences--;
    } else {
      player2.fences--;
    }
  }

  bool outOfFences() {
    if (player1.turn) {
      return player1.outOfFences();
    } else {
      return player2.outOfFences();
    }
  }

  void outOfFencesMsg() {
    int count = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      msg.value = 'There are no more\n walls for you to place';
      count++;
      if (count == 4) {
        msg.value = "";
        timer!.cancel();
      }
    });
  }
}
