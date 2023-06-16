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
              position: i,
              color: Colors.blue,
              type: FenceType.verticalRectangle));
        }
      } else {
        if (i % 2 == 0) {
          fence.add(Fence(
            position: i,
            color: Colors.blue,
            type: FenceType.square,
          ));
        } else {
          fence.add(Fence(
              position: i,
              color: Colors.blue,
              type: FenceType.horizontalRectangle));
        }
      }
    }
  }

  void play() {
    player1.moveForward();
    player2.moveBackward();
    update();
  }

  // The pawns are moved one square at a time, horizontally or vertically, forwards or backwards, never diagonally.
  void checkOptionalMove() {}
}
