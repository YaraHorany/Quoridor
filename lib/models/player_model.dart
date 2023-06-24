import 'dart:ui';
import 'package:get/get.dart';
import 'package:quoridor/constants/game_constants.dart';
import '../helpers.dart';
import 'fence_model.dart';

class Player {
  int position;
  final Color color;
  bool turn;
  RxInt fences = 10.obs;

  Player({
    required this.position,
    required this.color,
    required this.turn,
  });

  void changeTurn() {
    turn = !turn;
  }

  bool outOfFences() => fences == 0 as RxInt;

  List<int> showPossibleMoves(List<FenceModel> fence, int opponentPosition) => [
        canMoveUp(fence, opponentPosition, 1),
        canMoveDown(fence, opponentPosition, 1),
        canMoveRight(fence, opponentPosition, 1),
        canMoveLeft(fence, opponentPosition, 1)
      ];

  // Recursion function which check if it's possible to move up.
  // Returns the index of the square (one step or two steps up). -1 if the player can't move up.
  int canMoveUp(List<FenceModel> fence, int opponentPosition, int steps) {
    if (steps == 3) return -1;
    if (inBoardRange(position - (GameConstants.totalInRow * steps * 2))) {
      if (fence[fence.indexWhere((element) =>
                  element.position ==
                  position - GameConstants.totalInRow * ((steps * 2) - 1))]
              .placed ==
          false) {
        if (opponentPosition ==
            position - (GameConstants.totalInRow * steps * 2)) {
          return canMoveUp(fence, opponentPosition, steps + 1);
        } else {
          return position - (GameConstants.totalInRow * steps * 2);
        }
      }
    }
    return -1;
  }

  // Recursion function which check if it's possible to move down.
  // Returns the index of the square (one step or two steps down). -1 if the player can't move down.
  int canMoveDown(List<FenceModel> fence, int opponentPosition, int steps) {
    if (steps == 3) return -1;
    if (inBoardRange(position + (GameConstants.totalInRow * steps * 2))) {
      if (fence[fence.indexWhere((element) =>
                  element.position ==
                  position + GameConstants.totalInRow * ((steps * 2) - 1))]
              .placed ==
          false) {
        if (opponentPosition ==
            position + (GameConstants.totalInRow * steps * 2)) {
          return canMoveDown(fence, opponentPosition, steps + 1);
        } else {
          return position + (GameConstants.totalInRow * steps * 2);
        }
      }
    }
    return -1;
  }

  // Recursion function which check if it's possible to move right.
  // Returns the index of the square (one step or two steps to the right). -1 if the player can't move right.
  int canMoveRight(List<FenceModel> fence, int opponentPosition, int steps) {
    if (steps == 3) return -1;
    if (inBoardRange(position + (steps * 2))) {
      if (fence[fence.indexWhere(
                  (element) => element.position == position + (steps * 2) - 1)]
              .placed ==
          false) {
        if (opponentPosition == position + (steps * 2)) {
          return canMoveRight(fence, opponentPosition, steps + 1);
        } else {
          return position + (steps * 2);
        }
      }
    }
    return -1;
  }

  // Recursion function which check if it's possible to move left.
  // Returns the index of the square (one step or two steps to the left). -1 if the player can't move left.
  int canMoveLeft(List<FenceModel> fence, int opponentPosition, int steps) {
    if (steps == 3) return -1;
    if (inBoardRange(position - (steps * 2))) {
      if (fence[fence.indexWhere((element) =>
                  element.position == position - ((steps * 2) - 1))]
              .placed ==
          false) {
        if (opponentPosition == position - (steps * 2)) {
          return canMoveLeft(fence, opponentPosition, steps + 1);
        } else {
          return position - (steps * 2);
        }
      }
    }
    return -1;
  }
}
