import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/fence_model.dart';
import '../models/player_model.dart';
import 'package:quoridor/constants/game_constants.dart';

enum DragType {
  horizontalDrag,
  verticalDrag,
}

class GameController extends GetxController {
  late Player player1, player2;
  List<FenceModel> fence = [];
  List<int> path = [];
  List<int> possibleMoves = [];
  DragType? dragType;

  @override
  void onInit() {
    super.onInit();
    _buildBoard();
  }

  void resetGame() {
    _buildBoard();
  }

  void _buildBoard() {
    player1 = Player(position: 8, color: Colors.green, turn: false);
    player2 = Player(position: 280, color: Colors.orange, turn: true);

    for (int i = 0; i < GameConstants.totalInBoard; i++) {
      if ((i ~/ GameConstants.totalInRow) % 2 == 0) {
        if (i % 2 == 0) {
          path.add(i);
        } else {
          fence.add(FenceModel(
              position: i, placed: false, type: FenceType.verticalFence));
        }
      } else {
        if (i % 2 == 0) {
          fence.add(FenceModel(
            position: i,
            placed: false,
            type: FenceType.squareFence,
          ));
        } else {
          fence.add(FenceModel(
              position: i, placed: false, type: FenceType.horizontalFence));
        }
      }
    }

    possibleMoves = [];

    possibleMoves = player2.showPossibleMoves(fence, player1.position);

    update();
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

  void updateFences() {
    if (player1.turn) {
      player1.fences--;
    } else {
      player2.fences--;
    }
  }

  int fenceIndex(int i) => fence.indexWhere((element) => element.position == i);
}
