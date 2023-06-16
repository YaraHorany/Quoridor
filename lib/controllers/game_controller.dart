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
          fence.add(Fence(
              position: i, placed: false, type: FenceType.verticalRectangle));
        }
      } else {
        if (i % 2 == 0) {
          fence.add(Fence(
            position: i,
            placed: false,
            type: FenceType.square,
          ));
        } else {
          fence.add(Fence(
              position: i, placed: false, type: FenceType.horizontalRectangle));
        }
      }
    }
  }

  void play() {
    // player1.moveForward();
    checkOptionalMove();
    update();
  }

  // The pawns are moved one square at a time, horizontally or vertically, forwards or backwards, never diagonally.
  void checkOptionalMove() {
    moveForward();
  }

  void moveForward() {
    // Check if it's possible to move forward for player2.
    if (!inBoardRange(player2.position - 17)) {
      print("can't move forward");
      return;
    }

    int index = fence.indexWhere((element) =>
        element.position == player2.position - GameConstants.totalInRow);

    if (fence[index].placed == true) {
      print("Fence in front of me, can't move forward");
    } else if (player1.position ==
        player2.position - (GameConstants.totalInRow * 2)) {
      if (!inBoardRange(player2.position - 51)) {
        print("can't move forward");
        return;
      }

      index = fence.indexWhere((element) =>
          element.position ==
          player2.position - (GameConstants.totalInRow * 3));

      if (fence[index].placed == false) {
        player2.moveUp(2); // move 2 steps up
      } else {
        print("unfortunately, can't move forward!!!");
      }
    } else {
      player2.moveUp(1); // move one step up
    }
  }

  bool inBoardRange(index) => index >= 0 && index < 289;
}
