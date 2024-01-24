import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers.dart';
import '../models/fence_model.dart';
import '../models/tree_node.dart';
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
  List<int> squares = [], possibleMoves = [], emptyFences = [];
  DragType? dragType;
  RxString msg = "".obs;
  late bool singlePlayer;
  bool simulationOn = false;

  bool aiFirstMove = true;
  int turn = 0, simulationTurn = 0;

  @override
  void onInit() {
    super.onInit();

    player1 = Player(position: 280, color: Colors.green, turn: true);
    player2 = Player(position: 8, color: Colors.orange, turn: false);

    // temporary
    // player1 = Player(position: 110, color: Colors.green, turn: true);
    // player2 = Player(position: 112, color: Colors.orange, turn: false);

    // TEMPORARY - DELETE IT LATER
    // player1.fences.value = 9;
    // player2.fences.value = 8;

    _buildBoard();
  }

  void resetGame() {
    player1.position = 280;
    player1.fences.value = 10;
    player1.turn = true;

    player2.position = 8;
    player2.fences.value = 10;
    player2.turn = false;

    aiFirstMove = true;
    turn = 0;
    simulationTurn = 0;

    _buildBoard();
  }

  void _buildBoard() {
    squares.clear();
    fence.clear();

    for (int i = 0; i < GameConstants.totalInBoard; i++) {
      if ((i ~/ GameConstants.totalInRow) % 2 == 0) {
        if (i % 2 == 0) {
          squares.add(i);
          fence.add(FenceModel()); // Add a null object
        } else {
          fence.add(FenceModel(
              placed: false,
              type: FenceType.verticalFence,
              temporaryFence: false));
          if (isNotLastRow(i)) {
            emptyFences.add(i);
          }
        }
      } else {
        if (i % 2 == 0) {
          fence.add(FenceModel(
            placed: false,
            type: FenceType.squareFence,
            temporaryFence: false,
          ));
        } else {
          fence.add(FenceModel(
              placed: false,
              type: FenceType.horizontalFence,
              temporaryFence: false));
          if (isNotLastColumn(i)) {
            emptyFences.add(i);
          }
        }
      }
    }

    // Player 1 starts first.
    possibleMoves = player1.showPossibleMoves(fence, player2.position);
    update();
  }

  void singlePlayerGame(bool mood) {
    singlePlayer = mood;
  }

  void move(int index) {
    if (possibleMoves.contains(index)) {
      changePosition(index);
      if (_winnerFound()) return;
      switchTurns();
      if (singlePlayer && player2.turn) {
        aiMove();
      }
    }
  }

  // Switch turns and calculate possible moves for next player.
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
      simulationTurn++;
      if (simulationP1!.turn) {
        simulationP1!.position = index;
      } else {
        simulationP2!.position = index;
      }
    } else {
      turn++;
      if (player1.turn) {
        player1.position = index;
      } else {
        player2.position = index;
      }
      update();
    }
  }

  void drawFence(int boardIndex) {
    if (!outOfFences()) {
      if (dragType == DragType.verticalDrag) {
        if (fence[boardIndex].type != FenceType.horizontalFence) {
          if (fence[boardIndex].type == FenceType.squareFence) {
            boardIndex -= GameConstants.totalInRow;
          }
          if (isNotLastRow(boardIndex) &&
              isAvailable(fence, true, boardIndex)) {
            checkAndUpdateFence(boardIndex, fence, true);
          }
        }
      } else {
        if (fence[boardIndex].type != FenceType.verticalFence) {
          if (fence[boardIndex].type == FenceType.squareFence) {
            boardIndex -= 1;
          }
          if (isNotLastColumn(boardIndex) &&
              isAvailable(fence, false, boardIndex)) {
            checkAndUpdateFence(boardIndex, fence, false);
          }
        }
      }
    } else {
      popUpMessage('   There are no more\n walls for you to place');
    }
  }

  void drawTemporaryFence(int boardIndex, bool val) {
    if (!outOfFences()) {
      if (dragType == DragType.verticalDrag) {
        if (fence[boardIndex].type != FenceType.horizontalFence) {
          if (fence[boardIndex].type == FenceType.squareFence) {
            boardIndex -= GameConstants.totalInRow;
          }
          if (isNotLastRow(boardIndex) &&
              isAvailable(fence, true, boardIndex)) {
            updateTemporaryFence(boardIndex, true, val);
          }
        }
      } else {
        if (fence[boardIndex].type != FenceType.verticalFence) {
          if (fence[boardIndex].type == FenceType.squareFence) {
            boardIndex -= 1;
          }
          if (isNotLastColumn(boardIndex) &&
              isAvailable(fence, false, boardIndex)) {
            updateTemporaryFence(boardIndex, false, val);
          }
        }
      }
    }
  }

  // Check if it's possible to place a fence
  bool isAvailable(List<FenceModel> fence, bool isVertical, int index) {
    if (isVertical) {
      return fence[index].placed == false &&
          fence[index + GameConstants.totalInRow].placed == false &&
          fence[index + (GameConstants.totalInRow * 2)].placed == false;
    } else {
      return fence[index].placed == false &&
          fence[index + 1].placed == false &&
          fence[index + 2].placed == false;
    }
  }

  void checkAndUpdateFence(
      int boardIndex, List<FenceModel> fence, bool isVertical) {
    if (canReachOtherSide(boardIndex, isVertical)) {
      // placeFence(fence, boardIndex, isVertical, false, true);
      placeFence(fence, boardIndex, isVertical, true, false);
      switchTurns();
      if (singlePlayer && player2.turn) {
        aiMove();
      }
    } else {
      updateTemporaryFence(boardIndex, isVertical, false);
      popUpMessage('Placing a wall here will make\n    an unwinnable position');
    }
  }

  // Place a fence vertically or horizontally and update fences number.
  void placeFence(List<FenceModel> fence, int boardIndex, bool isVertical,
      bool val, bool isTemp) {
    isVertical
        ? _placeVerticalFence(fence, boardIndex, val)
        : _placeHorizontalFence(fence, boardIndex, val);
    update();
    if (!isTemp) {
      simulationOn ? simulationTurn++ : turn++;
    }
    _changeFencesNum(val);
  }

  // Increase OR decrease fences num by one.
  void _changeFencesNum(bool val) {
    if (simulationOn) {
      if (simulationP1!.turn) {
        simulationP1!.fences.value += (val == true) ? -1 : 1;
      } else {
        simulationP2!.fences.value += (val == true) ? -1 : 1;
      }
    } else {
      if (player1.turn) {
        player1.fences.value += (val == true) ? -1 : 1;
      } else {
        player2.fences.value += (val == true) ? -1 : 1;
      }
    }
  }

  // Place a vertical fence.
  void _placeVerticalFence(List<FenceModel> fence, int boardIndex, bool val) {
    for (int i = 0; i < GameConstants.fenceLength; i++) {
      fence[boardIndex + (GameConstants.totalInRow * i)].placed = val;
    }
  }

  // Place a horizontal fence.
  void _placeHorizontalFence(List<FenceModel> fence, int boardIndex, bool val) {
    for (int i = 0; i < GameConstants.fenceLength; i++) {
      fence[boardIndex + i].placed = val;
    }
  }

  void updateTemporaryFence(int boardIndex, bool isVertical, bool val) {
    fence[boardIndex].temporaryFence = val;
    if (isVertical) {
      fence[boardIndex + GameConstants.totalInRow].temporaryFence = val;

      fence[boardIndex + (GameConstants.totalInRow * 2)].temporaryFence = val;
    } else {
      fence[boardIndex + 1].temporaryFence = val;

      fence[boardIndex + 2].temporaryFence = val;
    }
    update();
  }

  bool testIfAdjacentToOtherWallForVerticalWallTop(
      int boardIndex, List<FenceModel> fence) {
    // print('A');
    if (inBoardRange(boardIndex - (GameConstants.totalInRow * 2))) {
      if (fence[boardIndex - GameConstants.totalInRow - 1].placed! ||
          fence[boardIndex - GameConstants.totalInRow + 1].placed! ||
          fence[boardIndex - (GameConstants.totalInRow * 2)].placed!) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  bool testIfAdjacentToOtherWallForVerticalWallBottom(
      int boardIndex, List<FenceModel> fence) {
    // print('B');
    if (inBoardRange(boardIndex + (GameConstants.totalInRow * 4))) {
      if (fence[boardIndex + (GameConstants.totalInRow * 3) - 1].placed! ||
          fence[boardIndex + (GameConstants.totalInRow * 3) + 1].placed! ||
          fence[boardIndex + (GameConstants.totalInRow * 4)].placed!) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  bool testIfAdjacentToOtherWallForVerticalWallMiddle(
      int boardIndex, List<FenceModel> fence) {
    // print('C');
    if (fence[boardIndex + GameConstants.totalInRow - 1].placed! ||
        fence[boardIndex + GameConstants.totalInRow + 1].placed!) {
      return true;
    }
    return false;
  }

  bool testIfConnectedOnTwoPointsForVerticalWall(
      int boardIndex, List<FenceModel> fence) {
    // print('D');
    bool top = testIfAdjacentToOtherWallForVerticalWallTop(boardIndex, fence);
    bool bottom =
        testIfAdjacentToOtherWallForVerticalWallBottom(boardIndex, fence);
    bool middle =
        testIfAdjacentToOtherWallForVerticalWallMiddle(boardIndex, fence);
    return (top && bottom) || (top && middle) || (bottom && middle);
  }

  bool testIfAdjacentToOtherWallForHorizontalWallLeft(
      int boardIndex, List<FenceModel> fence) {
    // print('E');
    if (boardIndex % GameConstants.totalInRow != 0) {
      if (fence[boardIndex - 1 - GameConstants.totalInRow].placed! ||
          fence[boardIndex - 1 + GameConstants.totalInRow].placed! ||
          fence[boardIndex - 4].placed!) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  bool testIfAdjacentToOtherWallForHorizontalWallRight(
      int boardIndex, List<FenceModel> fence) {
    // print('F');
    if (boardIndex % GameConstants.totalInRow != 14) {
      if (fence[boardIndex + 3 - GameConstants.totalInRow].placed! ||
          fence[boardIndex + 3 + GameConstants.totalInRow].placed! ||
          fence[boardIndex + 4].placed!) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  bool testIfAdjacentToOtherWallForHorizontalWallMiddle(
      int boardIndex, List<FenceModel> fence) {
    // print('G');
    if (fence[boardIndex + 1 - GameConstants.totalInRow].placed! ||
        fence[boardIndex + 1 + GameConstants.totalInRow].placed!) {
      return true;
    }
    return false;
  }

  bool testIfConnectedOnTwoPointsForHorizontalWall(
      int boardIndex, List<FenceModel> fence) {
    // print('H');
    bool left =
        testIfAdjacentToOtherWallForHorizontalWallLeft(boardIndex, fence);
    bool right =
        testIfAdjacentToOtherWallForHorizontalWallRight(boardIndex, fence);
    bool middle =
        testIfAdjacentToOtherWallForHorizontalWallMiddle(boardIndex, fence);
    return (left && right) || (left && middle) || (right && middle);
  }

  // Checking that both players are NOT completely blocked from reaching the opposing baseline
  bool canReachOtherSide(int boardIndex, bool isVertical) {
    late Player tempPlayer1, tempPlayer2;
    late bool result;

    if (isVertical) {
      if (!testIfConnectedOnTwoPointsForVerticalWall(
          boardIndex, simulationOn ? simulationFence : fence)) {
        return true;
      }
    } else {
      if (!testIfConnectedOnTwoPointsForHorizontalWall(
          boardIndex, simulationOn ? simulationFence : fence)) {
        return true;
      }
    }

    if (simulationOn) {
      tempPlayer1 = Player.copy(obj: simulationP1!);
      tempPlayer2 = Player.copy(obj: simulationP2!);

      // place a temporary fence.
      placeFence(simulationFence, boardIndex, isVertical, true, true);
      result = tempPlayer1.bfsSearch(simulationFence) &&
          tempPlayer2.bfsSearch(simulationFence);
      // remove temporary fence.
      placeFence(simulationFence, boardIndex, isVertical, false, true);
    } else {
      tempPlayer1 = Player.copy(obj: player1);
      tempPlayer2 = Player.copy(obj: player2);

      // place a temporary fence.
      placeFence(fence, boardIndex, isVertical, true, true);
      result = tempPlayer1.bfsSearch(fence) && tempPlayer2.bfsSearch(fence);
      // remove temporary fence.
      placeFence(fence, boardIndex, isVertical, false, true);
    }

    return result;
  }

  List<int> getFencesNextPlayer(int position) {
    // print('position $position');
    List<int> fencesNextPlayer = [];
    if (position >= (GameConstants.totalInRow * 2)) {
      // print('row >= 1');
      if (position % (GameConstants.totalInRow * 2) >= 2) {
        // print('col >= 1');
        if (isAvailable(simulationFence, false,
                position - GameConstants.totalInRow - 2) &&
            canReachOtherSide(position - GameConstants.totalInRow - 2, false)) {
          fencesNextPlayer.add(position - GameConstants.totalInRow - 2);
        }
        if (isAvailable(simulationFence, true,
                position - (GameConstants.totalInRow * 2) - 1) &&
            canReachOtherSide(
                position - (GameConstants.totalInRow * 2) - 1, true)) {
          fencesNextPlayer.add(position - (GameConstants.totalInRow * 2) - 1);
        }
        if (position % (GameConstants.totalInRow * 2) >= 4 &&
            isAvailable(simulationFence, false,
                position - GameConstants.totalInRow - 4) &&
            canReachOtherSide(position - GameConstants.totalInRow - 4, false)) {
          // print("col >= 2");
          fencesNextPlayer.add(position - GameConstants.totalInRow - 4);
        }
      }
      if (position % (GameConstants.totalInRow * 2) <= 14) {
        // print('col <= 7');
        if (isAvailable(
                simulationFence, false, position - GameConstants.totalInRow) &&
            canReachOtherSide(position - GameConstants.totalInRow, false)) {
          fencesNextPlayer.add(position - GameConstants.totalInRow);
        }
        if (isAvailable(simulationFence, true,
                position - (GameConstants.totalInRow * 2) + 1) &&
            canReachOtherSide(
                position - (GameConstants.totalInRow * 2) + 1, true)) {
          fencesNextPlayer.add(position - (GameConstants.totalInRow * 2) + 1);
        }
        if (position % (GameConstants.totalInRow * 2) <= 12 &&
            isAvailable(simulationFence, false,
                position - GameConstants.totalInRow + 2) &&
            canReachOtherSide(position - GameConstants.totalInRow + 2, false)) {
          // print('col <= 6');
          fencesNextPlayer.add(position - GameConstants.totalInRow + 2);
        }
      }
      if (position >= (GameConstants.totalInRow) * 4) {
        // print('row >= 2');
        if (position % (GameConstants.totalInRow * 2) >= 2 &&
            isAvailable(simulationFence, true,
                position - (GameConstants.totalInRow * 4) - 1) &&
            canReachOtherSide(
                position - (GameConstants.totalInRow * 4) - 1, true)) {
          // print('col >= 1');
          fencesNextPlayer.add(position - (GameConstants.totalInRow * 4) - 1);
        }
        if (position % (GameConstants.totalInRow * 2) <= 14 &&
            isAvailable(simulationFence, true,
                position - (GameConstants.totalInRow * 4) + 1) &&
            canReachOtherSide(
                position - (GameConstants.totalInRow * 4) + 1, true)) {
          // print('col <= 7');
          fencesNextPlayer.add(position - (GameConstants.totalInRow * 4) + 1);
        }
      }
    }
    if (position <
        (GameConstants.totalInRow * (GameConstants.totalInRow - 1))) {
      // print('row <= 7');
      if (position % (GameConstants.totalInRow * 2) >= 2) {
        // print('col >= 1');
        if (isAvailable(simulationFence, false,
                position + GameConstants.totalInRow - 2) &&
            canReachOtherSide(position + GameConstants.totalInRow - 2, false)) {
          fencesNextPlayer.add(position + GameConstants.totalInRow - 2);
        }
        if (isAvailable(simulationFence, true, position - 1) &&
            canReachOtherSide(position - 1, true)) {
          fencesNextPlayer.add(position - 1);
        }
        if (position % (GameConstants.totalInRow * 2) >= 4 &&
            isAvailable(simulationFence, false,
                position + GameConstants.totalInRow - 4) &&
            canReachOtherSide(position + GameConstants.totalInRow - 4, false)) {
          // print('col >= 2');
          fencesNextPlayer.add(position + GameConstants.totalInRow - 4);
        }
      }
      if (position % (GameConstants.totalInRow * 2) <= 14) {
        // print('col <= 7');
        if (isAvailable(
                simulationFence, false, position + GameConstants.totalInRow) &&
            canReachOtherSide(position + GameConstants.totalInRow, false)) {
          fencesNextPlayer.add(position + GameConstants.totalInRow);
        }
        if (isAvailable(simulationFence, true, position + 1) &&
            canReachOtherSide(position + 1, true)) {
          fencesNextPlayer.add(position + 1);
        }
        if (position % (GameConstants.totalInRow * 2) <= 12 &&
            isAvailable(simulationFence, false,
                position + GameConstants.totalInRow + 2) &&
            canReachOtherSide(position + GameConstants.totalInRow + 2, false)) {
          // print('col <= 6');
          fencesNextPlayer.add(position + GameConstants.totalInRow + 2);
        }
      }
      if (position <
          (GameConstants.totalInRow * (GameConstants.totalInRow - 3))) {
        // print('row <= 6');
        if (position % (GameConstants.totalInRow * 2) >= 2 &&
            isAvailable(simulationFence, true,
                position + (GameConstants.totalInRow * 2) - 1) &&
            canReachOtherSide(
                position + (GameConstants.totalInRow * 2) - 1, true)) {
          // print('col >= 1');
          fencesNextPlayer.add(position + (GameConstants.totalInRow * 2) - 1);
        }
        if (position % (GameConstants.totalInRow * 2) <= 14 &&
            isAvailable(simulationFence, true,
                position + (GameConstants.totalInRow * 2) + 1) &&
            canReachOtherSide(
                position + (GameConstants.totalInRow * 2) + 1, true)) {
          // print('col <= 7');
          fencesNextPlayer.add(position + (GameConstants.totalInRow * 2) + 1);
        }
      }
    }
    return fencesNextPlayer;
  }

  List<int> getSideHorizontalFences() {
    List<int> sideHorizontalFences = [];
    for (int i = 0; i < 8; i++) {
      if (isAvailable(simulationFence, false,
              (GameConstants.totalInRow * 2 * i) + GameConstants.totalInRow) &&
          canReachOtherSide(
              (GameConstants.totalInRow * 2 * i) + GameConstants.totalInRow,
              false)) {
        sideHorizontalFences
            .add((GameConstants.totalInRow * 2 * i) + GameConstants.totalInRow);
      }
      if (isAvailable(simulationFence, false,
              (GameConstants.totalInRow * 2 * (i + 1)) - 3) &&
          canReachOtherSide(
              (GameConstants.totalInRow * 2 * (i + 1)) - 3, false)) {
        sideHorizontalFences.add((GameConstants.totalInRow * 2 * (i + 1)) - 3);
      }
    }
    // print('side horizontal fences: $sideHorizontalFences}');
    return sideHorizontalFences;
  }

  // Get moves which leads you to shortest path.
  List<int> getMovesToShortestPath() {
    Player? tempPlayer1, tempPlayer2;
    List<int>? prev;
    List<List<int>> possiblePaths = [];
    List<int> bestMoves = [];

    tempPlayer1 = Player.copy(obj: simulationP1!);
    tempPlayer2 = Player.copy(obj: simulationP2!);

    if (simulationP1!.turn) {
      prev = tempPlayer1.bfs(simulationFence, tempPlayer2.position);
      tempPlayer1 = Player.copy(obj: simulationP1!);
      possiblePaths = tempPlayer1.findMinPaths(prev, tempPlayer2.position);
    } else {
      prev = tempPlayer2.bfs(simulationFence, tempPlayer1.position);
      tempPlayer2 = Player.copy(obj: simulationP2!);
      possiblePaths = tempPlayer2.findMinPaths(prev, tempPlayer1.position);
    }
    if (possiblePaths.isEmpty) {
      bestMoves = possibleMoves;
    } else {
      for (int i = 0; i < possiblePaths.length; i++) {
        bestMoves.add(possiblePaths[i][1]);
      }
    }

    return bestMoves;
  }

  // place walls only to interrupt the opponent's path.
  List<int> getFencesToInterruptPath() {
    Player? tempPlayer1, tempPlayer2;
    List<int> fencesToInterruptPath = [], emptyFences = [];
    List<List<int>> possiblePaths = [];
    List<int>? prev;
    late int minPath;

    tempPlayer1 = Player.copy(obj: simulationP1!);
    tempPlayer2 = Player.copy(obj: simulationP2!);

    if (simulationP1!.turn) {
      prev = tempPlayer2.bfs(simulationFence, tempPlayer1.position);
      tempPlayer2 = Player.copy(obj: simulationP2!);
      possiblePaths = tempPlayer2.findMinPaths(prev, tempPlayer1.position);
    } else {
      prev = tempPlayer1.bfs(simulationFence, tempPlayer2.position);
      tempPlayer1 = Player.copy(obj: simulationP1!);
      possiblePaths = tempPlayer1.findMinPaths(prev, tempPlayer2.position);
    }
    if (possiblePaths.isEmpty) {
      possiblePaths.add([
        simulationP1!.turn ? simulationP1!.position : simulationP2!.position,
        possibleMoves[0]
      ]);
    }

    minPath = possiblePaths[0].length;

    emptyFences = getEmptyValidFences(simulationFence);
    // print('EMPTY VALID FENCES: $emptyFences');

    for (int i = 0; i < emptyFences.length; i++) {
      // Add a temporary fence.
      placeFence(
        simulationFence,
        emptyFences[i],
        simulationFence[emptyFences[i]].type == FenceType.verticalFence
            ? true
            : false,
        true,
        true,
      );

      tempPlayer1 = Player.copy(obj: simulationP1!);
      tempPlayer2 = Player.copy(obj: simulationP2!);

      if (simulationP1!.turn) {
        prev = tempPlayer2.bfs(simulationFence, tempPlayer1.position);
        tempPlayer2 = Player.copy(obj: simulationP2!);
        possiblePaths = tempPlayer2.findMinPaths(prev, tempPlayer1.position);
      } else {
        prev = tempPlayer1.bfs(simulationFence, tempPlayer2.position);
        tempPlayer1 = Player.copy(obj: simulationP1!);
        possiblePaths = tempPlayer1.findMinPaths(prev, tempPlayer2.position);
      }
      if (possiblePaths.isEmpty) {
        possiblePaths.add([
          simulationP1!.turn ? simulationP1!.position : simulationP2!.position,
          possibleMoves[0]
        ]);
      }
      if (possiblePaths[0].length > minPath) {
        fencesToInterruptPath.add(emptyFences[i]);
      }
      // Remove temporary fence.
      placeFence(
        simulationFence,
        emptyFences[i],
        simulationFence[emptyFences[i]].type == FenceType.verticalFence
            ? true
            : false,
        false,
        true,
      );
    }
    // print('fences to interrupt path: $fencesToInterruptPath');
    return fencesToInterruptPath;
  }

  List<int> getEmptyValidFences(List<FenceModel> fence) {
    List<int> emptyValidFences = [];
    for (int i = 0; i < GameConstants.totalInBoard; i++) {
      if ((i ~/ GameConstants.totalInRow) % 2 == 0) {
        // check vertical fences
        if (i % 2 != 0 && isNotLastRow(i)) {
          if (fence[i].placed == false &&
              fence[i + GameConstants.totalInRow].placed == false &&
              fence[i + (GameConstants.totalInRow * 2)].placed == false) {
            if (canReachOtherSide(i, true)) {
              emptyValidFences.add(i);
            }
          }
        }
      } else {
        // check horizontal fences
        if (i % 2 != 0 && isNotLastColumn(i)) {
          if (fence[i].placed == false &&
              fence[i + 1].placed == false &&
              fence[i + 2].placed == false) {
            if (canReachOtherSide(i, false)) {
              emptyValidFences.add(i);
            }
          }
        }
      }
    }
    return emptyValidFences;
  }

  List<int> getProbableFences() {
    List<int> probableFences = [];
    if (simulationTurn >= 3) {
      // Disturb opponent
      probableFences += getFencesNextPlayer(
        simulationP1!.turn ? simulationP2!.position : simulationP1!.position,
      );
    }
    if (simulationTurn >= 6) {
      // Leftmost and rightmost horizontal fences
      probableFences += getSideHorizontalFences();
      // Support myself
      probableFences += getFencesNextPlayer(
        simulationP1!.turn ? simulationP1!.position : simulationP2!.position,
      );
    }
    return probableFences;
  }

  List<int> getProbableMoves() {
    List<int> probableMoves = [];
    if (opponentOutOfFences()) {
      // print('opponent out of fences');
      // Heuristic: If opponent has no walls left, my pawn moves only to one of the shortest paths.
      probableMoves += getMovesToShortestPath();
      // Heuristic: If opponent has no walls left, place walls only to interrupt the opponent's path, not to support my pawn.
      if (!outOfFences()) {
        // print('player has fences');
        // Disturb opponent
        // print('disturb opponent');
        probableMoves += getFencesNextPlayer(
          simulationP1!.turn ? simulationP2!.position : simulationP1!.position,
        );
        // print('Add fences to interrupt path');
        probableMoves += getFencesToInterruptPath();
      }
    } else {
      // print('opponent has fences');
      probableMoves += possibleMoves;
      // print('All possible moves added');
      if (!outOfFences()) {
        probableMoves += getProbableFences();
      }
    }
    // Remove duplicates before returning.
    return probableMoves.toSet().toList();
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

  bool opponentOutOfFences() {
    if (simulationOn) {
      if (simulationP1!.turn) {
        return simulationP2!.outOfFences();
      } else {
        return simulationP1!.outOfFences();
      }
    } else {
      if (player1.turn) {
        return player2.outOfFences();
      } else {
        return player1.outOfFences();
      }
    }
  }

  void popUpMessage(String message) {
    late Timer timer;
    int count = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      msg.value = message;
      count++;
      if (count == 3) {
        msg.value = "";
        timer.cancel();
      }
    });
  }

  bool _winnerFound() {
    if (reachedFirstRow(player1.position) || reachedLastRow(player2.position)) {
      Get.defaultDialog(
        title: "",
        content: singlePlayer
            ? reachedFirstRow(player1.position)
                ? const Text("You WON! BRAVO!")
                : const Text("You LOST! Let's play again!")
            : Row(
                children: [
                  const Text('                 PLAYER'),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: reachedFirstRow(player1.position)
                          ? player1.color
                          : player2.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Text('WON'),
                ],
              ),
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
      return true;
    }
    return false;
  }

  void aiMove() {
    late int randomPosition;

    // Heuristic: For first move of each pawn go forward if possible
    if (aiFirstMove &&
        possibleMoves
            .contains(player2.position + (2 * GameConstants.totalInRow))) {
      randomPosition = player2.position + (2 * GameConstants.totalInRow);
    } else {
      randomPosition = search().position;
    }

    aiFirstMove = false;

    if (squares.contains(randomPosition)) {
      changePosition(randomPosition);
    } else {
      placeFence(
        fence,
        randomPosition,
        fence[randomPosition].type == FenceType.verticalFence ? true : false,
        true,
        false,
      );
    }
    switchTurns();
    _winnerFound();
  }

  // Search for the best move in the current position
  TreeNode search() {
    TreeNode? node;
    late int score;

    calculatePossibleMoves();

    simulationOn = true;

    // create simulation game (simulation players and fence).
    simulationFence.clear();
    for (int j = 0; j < fence.length; j++) {
      simulationFence.add(FenceModel.copy(obj: fence[j]));
    }

    simulationP1 = Player.copy(obj: player1);
    simulationP1!.fences.value = player1.fences.value;
    simulationP2 = Player.copy(obj: player2);
    simulationP2!.fences.value = player2.fences.value;

    // create root node
    TreeNode root = TreeNode(
      position: player2.position,
      parent: null,
      isTerminal:
          reachedFirstRow(player1.position) || reachedLastRow(player2.position),
      probableMoves: getProbableMoves(),
    );

    // walk through 1000 iterations
    for (int iteration = 0; iteration < 1000; iteration++) {
      // print('NEW ITERATION');
      // print("root.position: ${root.position}");
      simulationTurn = turn;

      // create simulation game (simulation players and fence).
      simulationFence.clear();
      for (int j = 0; j < fence.length; j++) {
        simulationFence.add(FenceModel.copy(obj: fence[j]));
      }

      simulationP1 = Player.copy(obj: player1);
      simulationP1!.fences.value = player1.fences.value;
      simulationP2 = Player.copy(obj: player2);
      simulationP2!.fences.value = player2.fences.value;

      // print('simulation player1.position: ${simulationP1!.position}');
      // print('simulation player2.position: ${simulationP2!.position}');

      // select a node (selection phase)
      node = select(root);

      // score current node (simulation phase)
      score = rollout(node!.position);

      // backPropagate results
      backPropagate(node, score);
    }

    simulationOn = false;

    // pick up the best move in the current position
    return root.getBestMove(0);
    // return getBestMove(root, 0);
  }

  // Select most promising node
  TreeNode? select(TreeNode node) {
    // print('select');
    List<int>? prevEmptyValidFences;
    // make sure that we're dealing with non-terminal nodes
    while (!node.isTerminal) {
      // case where the node is fully expanded
      if (node.isFullyExpanded) {
        // print('${node.position} is fully expanded');
        node = node.getBestMove(2);
        // node = getBestMove(node, 2);
        // print("new node position: ${node.position}");

        // if (simulationP2!.turn) {
        //   print('Player 2, best move: ${node.position}');
        // } else {
        //   print('Player1, best move: ${node.position}');
        // }
        // print("node.position ${node.position}");
        if (squares.contains(node.position)) {
          changePosition(node.position);
          // node.emptyValidFences ??= prevEmptyValidFences;
          // print('change position');
          // print('simulationP1.pos: ${simulationP1!.position}');
          // print('simulationP2.pos: ${simulationP2!.position}');
        } else {
          placeFence(
            simulationFence,
            node.position,
            simulationFence[node.position].type == FenceType.verticalFence
                ? true
                : false,
            true,
            false,
          );
          if (simulationP1!.fences < 0 || simulationP2!.fences < 0) {
            print('****************');
            print('1');
            print('simulationP1!.fences: ${simulationP1!.fences}');
            print('simulationP2!.fences: ${simulationP2!.fences}');
            print('****************');
          }
        }
        switchTurns();

        node.probableMoves ??= getProbableMoves();
        // print("node.probableMoves: ${node.probableMoves}");
      }
      // Case where the node is NOT fully expanded
      else {
        return expand(node);
      }
    }
    return node;
  }

  TreeNode? expand(TreeNode node) {
    for (final move in node.probableMoves!) {
      // Make sure that current state (move) is not present in child nodes
      if (!node.children.containsKey(move)) {
        // Create a new node
        TreeNode newNode = TreeNode(
          position: move,
          parent: node,
          isTerminal: squares.contains(move)
              ? simulationP1!.turn
                  ? reachedFirstRow(move) ||
                      reachedLastRow(simulationP2!.position)
                  : reachedFirstRow(simulationP1!.position) ||
                      reachedLastRow(move)
              : false,
        );
        // print('node new in expand: ${newNode.position}');
        // print('newNode.pos: ${newNode.position}');
        // print('newNode.isTerminal: ${newNode.isTerminal}');
        // print('newNode.isFullyExpanded: ${newNode.isFullyExpanded}');
        // Add child node to parent's node children list (dict)
        node.children[move] = newNode;
        // Case when node is fully expanded
        if (node.probableMoves!.length == node.children.length) {
          node.isFullyExpanded = true;
        }
        // return newly created node
        return newNode;
      }
    }
    // should not get here.
    return null;
  }

  // Simulate the game via making random moves until reaching end of the game.
  int rollout(int position) {
    List<int> probableMoves = [];
    List<int> probableFences = [];
    int? probableFence;
    int rolloutCount = 0;

    if (!reachedFirstRow(simulationP1!.position) &&
        !reachedLastRow(simulationP2!.position)) {
      if (squares.contains(position)) {
        changePosition(position);
      } else {
        placeFence(
          simulationFence,
          position,
          simulationFence[position].type == FenceType.verticalFence
              ? true
              : false,
          true,
          false,
        );
        if (simulationP1!.fences < 0 || simulationP2!.fences < 0) {
          print('****************');
          print('2');
          if (simulationP1!.turn) {
            print('Simulation p1 turn');
          } else {
            print('Simulation p2 turn');
          }
          print('simulation player1.position: ${simulationP1!.position}');
          print('simulation player2.position: ${simulationP2!.position}');
          print('simulationP1!.fences: ${simulationP1!.fences}');
          print('simulationP2!.fences: ${simulationP2!.fences}');
          print('****************');
        }
      }
      // Switch turns and calculate possible moves.
      switchTurns();

      while (!reachedFirstRow(simulationP1!.position) &&
          !reachedLastRow(simulationP2!.position)) {
        rolloutCount++;

        if (rolloutCount > 200) {
          // print('simulation player1.position: ${simulationP1!.position}');
          // print('simulation player2.position: ${simulationP2!.position}');
          for (int j = 0; j < simulationFence.length; j++) {
            if (simulationFence[j].placed == true) {
              print("j: $j");
            }
          }
        }

        if (Random().nextDouble() < 0.7) {
          // Move pawn to one of the shortest paths.
          probableMoves = getMovesToShortestPath();
          changePosition(probableMoves[Random().nextInt(probableMoves.length)]);
        } else {
          probableFences = getProbableFences();
          if (!outOfFences() && probableFences.isNotEmpty) {
            // Place a probable fence.
            probableFence =
                probableFences[Random().nextInt(probableFences.length)];
            // place a fence
            placeFence(
              simulationFence,
              probableFence,
              simulationFence[probableFence].type == FenceType.verticalFence
                  ? true
                  : false,
              true,
              false,
            );
          } else {
            // Randomly pick one of the possible moves.
            changePosition(
                possibleMoves[Random().nextInt(possibleMoves.length)]);
          }
        }

        // Switch turns and calculate possible moves.
        switchTurns();
      }
    }
    // print("out of rollout");
    return reachedLastRow(simulationP2!.position) ? 1 : -1;
  }

  // backPropagate the number of visits and score up to the root node
  void backPropagate(TreeNode node, int score) {
    while (true) {
      // update node's visits
      node.visits += 1;

      // update node's score
      node.score += score;

      // print('node.position: ${node.position}');
      // print('node.visits: ${node.visits}');
      // print('node.score: ${node.score}');
      if (node.parent == null) {
        break;
      }
      // set node to parent
      node = node.parent!;
    }
  }
}
