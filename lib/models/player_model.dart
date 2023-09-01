import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quoridor/utils/game_constants.dart';
import '../helpers.dart';
import 'fence_model.dart';
import "dart:collection";

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

  List<int> showPossibleMoves(List<FenceModel> fence, int opponentPosition) {
    return moveUp(fence, opponentPosition) +
        moveDown(fence, opponentPosition) +
        moveRight(fence, opponentPosition) +
        moveLeft(fence, opponentPosition);
  }

  List<int> moveUp(List<FenceModel> fence, int opponentPosition) {
    if (position >= GameConstants.totalInRow) {
      if (fence[fence.indexWhere((element) =>
                  element.position == position - GameConstants.totalInRow)]
              .placed ==
          false) {
        if (opponentPosition == position - (GameConstants.totalInRow * 2)) {
          if (position < GameConstants.totalInRow * 3) {
            return moveUpRight(fence) + moveUpLeft(fence);
          } else {
            if (fence[fence.indexWhere((element) =>
                        element.position ==
                        position - (GameConstants.totalInRow * 3))]
                    .placed ==
                false) {
              return [position - (GameConstants.totalInRow * 4)];
            } else {
              return moveUpRight(fence) + moveUpLeft(fence);
            }
          }
        } else {
          return [position - (GameConstants.totalInRow * 2)];
        }
      }
    }
    return [];
  }

  List<int> moveDown(List<FenceModel> fence, int opponentPosition) {
    if (isNotLastRow(position)) {
      if (fence[fence.indexWhere((element) =>
                  element.position == position + GameConstants.totalInRow)]
              .placed ==
          false) {
        if (opponentPosition == position + (GameConstants.totalInRow * 2)) {
          if (position >=
              GameConstants.totalInRow * (GameConstants.totalInRow - 3)) {
            return moveDownRight(fence) + moveDownLeft(fence);
          } else {
            if (fence[fence.indexWhere((element) =>
                        element.position ==
                        position + (GameConstants.totalInRow * 3))]
                    .placed ==
                false) {
              return [position + (GameConstants.totalInRow * 4)];
            } else {
              return moveDownRight(fence) + moveDownLeft(fence);
            }
          }
        } else {
          return [position + (GameConstants.totalInRow * 2)];
        }
      }
    }
    return [];
  }

  List<int> moveRight(List<FenceModel> fence, int opponentPosition) {
    if (isNotLastColumn(position)) {
      if (fence[fence.indexWhere((element) => element.position == position + 1)]
              .placed ==
          false) {
        if (opponentPosition == position + 2) {
          if (position % GameConstants.totalInRow >=
              GameConstants.totalInRow - 3) {
            return moveRightUp(fence) + moveRightDown(fence);
          } else {
            if (fence[fence.indexWhere(
                        (element) => element.position == position + 3)]
                    .placed ==
                false) {
              return [position + 4];
            } else {
              return moveRightUp(fence) + moveRightDown(fence);
            }
          }
        } else {
          return [position + 2];
        }
      }
    }
    return [];
  }

  List<int> moveLeft(List<FenceModel> fence, int opponentPosition) {
    if (position % GameConstants.totalInRow != 0) {
      if (fence[fence.indexWhere((element) => element.position == position - 1)]
              .placed ==
          false) {
        if (opponentPosition == position - 2) {
          if (position % GameConstants.totalInRow <= 2) {
            return moveLeftUp(fence) + moveLeftDown(fence);
          } else {
            if (fence[fence.indexWhere(
                        (element) => element.position == position - 3)]
                    .placed ==
                false) {
              return [position - 4];
            } else {
              return moveLeftUp(fence) + moveLeftDown(fence);
            }
          }
        } else {
          return [position - 2];
        }
      }
    }
    return [];
  }

  List<int> moveUpRight(List<FenceModel> fence) {
    int pos = position - (GameConstants.totalInRow * 2) + 2;
    if (inBoardRange(pos)) {
      if (fence[fence.indexWhere((element) => element.position == pos - 1)]
              .placed ==
          false) {
        return [pos];
      }
    }
    return [];
  }

  List<int> moveUpLeft(List<FenceModel> fence) {
    int pos = position - (GameConstants.totalInRow * 2) - 2;
    if (inBoardRange(pos)) {
      if (fence[fence.indexWhere((element) => element.position == pos + 1)]
              .placed ==
          false) {
        return [pos];
      }
    }
    return [];
  }

  List<int> moveDownRight(List<FenceModel> fence) {
    int pos = position + (GameConstants.totalInRow * 2) + 2;
    if (inBoardRange(pos)) {
      if (fence[fence.indexWhere((element) => element.position == pos - 1)]
              .placed ==
          false) {
        return [pos];
      }
    }
    return [];
  }

  List<int> moveDownLeft(List<FenceModel> fence) {
    int pos = position + (GameConstants.totalInRow * 2) - 2;
    if (inBoardRange(pos)) {
      if (fence[fence.indexWhere((element) => element.position == pos + 1)]
              .placed ==
          false) {
        return [pos];
      }
    }
    return [];
  }

  List<int> moveRightUp(List<FenceModel> fence) {
    int pos = position + 2 - (GameConstants.totalInRow * 2);
    if (inBoardRange(pos)) {
      if (fence[fence.indexWhere((element) =>
                  element.position == pos + GameConstants.totalInRow)]
              .placed ==
          false) {
        return [pos];
      }
    }
    return [];
  }

  List<int> moveRightDown(List<FenceModel> fence) {
    int pos = position + 2 + (GameConstants.totalInRow * 2);
    if (inBoardRange(pos)) {
      if (fence[fence.indexWhere((element) =>
                  element.position == pos - GameConstants.totalInRow)]
              .placed ==
          false) {
        return [pos];
      }
    }
    return [];
  }

  List<int> moveLeftUp(List<FenceModel> fence) {
    int pos = position - 2 - (GameConstants.totalInRow * 2);
    if (inBoardRange(pos)) {
      if (fence[fence.indexWhere((element) =>
                  element.position == pos + GameConstants.totalInRow)]
              .placed ==
          false) {
        return [pos];
      }
    }
    return [];
  }

  List<int> moveLeftDown(List<FenceModel> fence) {
    int pos = position - 2 + (GameConstants.totalInRow * 2);
    if (inBoardRange(pos)) {
      if (fence[fence.indexWhere((element) =>
                  element.position == pos - GameConstants.totalInRow)]
              .placed ==
          false) {
        return [pos];
      }
    }
    return [];
  }

  // a BFS (Breadth First Search) is applied which finds the shortest path to the goal
  // for each player and returns false if the distance is undefined.
  // bool bfsSearch(
  //   List<FenceModel> tempFence,
  // ) {
  //   final queue = Queue<int>();
  //   List<int> visited = [];
  //   List<int> tempPossibleMoves = [];
  //   queue.add(position);
  //
  //   while (didNotReachOtherSide()) {
  //     if (queue.isEmpty) return false;
  //     position = queue.removeFirst();
  //     visited.add(position);
  //     tempPossibleMoves = showPossibleMoves(tempFence, -1);
  //
  //     for (int i = 0; i < tempPossibleMoves.length; i++) {
  //       if (!visited.contains(tempPossibleMoves[i]) &&
  //           !queue.contains(tempPossibleMoves[i])) {
  //         queue.addLast(tempPossibleMoves[i]);
  //       }
  //     }
  //   }
  //   // print('queue: $queue');
  //   print('visited: ${visited.length}');
  //   return true;
  // }

  // a BFS (Breadth First Search) is applied which finds the shortest path to the goal
  // for each player and returns false if the distance is undefined.
  int bfsSearch(
    List<FenceModel> tempFence,
  ) {
    final queue = Queue<int>();
    List<int> visited = [];
    List<int> tempPossibleMoves = [];
    queue.add(position);

    while (didNotReachOtherSide()) {
      if (queue.isEmpty) return -1;
      position = queue.removeFirst();
      visited.add(position);
      tempPossibleMoves = showPossibleMoves(tempFence, -1);

      for (int i = 0; i < tempPossibleMoves.length; i++) {
        if (!visited.contains(tempPossibleMoves[i]) &&
            !queue.contains(tempPossibleMoves[i])) {
          queue.addLast(tempPossibleMoves[i]);
        }
      }
    }
    // print('queue: $queue');
    // print('visited: ${visited.length}');
    return visited.length;
  }

  bool didNotReachOtherSide() {
    if (color == Colors.green) {
      if (!reachedFirstRow(position)) {
        return true;
      }
    } else {
      if (!reachedLastRow(position)) {
        return true;
      }
    }
    return false;
  }
}
