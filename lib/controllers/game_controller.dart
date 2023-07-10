import 'dart:async';
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
  Player? tempPlayer1, tempPlayer2;
  List<FenceModel> fence = [];
  List<FenceModel> tempFence = [];
  List<int> path = [];
  List<int> possibleMoves = [];
  DragType? dragType;
  RxString winner = "".obs;
  Timer? timer;
  RxString msg = "".obs;

  @override
  void onInit() {
    super.onInit();
    _buildBoard();
  }

  void resetGame() {
    _buildBoard();
  }

  void _buildBoard() {
    player1 = Player(position: 280, color: Colors.green, turn: true);
    player2 = Player(position: 8, color: Colors.orange, turn: false);

    path.clear();
    fence.clear();
    tempFence.clear();
    winner.value = "";

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

    possibleMoves = player1.showPossibleMoves(fence, player2.position);

    update();
  }

  void move(int index) {
    if (possibleMoves.contains(index)) {
      changePosition(index);
      declareWinner();
      switchTurns();
      update();
    }
  }

  void switchTurns() {
    player1.changeTurn();
    player2.changeTurn();
    calculatePossibleMoves();
  }

  void calculatePossibleMoves() {
    possibleMoves.clear();
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
    if (!outOfFences()) {
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
  }

  void removeTemporaryFence(int boardIndex) {
    if (!outOfFences()) {
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
  }

  void drawFence(int boardIndex) {
    if (!outOfFences()) {
      int index = calcFenceIndex(boardIndex);
      if (dragType == DragType.verticalDrag &&
          fence[index].type == FenceType.verticalFence &&
          isNotLastRow(boardIndex) &&
          isValid(true, boardIndex)) {
        updateFence(boardIndex, true);
        // switchTurns();
        update();
      } else if (dragType == DragType.horizontalDrag &&
          fence[index].type == FenceType.horizontalFence &&
          isNotLastColumn(boardIndex) &&
          isValid(false, boardIndex)) {
        updateFence(boardIndex, false);
        // switchTurns();
        update();
      }
    } else {
      outOfFencesMsg();
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
    if (isValidFence(boardIndex, isVertical)) {
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
      switchTurns();
    } else {
      updateTemporaryFence(boardIndex, isVertical, false);
      unWinnableStepMessage();
    }
  }

  bool isValidFence(int boardIndex, bool isVertical) {
    tempFence.clear();
    for (int i = 0; i < fence.length; i++) {
      tempFence.add(FenceModel.copy(obj: fence[i]));
    }

    tempFence[calcFenceIndex(boardIndex)].placed = true;
    if (isVertical) {
      tempFence[calcFenceIndex(boardIndex + GameConstants.totalInRow)].placed =
          true;
      tempFence[calcFenceIndex(boardIndex + (GameConstants.totalInRow * 2))]
          .placed = true;
    } else {
      tempFence[calcFenceIndex(boardIndex + 1)].placed = true;
      tempFence[calcFenceIndex(boardIndex + 2)].placed = true;
    }

    tempPlayer1 = Player.copy(obj: player1);
    tempPlayer2 = Player.copy(obj: player2);
    return canReachOtherSide(tempPlayer1!, []);
  }

  canReachOtherSide(Player tempPlayer, List<int> usedPositions) {
    int? prevPosition;
    bool? val;
    List<int> tempPossibleMoves = [];
    if (reachedFirstRow(tempPlayer1!.position)) {
      return true;
    }
    tempPossibleMoves =
        tempPlayer1!.showPossibleMoves(tempFence, tempPlayer2!.position);
    for (int i = 0; i < 4; i++) {
      if (tempPossibleMoves[i] != -1 &&
          !usedPositions.contains(tempPossibleMoves[i])) {
        prevPosition = tempPlayer1!.position;
        tempPlayer1!.position = tempPossibleMoves[i];
        val = canReachOtherSide(tempPlayer1!, usedPositions + [prevPosition]);
        if (val == true) {
          return true;
        }
        tempPlayer1!.position = prevPosition;
      }
    }
    if (tempPlayer1!.position == player1.position) {
      return false;
    }
  }

  void updateFencesNum() {
    if (player1.turn) {
      player1.fences--;
    } else {
      player2.fences--;
    }
  }

  bool outOfFences() {
    if (player1.turn) {
      return player1.outOfFences();
    } else {
      return player2.outOfFences();
    }
  }

  void outOfFencesMsg() {
    int count = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      msg.value = 'There are no more\n walls for you to place';
      count++;
      if (count == 4) {
        msg.value = "";
        timer!.cancel();
      }
    });
  }

  void unWinnableStepMessage() {
    int count = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      msg.value = 'Placing a wall here\n will make an unwinnable position';
      count++;
      if (count == 4) {
        msg.value = "";
        timer!.cancel();
      }
    });
  }

  void declareWinner() {
    if (reachedFirstRow(player1.position)) {
      winner.value = 'player 1 won';
    } else if (reachedLastRow(player2.position)) {
      winner.value = 'player 2 won';
    }
  }
}
