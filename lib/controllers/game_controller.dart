import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/fence_model.dart';
import '../models/player_model.dart';
import 'package:quoridor/constants/game_constants.dart';

class GameController extends GetxController {
  late Player player1, player2;
  List<Fence> fence = [];
  List<int> path = [];

  @override
  void onInit() {
    super.onInit();
    buildBoard();
  }

  void buildBoard() {
    player1 = Player(position: 8, color: Colors.green, fences: 10);
    player2 = Player(position: 280, color: Colors.orange, fences: 10);

    for (int i = 0; i < GameConstants.totalInBoard; i++) {
      if ((i ~/ GameConstants.totalInRow) % 2 == 0) {
        if (i % 2 == 0) {
          path.add(i);
        } else {
          fence.add(
              Fence(position: i, placed: false, type: FenceType.verticalFence));
        }
      } else {
        if (i % 2 == 0) {
          fence.add(Fence(
            position: i,
            placed: false,
            type: FenceType.squareFence,
          ));
        } else {
          fence.add(Fence(
              position: i, placed: false, type: FenceType.horizontalFence));
        }
      }
    }
  }

  void play(int index) {
    if (checkPossibleMoves().contains(index)) {
      player2.position = index;
    }
    update();
  }

  // The pawns are moved one square at a time, horizontally or vertically, forwards or backwards, never diagonally.
  List<int> checkPossibleMoves() =>
      [canMoveUp(1), canMoveDown(1), canMoveRight(1), canMoveLeft(1)];

  // Recursion function which check if it's possible to move up.
  // Returns the index of the square (one step or two steps up). -1 if the player can't move up.
  int canMoveUp(int steps) {
    if (steps == 3) return -1;
    if (inBoardRange(
        player2.position - (GameConstants.totalInRow * steps * 2))) {
      int index = fence.indexWhere((element) =>
          element.position ==
          player2.position - GameConstants.totalInRow * ((steps * 2) - 1));
      if (fence[index].placed == false) {
        if (player1.position ==
            player2.position - (GameConstants.totalInRow * steps * 2)) {
          return canMoveUp(steps + 1);
        } else {
          return player2.position - (GameConstants.totalInRow * steps * 2);
        }
      }
    }
    return -1;
  }

  // Recursion function which check if it's possible to move down.
  // Returns the index of the square (one step or two steps down). -1 if the player can't move down.
  int canMoveDown(int steps) {
    if (steps == 3) return -1;
    if (inBoardRange(
        player2.position + (GameConstants.totalInRow * steps * 2))) {
      int index = fence.indexWhere((element) =>
          element.position ==
          player2.position + GameConstants.totalInRow * ((steps * 2) - 1));
      if (fence[index].placed == false) {
        if (player1.position ==
            player2.position + (GameConstants.totalInRow * steps * 2)) {
          return canMoveDown(steps + 1);
        } else {
          return player2.position + (GameConstants.totalInRow * steps * 2);
        }
      }
    }
    return -1;
  }

  // Recursion function which check if it's possible to move right.
  // Returns the index of the square (one step or two steps to the right). -1 if the player can't move right.
  int canMoveRight(int steps) {
    if (steps == 3) return -1;
    if (inBoardRange(player2.position + (steps * 2))) {
      int index = fence.indexWhere(
          (element) => element.position == player2.position + (steps * 2) - 1);
      if (fence[index].placed == false) {
        if (player1.position == player2.position + (steps * 2)) {
          return canMoveDown(steps + 1);
        } else {
          return player2.position + (steps * 2);
        }
      }
    }
    return -1;
  }

  // Recursion function which check if it's possible to move left.
  // Returns the index of the square (one step or two steps to the left). -1 if the player can't move left.
  int canMoveLeft(int steps) {
    if (steps == 3) return -1;
    if (inBoardRange(player2.position - (steps * 2))) {
      int index = fence.indexWhere((element) =>
          element.position == player2.position - ((steps * 2) - 1));
      if (fence[index].placed == false) {
        if (player1.position == player2.position - (steps * 2)) {
          return canMoveDown(steps + 1);
        } else {
          return player2.position - (steps * 2);
        }
      }
    }
    return -1;
  }

  bool inBoardRange(index) =>
      index >= 0 && index < 289 && (index ~/ GameConstants.totalInRow) % 2 == 0;
}

// int canMoveUp() {
//   if (inBoardRange(player2.position - (GameConstants.totalInRow * 2))) {
//     int index = fence.indexWhere((element) =>
//     element.position == player2.position - GameConstants.totalInRow);
//
//     if (fence[index].placed == false) {
//       if (player1.position ==
//           player2.position - (GameConstants.totalInRow * 2)) {
//         if (inBoardRange(player2.position - (GameConstants.totalInRow * 4))) {
//           index = fence.indexWhere((element) =>
//           element.position ==
//               player2.position - (GameConstants.totalInRow * 3));
//           if (fence[index].placed == false) {
//             return player2.position - (GameConstants.totalInRow * 4);
//           }
//         }
//       } else {
//         return player2.position - (GameConstants.totalInRow * 2);
//       }
//     }
//   }
//   return -1;
// }

// // Check if it's possible to move down for player2.
// int canMoveDown() {
//   if (inBoardRange(player2.position + (GameConstants.totalInRow * 2))) {
//     int index = fence.indexWhere((element) =>
//     element.position == player2.position + GameConstants.totalInRow);
//
//     if (fence[index].placed == false) {
//       if (player1.position ==
//           player2.position + (GameConstants.totalInRow * 2)) {
//         if (inBoardRange(player2.position + (GameConstants.totalInRow * 4))) {
//           index = fence.indexWhere((element) =>
//           element.position ==
//               player2.position + (GameConstants.totalInRow * 3));
//           if (fence[index].placed == false) {
//             return player2.position + (GameConstants.totalInRow * 4);
//           }
//         }
//       } else {
//         return player2.position + (GameConstants.totalInRow * 2);
//       }
//     }
//   }
//   return -1;
// }

// // Check if it's possible to move right for player2.
// int canMoveRight() {
//   if (inBoardRange(player2.position + 2)) {
//     int index = fence
//         .indexWhere((element) => element.position == player2.position + 1);
//
//     if (fence[index].placed == false) {
//       if (player1.position == player2.position + 2) {
//         if (inBoardRange(player2.position + 4)) {
//           index = fence.indexWhere(
//                   (element) => element.position == player2.position + 3);
//           if (fence[index].placed == false) {
//             return player2.position + 4;
//           }
//         }
//       } else {
//         return player2.position + 2;
//       }
//     }
//   }
//   return -1;
// }

// // Check if it's possible to move left for player2.
// int canMoveLeft() {
//   if (inBoardRange(player2.position - 2)) {
//     int index = fence
//         .indexWhere((element) => element.position == player2.position - 1);
//
//     if (fence[index].placed == false) {
//       if (player1.position == player2.position - 2) {
//         if (inBoardRange(player2.position - 4)) {
//           index = fence.indexWhere(
//                   (element) => element.position == player2.position - 3);
//           if (fence[index].placed == false) {
//             return player2.position - 4;
//           }
//         }
//       } else {
//         return player2.position - 2;
//       }
//     }
//   }
//   return -1;
// }
