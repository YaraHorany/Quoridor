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
  Player? simulationP1, simulationP2;
  List<FenceModel> fence = [], simulationFence = [];
  List<int> squares = [], possibleMoves = [];
  DragType? dragType;
  Timer? timer;
  RxString msg = "".obs;
  late bool singlePlayer;
  bool simulationOn = false;
  int winner = -1;

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
    List<List<int>> doubleList = [];
    squares.clear();
    fence.clear();

    for (int i = 0; i < GameConstants.totalInBoard; i++) {
      if ((i ~/ GameConstants.totalInRow) % 2 == 0) {
        if (i % 2 == 0) {
          squares.add(i);
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

    // fence[calcFenceIndex(91)].placed = true;
    // fence[calcFenceIndex(92)].placed = true;
    // fence[calcFenceIndex(93)].placed = true;
    //
    // doubleList = player1.findMinPaths(
    //     player1.bfs(fence, player2.position), player2.position);
    // print('min paths:');
    // print(doubleList);
    // List<int> tempList = doubleList[Random().nextInt(doubleList.length)];
    // print(tempList);

    update();
  }

  void singlePlayerGame(bool mood) {
    singlePlayer = mood;
  }

  void move(int index) {
    if (possibleMoves.contains(index)) {
      changePosition(index);
      declareWinner();
      switchTurns();
      update();
      if (singlePlayer && player2.turn && !simulationOn) {
        getBestNextMove();
      }
    }
  }

  void switchTurns() {
    if (simulationOn) {
      simulationP1!.changeTurn();
      simulationP2!.changeTurn();
    } else {
      player1.changeTurn();
      player2.changeTurn();
    }
    calculatePossibleMoves();
  }

  void calculatePossibleMoves() {
    possibleMoves.clear();
    if (simulationOn) {
      if (simulationP1!.turn) {
        possibleMoves = simulationP1!
            .showPossibleMoves(simulationFence, simulationP2!.position);
      } else {
        possibleMoves = simulationP2!
            .showPossibleMoves(simulationFence, simulationP1!.position);
      }
    } else {
      if (player1.turn) {
        possibleMoves = player1.showPossibleMoves(fence, player2.position);
      } else {
        possibleMoves = player2.showPossibleMoves(fence, player1.position);
      }
    }
  }

  void changePosition(int index) {
    if (simulationOn) {
      if (simulationP1!.turn) {
        simulationP1!.position = index;
      } else {
        simulationP2!.position = index;
      }
    } else {
      if (player1.turn) {
        player1.position = index;
      } else {
        player2.position = index;
      }
    }
  }

  int calcFenceIndex(int i) {
    if (simulationOn) {
      return simulationFence.indexWhere((element) => element.position == i);
    }
    return fence.indexWhere((element) => element.position == i);
  }

  void drawFence(int boardIndex) {
    if (!outOfFences()) {
      int index = calcFenceIndex(boardIndex);
      if (dragType == DragType.verticalDrag) {
        if (fence[index].type == FenceType.verticalFence ||
            fence[index].type == FenceType.squareFence) {
          if (fence[index].type == FenceType.squareFence) {
            boardIndex -= GameConstants.totalInRow;
            index = calcFenceIndex(boardIndex);
          }
          if (isNotLastRow(boardIndex) && isValid(true, boardIndex)) {
            updateFence(boardIndex, fence, true, false);
          }
        }
        update();
      } else if (dragType == DragType.horizontalDrag) {
        if (fence[index].type == FenceType.horizontalFence ||
            fence[index].type == FenceType.squareFence) {
          if (fence[index].type == FenceType.squareFence) {
            boardIndex -= 1;
            index = calcFenceIndex(boardIndex);
          }
          if (isNotLastColumn(boardIndex) && isValid(false, boardIndex)) {
            updateFence(boardIndex, fence, false, false);
          }
        }
        update();
      }
    } else {
      popUpMessage('   There are no more\n walls for you to place');
    }
  }

  void drawTemporaryFence(int boardIndex, bool val) {
    if (!outOfFences()) {
      int index = calcFenceIndex(boardIndex);
      if (dragType == DragType.verticalDrag) {
        if (fence[index].type == FenceType.verticalFence ||
            fence[index].type == FenceType.squareFence) {
          if (fence[index].type == FenceType.squareFence) {
            boardIndex -= GameConstants.totalInRow;
            index = calcFenceIndex(boardIndex);
          }
          if (isNotLastRow(boardIndex) && isValid(true, boardIndex)) {
            updateTemporaryFence(boardIndex, true, val);
          }
        }
      } else if (dragType == DragType.horizontalDrag) {
        if (fence[index].type == FenceType.horizontalFence ||
            fence[index].type == FenceType.squareFence) {
          if (fence[index].type == FenceType.squareFence) {
            boardIndex -= 1;
            index = calcFenceIndex(boardIndex);
          }
          if (isNotLastColumn(boardIndex) && isValid(false, boardIndex)) {
            updateTemporaryFence(boardIndex, false, val);
          }
        }
      }
    }
  }

  bool isValid(bool isVertical, int boardIndex) {
    if (isVertical) {
      return fence[calcFenceIndex(boardIndex)].placed == false &&
          fence[calcFenceIndex(boardIndex + GameConstants.totalInRow)].placed ==
              false &&
          fence[calcFenceIndex(boardIndex + (GameConstants.totalInRow * 2))]
                  .placed ==
              false;
    } else {
      return fence[calcFenceIndex(boardIndex)].placed == false &&
          fence[calcFenceIndex(boardIndex + 1)].placed == false &&
          fence[calcFenceIndex(boardIndex + 2)].placed == false;
    }
  }

  int updateFence(int boardIndex, List<FenceModel> fence, bool isVertical,
      bool isSquareDrag) {
    if (canReachOtherSide(boardIndex, isVertical)) {
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
      if (singlePlayer && player2.turn && !simulationOn) {
        getBestNextMove();
      }
      return 1;
    } else {
      if (simulationOn) return -1;
      updateTemporaryFence(boardIndex, isVertical, false);
      popUpMessage('Placing a wall here will make\n    an unwinnable position');
      return 1;
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

  // Checking that both players are NOT completely blocked from reaching the opposing baseline
  bool canReachOtherSide(int boardIndex, bool isVertical) {
    late Player tempPlayer1, tempPlayer2;
    List<FenceModel> tempFence = [];
    if (simulationOn) {
      for (int i = 0; i < simulationFence.length; i++) {
        tempFence.add(FenceModel.copy(obj: simulationFence[i]));
      }
    } else {
      for (int i = 0; i < fence.length; i++) {
        tempFence.add(FenceModel.copy(obj: fence[i]));
      }
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

    if (simulationOn) {
      tempPlayer1 = Player.copy(obj: simulationP1!);
      tempPlayer2 = Player.copy(obj: simulationP2!);
    } else {
      tempPlayer1 = Player.copy(obj: player1);
      tempPlayer2 = Player.copy(obj: player2);
    }
    return tempPlayer1.bfsSearch(tempFence) && tempPlayer2.bfsSearch(tempFence);
  }

  void updateFencesNum() {
    if (simulationOn) {
      if (simulationP1!.turn) {
        simulationP1!.fences.value--;
      } else {
        simulationP2!.fences.value--;
      }
    } else {
      if (player1.turn) {
        player1.fences.value--;
      } else {
        player2.fences.value--;
      }
    }
  }

  bool outOfFences() {
    if (simulationOn) {
      if (simulationP1!.turn) {
        return simulationP1!.outOfFences();
      } else {
        return simulationP2!.outOfFences();
      }
    } else {
      if (player1.turn) {
        return player1.outOfFences();
      } else {
        return player2.outOfFences();
      }
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
    // print('check winner');
    if (simulationOn) {
      if (reachedFirstRow(simulationP1!.position)) {
        winner = 1;
      } else if (reachedLastRow(simulationP2!.position)) {
        winner = 2;
      }
      return;
    }
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

  // Implementation of Quoridor AI based on MonteCarlo tree search
  void getBestNextMove() {
    Player? tempPlayer1, tempPlayer2;
    List<List<int>> possiblePaths = [];
    Map<int, int> evaluations = {};
    late int randomPosition;
    simulationOn = true;
    int returned = -1;
    late int score;
    late int firstMove;
    double highestScore = -1.0 / 0.0; // minus infinity
    late int bestMove;

    for (int i = 0; i < 1000; i++) {
      // print("***********************************");
      // print('SIMULATION NUMBER ${i + 1}');
      // print("***********************************");
      firstMove = -1;
      winner = -1;
      List<int> emptyFences = [];
      score = 10000;

      simulationFence.clear();
      for (int j = 0; j < fence.length; j++) {
        simulationFence.add(FenceModel.copy(obj: fence[j]));
      }

      simulationP1 = Player.copy(obj: player1);
      simulationP1!.fences.value = player1.fences.value;
      simulationP2 = Player.copy(obj: player2);
      simulationP2!.fences.value = player2.fences.value;

      calculatePossibleMoves();
      while (true) {
        if (Random().nextInt(2) == 0 || outOfFences()) {
          tempPlayer1 = Player.copy(obj: simulationP1!);
          tempPlayer2 = Player.copy(obj: simulationP2!);

          if (simulationP1!.turn) {
            possiblePaths = tempPlayer1.findMinPaths(
                tempPlayer1.bfs(simulationFence, tempPlayer2.position),
                tempPlayer2.position);
          } else {
            possiblePaths = tempPlayer2.findMinPaths(
                tempPlayer2.bfs(simulationFence, tempPlayer1.position),
                tempPlayer1.position);
          }
          if (possiblePaths.isEmpty) {
            // Pick randomly one of the possible moves.
            randomPosition =
                possibleMoves[Random().nextInt(possibleMoves.length)];
            move(randomPosition);
            // print('player1 pos: ${simulationP1!.position}');
            // print('player2 pos: ${simulationP2!.position}');
            // for (int z = 0; z < simulationFence.length; z++) {
            //   if (simulationFence[z].placed == true) {
            //     print('simulationFence[z]: ${simulationFence[z].position}');
            //   }
            // }
            // if (simulationP1!.turn) {
            //   print('PLAYER 1:');
            //   List<int> justForPrinting =
            //       tempPlayer1!.bfs(simulationFence, tempPlayer2!.position);
            //   for (int t = 0; t < justForPrinting.length; t++) {
            //     print('index: $t');
            //     print(justForPrinting[t]);
            //   }
            // } else {
            //   print('PLAYER 2:');
            //   List<int> justForPrinting =
            //       tempPlayer2!.bfs(simulationFence, tempPlayer1!.position);
            //   for (int t = 0; t < justForPrinting.length; t++) {
            //     print('index: $t');
            //     print(justForPrinting[t]);
            //   }
            // }
          } else {
            // Pick randomly one of the shortest paths to the target side
            randomPosition =
                possiblePaths[Random().nextInt(possiblePaths.length)][1];
          }

          move(randomPosition);
          // print("randomPosition: $randomPosition");

          // randomPosition =
          //     possibleMoves[Random().nextInt(possibleMoves.length)];
          // move(randomPosition);
        } else {
          // Randomly choose to move or to place a fence
          // if value == 1 place a fence
          returned = -1;
          emptyFences = getEmptyFencesIndexes(simulationFence);
          while (returned == -1) {
            randomPosition = emptyFences[Random().nextInt(emptyFences.length)];
            if (simulationFence[calcFenceIndex(randomPosition)].type ==
                FenceType.verticalFence) {
              returned =
                  updateFence(randomPosition, simulationFence, true, false);
            } else if (simulationFence[calcFenceIndex(randomPosition)].type ==
                FenceType.horizontalFence) {
              returned =
                  updateFence(randomPosition, simulationFence, false, false);
            }
            emptyFences.remove(randomPosition);
            // print('placed a fence in: $randomPosition');
          }
        }

        if (firstMove == -1) {
          firstMove = randomPosition;
        }
        if (winner != -1) break;
        score -= 1;
      }

      if (winner == 1) {
        score *= -1;
      }

      if (evaluations.containsKey(firstMove)) {
        evaluations.update(firstMove, (value) => value += score);
      } else {
        evaluations[firstMove] = score;
      }
    }
    for (var key in evaluations.keys) {
      if (evaluations[key]! > highestScore) {
        highestScore = (evaluations[key]!).toDouble();
        bestMove = key;
      }
    }
    simulationOn = false;

    if (squares.contains(bestMove)) {
      changePosition(bestMove);
      switchTurns();
    } else if ((bestMove ~/ GameConstants.totalInRow) % 2 == 0) {
      updateFence(bestMove, fence, true, false);
    } else {
      updateFence(bestMove, fence, false, false);
    }
    declareWinner();
  }

  List<int> getEmptyFencesIndexes(List<FenceModel> fence) {
    List<int> emptyFences = [];
    for (int i = 0; i < GameConstants.totalInBoard; i++) {
      if ((i ~/ GameConstants.totalInRow) % 2 == 0) {
        // check vertical fences
        if (i % 2 != 0 && isNotLastRow(i)) {
          if (fence[calcFenceIndex(i)].placed == false &&
              fence[calcFenceIndex(i + GameConstants.totalInRow)].placed ==
                  false &&
              fence[calcFenceIndex(i + (GameConstants.totalInRow * 2))]
                      .placed ==
                  false) {
            emptyFences.add(i);
          }
        }
      } else {
        // check horizontal fences
        if (i % 2 != 0 && isNotLastColumn(i)) {
          if (fence[calcFenceIndex(i)].placed == false &&
              fence[calcFenceIndex(i + 1)].placed == false &&
              fence[calcFenceIndex(i + 2)].placed == false) {
            emptyFences.add(i);
          }
        }
      }
    }
    return emptyFences;
  }
}
