import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/fence_model.dart';
import '../models/player_model.dart';
import 'package:quoridor/constants/game_constants.dart';

class GameController extends GetxController {
  late Player player1, player2;
  List<Fence> fence = [];
  List<int> path = [];
  List<int> possibleMoves = [];

  @override
  void onInit() {
    super.onInit();
    buildBoard();
  }

  void buildBoard() {
    player1 = Player(position: 8, color: Colors.green, fences: 10, turn: false);
    player2 =
        Player(position: 280, color: Colors.orange, fences: 10, turn: true);

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

    possibleMoves = [];

    possibleMoves = player2.showPossibleMoves(fence, player1.position);
  }

  void play(int index) {
    if (possibleMoves.contains(index)) {
      changePosition(index);
      possibleMoves.clear();
      switchTurns();
      if (player1.turn) {
        possibleMoves = player1.showPossibleMoves(fence, player2.position);
      } else {
        possibleMoves = player2.showPossibleMoves(fence, player1.position);
      }
      update();
    }
  }

  void switchTurns() {
    player1.changeTurn();
    player2.changeTurn();
  }

  void changePosition(int index) {
    if (player1.turn) {
      player1.position = index;
    } else {
      player2.position = index;
    }
    update();
  }
}
