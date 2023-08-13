import 'dart:ui';
import 'package:get/get.dart';
import 'package:quoridor/utils/game_constants.dart';
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

  factory Player.copy({required Player obj}) => Player(
        position: obj.position,
        color: obj.color,
        turn: obj.turn,
      );

  void changeTurn() {
    turn = !turn;
  }

  bool outOfFences() => fences.value == 0;

  List<int> showPossibleMoves(List<FenceModel> fence, int opponentPosition) =>
      moveUp(fence, opponentPosition, 1) +
      moveDown(fence, opponentPosition, 1) +
      moveRight(fence, opponentPosition, 1) +
      moveLeft(fence, opponentPosition, 1);

  // Recursion function which check if it's possible to move up.
  // Returns the index of the square (one step or two steps up).
  List<int> moveUp(List<FenceModel> fence, int opponentPosition, int steps) {
    if (steps == 3) return [];
    if (inBoardRange(position - (GameConstants.totalInRow * steps * 2))) {
      if (fence[fence.indexWhere((element) =>
                  element.position ==
                  position - GameConstants.totalInRow * ((steps * 2) - 1))]
              .placed ==
          false) {
        if (opponentPosition ==
            position - (GameConstants.totalInRow * steps * 2)) {
          return moveUp(fence, opponentPosition, steps + 1);
        } else {
          return [position - (GameConstants.totalInRow * steps * 2)];
        }
      } else {
        if (steps == 2) {
          return moveUpRight(fence) + moveUpLeft(fence);
        }
      }
    }
    return [];
  }

  // Recursion function which check if it's possible to move down.
  // Returns the index of the square (one step or two steps down).
  List<int> moveDown(List<FenceModel> fence, int opponentPosition, int steps) {
    if (steps == 3) return [];
    if (inBoardRange(position + (GameConstants.totalInRow * steps * 2))) {
      if (fence[fence.indexWhere((element) =>
                  element.position ==
                  position + GameConstants.totalInRow * ((steps * 2) - 1))]
              .placed ==
          false) {
        if (opponentPosition ==
            position + (GameConstants.totalInRow * steps * 2)) {
          return moveDown(fence, opponentPosition, steps + 1);
        } else {
          return [position + (GameConstants.totalInRow * steps * 2)];
        }
      } else {
        if (steps == 2) {
          return moveDownRight(fence) + moveDownLeft(fence);
        }
      }
    }
    return [];
  }

  // Recursion function which check if it's possible to move right.
  // Returns the index of the square (one step or two steps to the right).
  List<int> moveRight(List<FenceModel> fence, int opponentPosition, int steps) {
    if (steps == 3) return [];
    if (inBoardRange(position + (steps * 2))) {
      if (fence[fence.indexWhere(
                  (element) => element.position == position + (steps * 2) - 1)]
              .placed ==
          false) {
        if (opponentPosition == position + (steps * 2)) {
          return moveRight(fence, opponentPosition, steps + 1);
        } else {
          return [position + (steps * 2)];
        }
      } else {
        if (steps == 2) {
          return moveRightUp(fence) + moveRightDown(fence);
        }
      }
    }
    return [];
  }

  // Recursion function which check if it's possible to move left.
  // Returns the index of the square (one step or two steps to the left).
  List<int> moveLeft(List<FenceModel> fence, int opponentPosition, int steps) {
    if (steps == 3) return [];
    if (inBoardRange(position - (steps * 2))) {
      if (fence[fence.indexWhere((element) =>
                  element.position == position - ((steps * 2) - 1))]
              .placed ==
          false) {
        if (opponentPosition == position - (steps * 2)) {
          return moveLeft(fence, opponentPosition, steps + 1);
        } else {
          return [position - (steps * 2)];
        }
      } else {
        if (steps == 2) {
          return moveLeftUp(fence) + moveLeftDown(fence);
        }
      }
    }
    return [];
  }

  List<int> moveUpRight(List<FenceModel> fence) {
    if (inBoardRange(position - (GameConstants.totalInRow * 2) + 2)) {
      if (fence[fence.indexWhere((element) =>
                  element.position ==
                  position - (GameConstants.totalInRow * 2) + 1)]
              .placed ==
          false) {
        return [position - (GameConstants.totalInRow * 2) + 2];
      }
    }
    return [];
  }

  List<int> moveUpLeft(List<FenceModel> fence) {
    if (inBoardRange(position - (GameConstants.totalInRow * 2) - 2)) {
      if (fence[fence.indexWhere((element) =>
                  element.position ==
                  position - (GameConstants.totalInRow * 2) - 1)]
              .placed ==
          false) {
        return [position - (GameConstants.totalInRow * 2) - 2];
      }
    }
    return [];
  }

  List<int> moveDownRight(List<FenceModel> fence) {
    if (inBoardRange(position + (GameConstants.totalInRow * 2) + 2)) {
      if (fence[fence.indexWhere((element) =>
                  element.position ==
                  position + (GameConstants.totalInRow * 2) + 1)]
              .placed ==
          false) {
        return [position + (GameConstants.totalInRow * 2) + 2];
      }
    }
    return [];
  }

  List<int> moveDownLeft(List<FenceModel> fence) {
    if (inBoardRange(position + (GameConstants.totalInRow * 2) - 2)) {
      if (fence[fence.indexWhere((element) =>
                  element.position ==
                  position + (GameConstants.totalInRow * 2) - 1)]
              .placed ==
          false) {
        return [position + (GameConstants.totalInRow * 2) - 2];
      }
    }
    return [];
  }

  List<int> moveRightUp(List<FenceModel> fence) {
    if (inBoardRange(position + 2 - (GameConstants.totalInRow * 2))) {
      if (fence[fence.indexWhere((element) =>
                  element.position == position + 2 - GameConstants.totalInRow)]
              .placed ==
          false) {
        return [position + 2 - (GameConstants.totalInRow * 2)];
      }
    }
    return [];
  }

  List<int> moveRightDown(List<FenceModel> fence) {
    if (inBoardRange(position + 2 + (GameConstants.totalInRow * 2))) {
      if (fence[fence.indexWhere((element) =>
                  element.position == position + 2 + GameConstants.totalInRow)]
              .placed ==
          false) {
        return [position + 2 + (GameConstants.totalInRow * 2)];
      }
    }
    return [];
  }

  List<int> moveLeftUp(List<FenceModel> fence) {
    if (inBoardRange(position - 2 - (GameConstants.totalInRow * 2))) {
      if (fence[fence.indexWhere((element) =>
                  element.position == position - 2 - GameConstants.totalInRow)]
              .placed ==
          false) {
        return [position - 2 - (GameConstants.totalInRow * 2)];
      }
    }
    return [];
  }

  List<int> moveLeftDown(List<FenceModel> fence) {
    if (inBoardRange(position - 2 + (GameConstants.totalInRow * 2))) {
      if (fence[fence.indexWhere((element) =>
                  element.position == position - 2 + GameConstants.totalInRow)]
              .placed ==
          false) {
        return [position - 2 + (GameConstants.totalInRow * 2)];
      }
    }
    return [];
  }

  canReachOtherSide(int playerNumber, int initialPosition, int opponentPosition,
      List<FenceModel> tempFence, List<int> usedPositions) {
    int? prevPosition;
    bool? val;
    List<int> tempPossibleMoves = [];
    if (playerNumber == 1) {
      if (reachedFirstRow(position)) {
        return true;
      }
    } else if (playerNumber == 2) {
      if (reachedLastRow(position)) {
        return true;
      }
    }
    tempPossibleMoves = showPossibleMoves(tempFence, opponentPosition);
    for (int i = 0; i < tempPossibleMoves.length; i++) {
      if (!usedPositions.contains(tempPossibleMoves[i])) {
        prevPosition = position;
        position = tempPossibleMoves[i];
        val = canReachOtherSide(playerNumber, initialPosition, opponentPosition,
            tempFence, usedPositions + [prevPosition]);
        if (val == true) {
          return true;
        }
        position = prevPosition;
      }
    }
    if (position == initialPosition) {
      return false;
    }
  }
}
