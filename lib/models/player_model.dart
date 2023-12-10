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
  bool bfsSearch(
    List<FenceModel> tempFence,
  ) {
    final queue = Queue<int>();
    List<int> visited = [];
    List<int> tempPossibleMoves = [];
    queue.add(position);

    while (didNotReachOtherSide()) {
      if (queue.isEmpty) return false;
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

    return true;
  }

  List<int> bfs(List<FenceModel> tempFence, int opponentPosition) {
    print('bfs position before: $position');
    final queue = Queue<int>();
    List<int> visited = [];
    visited.add(position);
    List<int> tempPossibleMoves = [];
    List<int> prev = List.filled(GameConstants.totalInBoard, -1);
    queue.add(position);

    while (queue.isNotEmpty) {
      position = queue.removeFirst();
      tempPossibleMoves = showPossibleMoves(tempFence, opponentPosition);
      for (int i = 0; i < tempPossibleMoves.length; i++) {
        if (!visited.contains(tempPossibleMoves[i])) {
          queue.addLast(tempPossibleMoves[i]);
          visited.add(tempPossibleMoves[i]);
          prev[tempPossibleMoves[i]] = position;
        }
      }
    }
    print('bfs position after: $position');
    // print(opponentPosition);
    print(prev);
    // for (int k = 0; k < prev.length; k++) {
    //   print('index: $k');
    //   print(prev[k]);
    // }
    // print(prev);
    return prev;
  }

  List<List<int>> findMaxPath(List<int> prev, int opponentPosition) {
    List<int> path = [];
    List<List<int>> minPath = [];
    double minLength = 1.0 / 0.0; // infinity
    double maxLength = -1 * (1.0 / 0.0); // minus infinity
    List<List<int>> maxPath = [];

    for (int i = 272; i < 289; i += 2) {
      if (i != opponentPosition && prev[i] != -1) {
        path = _reconstructPath(prev, i, opponentPosition);
        if (path.length > maxLength && path.isNotEmpty) {
          maxPath.clear();
          maxLength = path.length.toDouble();
          maxPath.add(path);
        } else if (path.length == maxLength) {
          maxPath.add(path);
        }
      }
    }
    // print('min PATHS:');
    // print(minPath);
    return maxPath;
  }

  List<List<int>> findMinPaths(List<int> prev, int opponentPosition) {
    print('findMinPaths position: $position');
    if (color == Colors.green) {
      return _findMinPathsForPlayer(
          prev, opponentPosition, 0, GameConstants.totalInRow);
    }
    return _findMinPathsForPlayer(
        prev,
        opponentPosition,
        GameConstants.totalInRow * (GameConstants.totalInRow - 1),
        GameConstants.totalInBoard);
  }

  List<List<int>> _findMinPathsForPlayer(
      List<int> prev, int opponentPosition, int startIndex, int endIndex) {
    List<int> path = [];
    List<List<int>> minPath = [];
    double minLength = 1.0 / 0.0; // infinity

    for (int i = startIndex; i < endIndex; i += 2) {
      if (i != opponentPosition && prev[i] != -1) {
        path = _reconstructPath(prev, i, opponentPosition);
        if (path.length < minLength && path.isNotEmpty) {
          minPath.clear();
          minLength = path.length.toDouble();
          minPath.add(path);
        } else if (path.length == minLength) {
          minPath.add(path);
        }
      }
    }
    // print('min PATHS:');
    // print(minPath);
    return minPath;
  }

  List<int> _reconstructPath(List<int> prev, int target, int opponentPosition) {
    List<int> path = [];
    for (int j = target; j != -1; j = prev[j]) {
      if (j != opponentPosition) {
        path.add(j);
      }
    }
    return List.from(path.reversed);
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
