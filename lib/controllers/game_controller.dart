import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers.dart';
import '../models/fence_model.dart';
import '../models/player_model.dart';
import 'package:quoridor/utils/game_constants.dart';

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
  Timer? timer;
  RxString msg = "".obs;

  @override
  void onInit() {
    super.onInit();
    player1 = Player(position: 280, color: Colors.green, turn: true);
    player2 = Player(position: 8, color: Colors.orange, turn: false);
    _buildBoard();
  }

  void resetGame() {
    player1.position = 280;
    player1.fences.value = 10;
    player1.turn = true;

    player2.position = 8;
    player2.fences.value = 10;
    player2.turn = false;

    _buildBoard();
  }

  void _buildBoard() {
    path.clear();
    fence.clear();
    tempFence.clear();

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
    // getBestNextMove();

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
      if (dragType == DragType.verticalDrag) {
        if (fence[index].type == FenceType.verticalFence &&
            isNotLastRow(boardIndex) &&
            isValid(true, false, boardIndex)) {
          updateTemporaryFence(boardIndex, true, false, true);
        } else if (fence[index].type == FenceType.squareFence &&
            isValid(true, true, boardIndex)) {
          updateTemporaryFence(boardIndex, true, true, true);
        }
      } else if (dragType == DragType.horizontalDrag) {
        if (fence[index].type == FenceType.horizontalFence &&
            isNotLastColumn(boardIndex) &&
            isValid(false, false, boardIndex)) {
          updateTemporaryFence(boardIndex, false, false, true);
        } else if (fence[index].type == FenceType.squareFence &&
            isValid(false, true, boardIndex)) {
          updateTemporaryFence(boardIndex, false, true, true);
        }
      }
    }
  }

  void removeTemporaryFence(int boardIndex) {
    if (!outOfFences()) {
      int index = calcFenceIndex(boardIndex);
      if (dragType == DragType.verticalDrag) {
        if (fence[index].type == FenceType.verticalFence &&
            isNotLastRow(boardIndex)) {
          updateTemporaryFence(boardIndex, true, false, false);
        } else if (fence[index].type == FenceType.squareFence) {
          updateTemporaryFence(boardIndex, true, true, false);
        }
      } else if (dragType == DragType.horizontalDrag) {
        if (fence[index].type == FenceType.horizontalFence &&
            isNotLastColumn(boardIndex)) {
          updateTemporaryFence(boardIndex, false, false, false);
        } else if (fence[index].type == FenceType.squareFence) {
          updateTemporaryFence(boardIndex, false, true, false);
        }
      }
    }
  }

  void drawFence(int boardIndex) {
    if (!outOfFences()) {
      int index = calcFenceIndex(boardIndex);
      if (dragType == DragType.verticalDrag) {
        if (fence[index].type == FenceType.verticalFence &&
            isNotLastRow(boardIndex) &&
            isValid(true, false, boardIndex)) {
          updateFence(boardIndex, true, false);
        } else if (fence[index].type == FenceType.squareFence &&
            isValid(true, true, boardIndex)) {
          updateFence(boardIndex, true, true);
        }
        update();
      } else if (dragType == DragType.horizontalDrag) {
        if (fence[index].type == FenceType.horizontalFence &&
            isNotLastColumn(boardIndex) &&
            isValid(false, false, boardIndex)) {
          updateFence(boardIndex, false, false);
        } else if (fence[index].type == FenceType.squareFence &&
            isValid(false, true, boardIndex)) {
          updateFence(boardIndex, false, true);
        }
        update();
      }
    } else {
      popUpMessage('   There are no more\n walls for you to place');
    }
  }

  bool isValid(bool isVertical, bool isSquareFence, int boardIndex) {
    if (isVertical) {
      if (fence[calcFenceIndex(boardIndex)].placed == false &&
          fence[calcFenceIndex(boardIndex + GameConstants.totalInRow)].placed ==
              false) {
        if (isSquareFence) {
          return fence[calcFenceIndex(boardIndex - GameConstants.totalInRow)]
                  .placed ==
              false;
        } else {
          return fence[calcFenceIndex(
                      boardIndex + (GameConstants.totalInRow * 2))]
                  .placed ==
              false;
        }
      } else {
        return false;
      }
    } else {
      if (fence[calcFenceIndex(boardIndex)].placed == false &&
          fence[calcFenceIndex(boardIndex + 1)].placed == false) {
        if (isSquareFence) {
          return fence[calcFenceIndex(boardIndex - 1)].placed == false;
        } else {
          return fence[calcFenceIndex(boardIndex + 2)].placed == false;
        }
      } else {
        return false;
      }
    }
  }

  void updateTemporaryFence(
      int boardIndex, bool isVertical, bool isSquareFence, bool val) {
    fence[calcFenceIndex(boardIndex)].temporaryFence = val;
    if (isVertical) {
      fence[calcFenceIndex(boardIndex + GameConstants.totalInRow)]
          .temporaryFence = val;
      if (isSquareFence) {
        fence[calcFenceIndex(boardIndex - GameConstants.totalInRow)]
            .temporaryFence = val;
      } else {
        fence[calcFenceIndex(boardIndex + (GameConstants.totalInRow * 2))]
            .temporaryFence = val;
      }
    } else {
      fence[calcFenceIndex(boardIndex + 1)].temporaryFence = val;
      if (isSquareFence) {
        fence[calcFenceIndex(boardIndex - 1)].temporaryFence = val;
      } else {
        fence[calcFenceIndex(boardIndex + 2)].temporaryFence = val;
      }
    }
    update();
  }

  void updateFence(int boardIndex, bool isVertical, bool isSquareFence) {
    if (isValidFence(boardIndex, isVertical, isSquareFence)) {
      fence[calcFenceIndex(boardIndex)].placed = true;
      if (isVertical) {
        fence[calcFenceIndex(boardIndex + GameConstants.totalInRow)].placed =
            true;
        if (isSquareFence) {
          fence[calcFenceIndex(boardIndex - GameConstants.totalInRow)].placed =
              true;
        } else {
          fence[calcFenceIndex(boardIndex + (GameConstants.totalInRow * 2))]
              .placed = true;
        }
      } else {
        fence[calcFenceIndex(boardIndex + 1)].placed = true;
        if (isSquareFence) {
          fence[calcFenceIndex(boardIndex - 1)].placed = true;
        } else {
          fence[calcFenceIndex(boardIndex + 2)].placed = true;
        }
      }
      update();
      updateFencesNum();
      switchTurns();
    } else {
      updateTemporaryFence(boardIndex, isVertical, isSquareFence, false);
      popUpMessage('Placing a wall here will make\n    an unwinnable position');
    }
  }

  bool isValidFence(int boardIndex, bool isVertical, bool isSquareFence) {
    late bool returnedPlayer1;
    late bool returnedPlayer2;
    late int position1;
    late int position2;

    tempFence.clear();
    for (int i = 0; i < fence.length; i++) {
      tempFence.add(FenceModel.copy(obj: fence[i]));
    }

    tempFence[calcFenceIndex(boardIndex)].placed = true;
    if (isVertical) {
      tempFence[calcFenceIndex(boardIndex + GameConstants.totalInRow)].placed =
          true;
      if (isSquareFence) {
        tempFence[calcFenceIndex(boardIndex - GameConstants.totalInRow)]
            .placed = true;
      } else {
        tempFence[calcFenceIndex(boardIndex + (GameConstants.totalInRow * 2))]
            .placed = true;
      }
    } else {
      tempFence[calcFenceIndex(boardIndex + 1)].placed = true;
      if (isSquareFence) {
        tempFence[calcFenceIndex(boardIndex - 1)].placed = true;
      } else {
        tempFence[calcFenceIndex(boardIndex + 2)].placed = true;
      }
    }

    tempPlayer1 = Player.copy(obj: player1);
    tempPlayer2 = Player.copy(obj: player2);
    position1 = tempPlayer1!.position;
    position2 = tempPlayer2!.position;

    returnedPlayer1 = tempPlayer1!.canReachOtherSide(
        1, tempPlayer1!.position, tempPlayer2!.position, tempFence, []);
    returnedPlayer2 = tempPlayer2!.canReachOtherSide(
        2, tempPlayer2!.position, tempPlayer1!.position, tempFence, []);

    return returnedPlayer1 && returnedPlayer2;
  }

  void updateFencesNum() {
    if (player1.turn) {
      player1.fences.value--;
    } else {
      player2.fences.value--;
    }
  }

  bool outOfFences() {
    if (player1.turn) {
      return player1.outOfFences();
    } else {
      return player2.outOfFences();
    }
  }

  void popUpMessage(String message) {
    int count = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      msg.value = message;
      count++;
      if (count == 3) {
        msg.value = "";
        timer!.cancel();
      }
    });
  }

  void declareWinner() {
    if (reachedFirstRow(player1.position) || reachedLastRow(player2.position)) {
      Get.defaultDialog(
        title:
            reachedFirstRow(player1.position) ? "PLAYER 1 WON" : "PLAYER 2 WON",
        content: const Text(""),
        actions: [
          TextButton(
            child: const Text('Restart'),
            onPressed: () {
              Get.back();
              resetGame();
            },
          ),
        ],
      ).then((value) => resetGame());
    }
  }

  void getBestNextMove() {
    print('getBestNextMove');
    List<int> emptyFences = [];
    int? val;
    if (player1.turn) {
      tempPlayer1 = Player.copy(obj: player1);
      tempPlayer2 = Player.copy(obj: player2);
      if (player1.fences.value != 0) {
        val = Random().nextInt(2);
        if (val == 0) {
          // move the player
        } else {
          print('*************');
          // if value == 1
          // Put a fence
          emptyFences = getEmptyFencesIndexes();
          val = emptyFences[Random().nextInt(emptyFences.length)];
          print('val: $val');
          if (fence[calcFenceIndex(val)].type == FenceType.verticalFence) {
            updateFence(val, true, false);
          } else if (fence[calcFenceIndex(val)].type ==
              FenceType.horizontalFence) {
            updateFence(val, false, false);
          }
        }
      } else {
        // move the player
      }
    }
  }

  List<int> getEmptyFencesIndexes() {
    print('getEmptyFencesIndexes');
    List<int> emptyFences = [];
    for (int i = 0; i < GameConstants.totalInBoard; i++) {
      if ((i ~/ GameConstants.totalInRow) % 2 == 0) {
        if (i % 2 != 0 && isNotLastRow(i)) {
          if (fence[calcFenceIndex(i)].placed == false) {
            emptyFences.add(i);
          }
        }
      } else {
        if (i % 2 != 0 && isNotLastColumn(i)) {
          if (fence[calcFenceIndex(i)].placed == false) {
            emptyFences.add(i);
          }
        }
      }
    }
    print(emptyFences);
    // for (int i = 0; i < fence.length; i++) {
    //   if (fence[i].type == FenceType.verticalFence &&
    //       isNotLastRow(fence[i].position)) {
    //     if (fence[i].placed == false &&
    //         fence[calcFenceIndex(fence[i].position + GameConstants.totalInRow)]
    //                 .placed ==
    //             false &&
    //         fence[calcFenceIndex(
    //                     fence[i].position + (GameConstants.totalInRow * 2))]
    //                 .placed ==
    //             false) {
    //       emptyFences.add(fence[i].position);
    //     }
    //   } else if (fence[i].type == FenceType.horizontalFence &&
    //       isNotLastColumn(fence[i].position)) {
    //     if (fence[i].placed == false &&
    //         fence[calcFenceIndex(fence[i].position + 1)].placed == false &&
    //         fence[calcFenceIndex(fence[i].position + 2)].placed == false) {
    //       emptyFences.add(fence[i].position);
    //     }
    //   }
    // }
    return emptyFences;
  }
}
