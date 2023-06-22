import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers.dart';
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

    path.clear();
    fence.clear();

    for (int i = 0; i < GameConstants.totalInBoard; i++) {
      if ((i ~/ GameConstants.totalInRow) % 2 == 0) {
        if (i % 2 == 0) {
          path.add(i);
        } else {
          fence.add(FenceModel(
              position: i,
              placed: false,
              type: FenceType.verticalFence,
              temporaryFence: false));
        }
      } else {
        if (i % 2 == 0) {
          fence.add(FenceModel(
            position: i,
            placed: false,
            type: FenceType.squareFence,
            temporaryFence: false,
          ));
        } else {
          fence.add(FenceModel(
              position: i,
              placed: false,
              type: FenceType.horizontalFence,
              temporaryFence: false));
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
      calculatePossibleMoves();
      update();
    }
  }

  void switchTurns() {
    player1.changeTurn();
    player2.changeTurn();
  }

  void calculatePossibleMoves() {
    if (player1.turn) {
      possibleMoves = player1.showPossibleMoves(fence, player2.position);
    } else {
      possibleMoves = player2.showPossibleMoves(fence, player1.position);
    }
  }

  void changePosition(int index) {
    if (player1.turn) {
      player1.position = index;
    } else {
      player2.position = index;
    }
  }

  int calcFenceIndex(int i) =>
      fence.indexWhere((element) => element.position == i);

  void drawTemporaryFence(int boardIndex) {
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

  void removeTemporaryFence(int boardIndex) {
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

  void drawFence(int boardIndex) {
    int index = calcFenceIndex(boardIndex);
    if (dragType == DragType.verticalDrag &&
        fence[index].type == FenceType.verticalFence &&
        isNotLastRow(boardIndex) &&
        isValid(true, boardIndex)) {
      updateFence(boardIndex, true);
    } else if (dragType == DragType.horizontalDrag &&
        fence[index].type == FenceType.horizontalFence &&
        isNotLastColumn(boardIndex) &&
        isValid(false, boardIndex)) {
      updateFence(boardIndex, false);
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
}
