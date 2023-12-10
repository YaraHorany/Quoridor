import 'dart:async';
import 'dart:io';
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
  List<FenceModel> fence = [], simulationFence = [], simulationFence2 = [];
  List<int> squares = [], possibleMoves = [];
  DragType? dragType;
  Timer? timer;
  RxString msg = "".obs;
  late bool singlePlayer;
  bool simulationOn = false;

  bool aiFirstMove = true;
  int globalVal = 0;
  int aiMoves = 0;
  int totalNumOfSimulations = 0;

  @override
  void onInit() {
    super.onInit();
    player1 = Player(position: 280, color: Colors.green, turn: true);
    player2 = Player(position: 8, color: Colors.orange, turn: false);

    // temporary
    // player1 = Player(position: 42, color: Colors.green, turn: true);
    // player2 = Player(position: 8, color: Colors.orange, turn: false);
    // TEMPORARY - DELETE IT LATER
    // player1.fences.value = 0;
    // player2.fences.value = 0;

    _buildBoard();
  }

  void resetGame() {
    player1.position = 280;
    player1.fences.value = 10;
    player1.turn = true;

    player2.position = 8;
    player2.fences.value = 10;
    player2.turn = false;

    aiMoves = 0;

    _buildBoard();
  }

  void _buildBoard() {
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
    // // temporary
    // fence[14].placed = true;
    // fence[15].placed = true;
    // fence[16].placed = true;

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
      update();
    }
  }

  int calcFenceIndex(int i) =>
      fence.indexWhere((element) => element.position == i);

  void drawFence(int boardIndex) {
    if (!outOfFences()) {
      int index = calcFenceIndex(boardIndex);
      if (dragType == DragType.verticalDrag) {
        if (fence[index].type != FenceType.horizontalFence) {
          if (fence[index].type == FenceType.squareFence) {
            boardIndex -= GameConstants.totalInRow;
            index = calcFenceIndex(boardIndex);
          }
          if (isNotLastRow(boardIndex) && isAvailable(true, boardIndex)) {
            checkAndUpdateFence(boardIndex, fence, true);
          }
        }
      } else {
        if (fence[index].type != FenceType.verticalFence) {
          if (fence[index].type == FenceType.squareFence) {
            boardIndex -= 1;
            index = calcFenceIndex(boardIndex);
          }
          if (isNotLastColumn(boardIndex) && isAvailable(false, boardIndex)) {
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
      int index = calcFenceIndex(boardIndex);
      if (dragType == DragType.verticalDrag) {
        if (fence[index].type != FenceType.horizontalFence) {
          if (fence[index].type == FenceType.squareFence) {
            boardIndex -= GameConstants.totalInRow;
            index = calcFenceIndex(boardIndex);
          }
          if (isNotLastRow(boardIndex) && isAvailable(true, boardIndex)) {
            updateTemporaryFence(boardIndex, true, val);
          }
        }
      } else {
        if (fence[index].type != FenceType.verticalFence) {
          if (fence[index].type == FenceType.squareFence) {
            boardIndex -= 1;
            index = calcFenceIndex(boardIndex);
          }
          if (isNotLastColumn(boardIndex) && isAvailable(false, boardIndex)) {
            updateTemporaryFence(boardIndex, false, val);
          }
        }
      }
    }
  }

  // Check if it's possible to place a fence
  bool isAvailable(bool isVertical, int boardIndex) {
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

  void checkAndUpdateFence(
      int boardIndex, List<FenceModel> fence, bool isVertical) {
    if (canReachOtherSide(boardIndex, isVertical)) {
      placeFence(fence, boardIndex, isVertical, false, true);
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
      bool isTemp, bool val) {
    isVertical
        ? _placeVerticalFence(fence, boardIndex, val)
        : _placeHorizontalFence(fence, boardIndex, val);
    update();
    if (!isTemp && val) {
      _decreaseFencesNum();
    }
  }

  // Place a vertical fence.
  void _placeVerticalFence(List<FenceModel> fence, int boardIndex, bool val) {
    for (int i = 0; i < GameConstants.fenceLength; i++) {
      fence[calcFenceIndex(boardIndex + GameConstants.totalInRow * i)].placed =
          val;
    }
  }

  // Place a horizontal fence.
  void _placeHorizontalFence(List<FenceModel> fence, int boardIndex, bool val) {
    for (int i = 0; i < GameConstants.fenceLength; i++) {
      fence[calcFenceIndex(boardIndex + i)].placed = val;
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

  bool testIfAdjacentToOtherWallForVerticalWallTop(int boardIndex) {
    if (inBoardRange(boardIndex - (GameConstants.totalInRow * 2))) {
      if (fence[
                  calcFenceIndex(boardIndex - GameConstants.totalInRow - 1)]
              .placed ||
          fence[calcFenceIndex(boardIndex - GameConstants.totalInRow + 1)]
              .placed ||
          fence[calcFenceIndex(boardIndex - (GameConstants.totalInRow * 2))]
              .placed) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  bool testIfAdjacentToOtherWallForVerticalWallBottom(int boardIndex) {
    if (inBoardRange(boardIndex + (GameConstants.totalInRow * 4))) {
      if (fence[calcFenceIndex(
                  boardIndex + (GameConstants.totalInRow * 3) - 1)]
              .placed ||
          fence[calcFenceIndex(boardIndex + (GameConstants.totalInRow * 3) + 1)]
              .placed ||
          fence[calcFenceIndex(boardIndex + (GameConstants.totalInRow * 4))]
              .placed) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  bool testIfAdjacentToOtherWallForVerticalWallMiddle(int boardIndex) {
    if (fence[calcFenceIndex(boardIndex + GameConstants.totalInRow - 1)]
            .placed ||
        fence[calcFenceIndex(boardIndex + GameConstants.totalInRow + 1)]
            .placed) {
      return true;
    }
    return false;
  }

  bool testIfConnectedOnTwoPointsForVerticalWall(int boardIndex) {
    bool top = testIfAdjacentToOtherWallForVerticalWallTop(boardIndex);
    bool bottom = testIfAdjacentToOtherWallForVerticalWallBottom(boardIndex);
    bool middle = testIfAdjacentToOtherWallForVerticalWallMiddle(boardIndex);
    return (top && bottom) || (top && middle) || (bottom && middle);
  }

  bool testIfAdjacentToOtherWallForHorizontalWallLeft(int boardIndex) {
    if (boardIndex % GameConstants.totalInRow != 0) {
      if (fence[
                  calcFenceIndex(boardIndex - 1 - GameConstants.totalInRow)]
              .placed ||
          fence[calcFenceIndex(boardIndex - 1 + GameConstants.totalInRow)]
              .placed ||
          fence[calcFenceIndex(boardIndex - 4)].placed) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  bool testIfAdjacentToOtherWallForHorizontalWallRight(int boardIndex) {
    if (boardIndex % GameConstants.totalInRow != 14) {
      if (fence[
                  calcFenceIndex(boardIndex + 3 - GameConstants.totalInRow)]
              .placed ||
          fence[calcFenceIndex(boardIndex + 3 + GameConstants.totalInRow)]
              .placed ||
          fence[calcFenceIndex(boardIndex + 4)].placed) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  bool testIfAdjacentToOtherWallForHorizontalWallMiddle(int boardIndex) {
    if (fence[calcFenceIndex(boardIndex + 1 - GameConstants.totalInRow)]
            .placed ||
        fence[calcFenceIndex(boardIndex + 1 + GameConstants.totalInRow)]
            .placed) {
      return true;
    }
    return false;
  }

  bool testIfConnectedOnTwoPointsForHorizontalWall(int boardIndex) {
    bool left = testIfAdjacentToOtherWallForHorizontalWallLeft(boardIndex);
    bool right = testIfAdjacentToOtherWallForHorizontalWallRight(boardIndex);
    bool middle = testIfAdjacentToOtherWallForHorizontalWallMiddle(boardIndex);
    return (left && right) || (left && middle) || (right && middle);
  }

  // Checking that both players are NOT completely blocked from reaching the opposing baseline
  bool canReachOtherSide(int boardIndex, bool isVertical) {
    late Player tempPlayer1, tempPlayer2;
    late bool result;

    // if (isVertical) {
    //   if (!testIfConnectedOnTwoPointsForVerticalWall(boardIndex)) {
    //     // print('TRUE IS VERTICAL');
    //     return true;
    //   }
    // } else {
    //   if (!testIfConnectedOnTwoPointsForHorizontalWall(boardIndex)) {
    //     // print('TRUE IS HORIZONTAL');
    //     return true;
    //   }
    // }

    // print("KEEY CHECKING");

    if (simulationOn) {
      tempPlayer1 = Player.copy(obj: simulationP1!);
      tempPlayer2 = Player.copy(obj: simulationP2!);

      // place a temporary fence.
      placeFence(simulationFence, boardIndex, isVertical, true, true);
      result = tempPlayer1.bfsSearch(simulationFence) &&
          tempPlayer2.bfsSearch(simulationFence);
      // remove temporary fence.
      placeFence(simulationFence, boardIndex, isVertical, true, false);
    } else {
      tempPlayer1 = Player.copy(obj: player1);
      tempPlayer2 = Player.copy(obj: player2);

      // place a temporary fence.
      placeFence(fence, boardIndex, isVertical, true, true);
      result = tempPlayer1.bfsSearch(fence) && tempPlayer2.bfsSearch(fence);
      // remove temporary fence.
      placeFence(fence, boardIndex, isVertical, true, false);
    }

    return result;
  }

  void _decreaseFencesNum() {
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

  List<int> getEmptyValidFences(List<FenceModel> fence) {
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
            if (canReachOtherSide(i, true)) {
              emptyFences.add(i);
            }
          }
        }
      } else {
        // check horizontal fences
        if (i % 2 != 0 && isNotLastColumn(i)) {
          if (fence[calcFenceIndex(i)].placed == false &&
              fence[calcFenceIndex(i + 1)].placed == false &&
              fence[calcFenceIndex(i + 2)].placed == false) {
            if (canReachOtherSide(i, false)) {
              emptyFences.add(i);
            }
          }
        }
      }
    }
    return emptyFences;
  }

  // move pawn to one of the shortest paths
  void moveToShortestPath() {
    List<List<int>> possiblePaths = [];
    late int randomPosition;
    Player tempPlayer2 = Player.copy(obj: player2);

    possiblePaths = tempPlayer2.findMinPaths(
        tempPlayer2.bfs(fence, player1.position), player1.position);

    if (possiblePaths.isEmpty) {
      randomPosition = possibleMoves[Random().nextInt(possibleMoves.length)];
    } else {
      randomPosition = possiblePaths[Random().nextInt(possiblePaths.length)][1];
    }
    changePosition(randomPosition);
  }

  void aiMove() {
    int? randomPosition;
    aiMoves++;
    randomPosition = search().position;

    if (squares.contains(randomPosition)) {
      changePosition(randomPosition);
    } else {
      placeFence(
        fence,
        randomPosition,
        fence[calcFenceIndex(randomPosition)].type == FenceType.verticalFence
            ? true
            : false,
        false,
        true,
      );
    }
    switchTurns();
    _winnerFound();
  }

  // Search for the best move in the current position
  TreeNode search() {
    globalVal = 0;
    TreeNode? node;
    late int score;

    // Heuristic: For first move of each pawn go forward if possible
    if (aiMoves == 1 &&
        possibleMoves
            .contains(player2.position + (2 * GameConstants.totalInRow))) {
      return TreeNode(
        position: player2.position + (2 * GameConstants.totalInRow),
        parent: null,
        isTerminal: false,
      );
    }

    // create root node
    TreeNode root = TreeNode(
      position: player2.position,
      parent: null,
      isTerminal:
          reachedFirstRow(player1.position) || reachedLastRow(player2.position),
      emptyValidFences: outOfFences() ? [] : getEmptyValidFences(fence),
    );

    // print('Root position: ${root.position}');
    simulationOn = true;
    // walk through 1000 iterations
    for (int iteration = 0; iteration < 1000; iteration++) {
      // print('Iteration number $iteration');

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
      backPropagate(node!, score);
    }

    simulationOn = false;

    // pick up the best move in the current position
    return getBestMove(root, 0);
  }

  // Select most promising node
  TreeNode? select(TreeNode node) {
    List<int>? prevEmptyValidFences;
    // make sure that we're dealing with non-terminal nodes
    while (!node.isTerminal) {
      // case where the node is fully expanded
      if (node.isFullyExpanded) {
        // print('${node.position} is fully expanded');
        prevEmptyValidFences = node.emptyValidFences;
        node = getBestMove(node, 2);
        // print('best move: ${node.position}');

        if (squares.contains(node.position)) {
          changePosition(node.position);
          node.emptyValidFences ??= prevEmptyValidFences;
          // print('change position');
          // print('simulationP1.pos: ${simulationP1!.position}');
          // print('simulationP2.pos: ${simulationP2!.position}');
        } else {
          // print('place a fence');
          placeFence(
            simulationFence,
            node.position,
            simulationFence[calcFenceIndex(node.position)].type ==
                    FenceType.verticalFence
                ? true
                : false,
            false,
            true,
          );
          node.emptyValidFences ??= getEmptyValidFences(simulationFence);
        }

        switchTurns();
      }
      // case where the node is NOT fully expanded
      else {
        return expand(node);
      }
    }
    // print('Node is terminal');
    return node;
  }

  TreeNode? expand(TreeNode node) {
    // print('EXPANDING');
    calculatePossibleMoves();
    for (final move in (possibleMoves + node.emptyValidFences!)) {
      // Make sure that current state (move) is not present in child nodes
      if (!node.children.containsKey(move)) {
        // Create a new node
        TreeNode newNode = TreeNode(
          position: move,
          parent: node,
          isTerminal:
              reachedFirstRow(simulationP1!.position) || reachedLastRow(move),
        );
        // print('newNode.pos: ${newNode.position}');
        // print('newNode.isTerminal: ${newNode.isTerminal}');
        // print('newNode.isFullyExpanded: ${newNode.isFullyExpanded}');
        // Add child node to parent's node children list (dict)
        node.children[move] = newNode;
        // Case when node is fully expanded
        if ((possibleMoves + node.emptyValidFences!).length ==
            node.children.length) {
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
    Player? tempPlayer1, tempPlayer2;
    List<List<int>> possiblePaths = [];
    late int randomPosition;
    List<int> emptyFences = [];
    int maxLen = 0, index = 0;
    List<int>? prev;

    if (!reachedFirstRow(simulationP1!.position) &&
        !reachedLastRow(simulationP2!.position)) {
      if (squares.contains(position)) {
        changePosition(position);
        // print('simulation player1.position: ${simulationP1!.position}');
        // print('simulation player2.position: ${simulationP2!.position}');
      } else {
        placeFence(
          simulationFence,
          position,
          simulationFence[calcFenceIndex(position)].type ==
                  FenceType.verticalFence
              ? true
              : false,
          false,
          true,
        );
      }
      // Switch turns and calculate possible moves.
      switchTurns();

      while (!reachedFirstRow(simulationP1!.position) &&
          !reachedLastRow(simulationP2!.position)) {
        // If opponent has no walls left
        if (opponentOutOfFences()) {
          if (outOfFences() || Random().nextInt(2) == 0) {
            // move pawn to one of the shortest paths
            tempPlayer1 = Player.copy(obj: simulationP1!);
            tempPlayer2 = Player.copy(obj: simulationP2!);
            // heuristic
            if (simulationP1!.turn) {
              prev = tempPlayer1.bfs(simulationFence, tempPlayer2.position);
              tempPlayer1 = Player.copy(obj: simulationP1!);
              possiblePaths =
                  tempPlayer1.findMinPaths(prev, tempPlayer2.position);
              // print(possiblePaths);
            } else {
              prev = tempPlayer2.bfs(simulationFence, tempPlayer1.position);
              tempPlayer2 = Player.copy(obj: simulationP2!);
              possiblePaths =
                  tempPlayer2.findMinPaths(prev, tempPlayer1.position);
              // print(possiblePaths);
            }
            if (possiblePaths.isEmpty) {
              // print('RANDOM POSSIBLE MOVES 1');
              randomPosition =
                  possibleMoves[Random().nextInt(possibleMoves.length)];
            } else {
              // print(possiblePaths[Random().nextInt(possiblePaths.length)]);
              // print('RANDOM POSSIBLE PATHS');
              randomPosition =
                  possiblePaths[Random().nextInt(possiblePaths.length)][1];
            }

            changePosition(randomPosition);
          } else {
            // place walls only to interrupt the opponent's path not to support my pawn.
            emptyFences = getEmptyValidFences(simulationFence);
            print('******** EMPTY FENCES **********');
            print(emptyFences);

            for (int i = 0; i < emptyFences.length; i++) {
              // place a fence
              placeFence(
                simulationFence,
                emptyFences[i],
                simulationFence[calcFenceIndex(emptyFences[i])].type ==
                        FenceType.verticalFence
                    ? true
                    : false,
                false,
                true,
              );
              print("1");

              tempPlayer1 = Player.copy(obj: simulationP1!);
              tempPlayer2 = Player.copy(obj: simulationP2!);

              if (simulationP1!.turn) {
                print("2");
                print("simulation2.position: ${simulationP1!.position}");
                prev = tempPlayer2.bfs(simulationFence, tempPlayer1.position);
                tempPlayer2 = Player.copy(obj: simulationP2!);
                possiblePaths =
                    tempPlayer2.findMinPaths(prev, tempPlayer1.position);
                print("findMinPaths done");
                print(possiblePaths);
                print("2 done");
              } else {
                print("3");
                // print("simulation1.position: ${simulationP1!.position}");
                prev = tempPlayer1.bfs(simulationFence, tempPlayer2.position);
                tempPlayer1 = Player.copy(obj: simulationP1!);
                print("player1 pos: ${tempPlayer1.position}");
                print("player2 pos: ${tempPlayer2.position}");
                print("Placed fences:");
                for (int j = 0; j < simulationFence.length; j++) {
                  if (simulationFence[j].placed == true) {
                    // stdout.write("${simulationFence[j].position} / ");
                    print("${simulationFence[j].position} ");
                  }
                }
                possiblePaths =
                    tempPlayer1.findMinPaths(prev, tempPlayer2.position);
                // print("findMinPaths done");
                print("possiblePaths: $possiblePaths");
                // print('3 done');
              }
              if (possiblePaths[0].length >= maxLen) {
                // print("4");
                maxLen = possiblePaths[0].length;
                index = i;
              }
              // print("5");
              // remove the fence
              placeFence(
                simulationFence,
                emptyFences[i],
                simulationFence[calcFenceIndex(emptyFences[i])].type ==
                        FenceType.verticalFence
                    ? true
                    : false,
                false,
                false,
              );
            }
            print("6");
            print('index $index');
            print('maxLen $maxLen');
            print('empty fences length: ${emptyFences.length}');
            print('emptyFences[index]: ${emptyFences[index]}');
            // randomPosition = emptyFences[Random().nextInt(emptyFences.length)];
            placeFence(
              simulationFence,
              emptyFences[index],
              simulationFence[calcFenceIndex(emptyFences[index])].type ==
                      FenceType.verticalFence
                  ? true
                  : false,
              false,
              true,
            );
            print("7");
          }
        } else {
          if (Random().nextDouble() < 0.7) {
            // move pawn to one of the shortest paths
            tempPlayer1 = Player.copy(obj: simulationP1!);
            tempPlayer2 = Player.copy(obj: simulationP2!);
            // heuristic
            if (simulationP1!.turn) {
              prev = tempPlayer1.bfs(simulationFence, tempPlayer2.position);
              tempPlayer1 = Player.copy(obj: simulationP1!);
              possiblePaths =
                  tempPlayer1.findMinPaths(prev, tempPlayer2.position);
            } else {
              prev = tempPlayer2.bfs(simulationFence, tempPlayer1.position);
              tempPlayer2 = Player.copy(obj: simulationP2!);
              possiblePaths =
                  tempPlayer2.findMinPaths(prev, tempPlayer1.position);
            }
            // print(possiblePaths);
            if (possiblePaths.isEmpty) {
              randomPosition =
                  possibleMoves[Random().nextInt(possibleMoves.length)];
            } else {
              // print('i was here2');
              // print(possiblePaths[Random().nextInt(possiblePaths.length)]);
              randomPosition =
                  possiblePaths[Random().nextInt(possiblePaths.length)][1];
            }

            changePosition(randomPosition);
          } else {
            if (outOfFences() || Random().nextInt(2) == 0) {
              // Randomly place a fence
              emptyFences = getEmptyValidFences(simulationFence);
              // print("RANDOM EMPTY FENCES");
              randomPosition =
                  emptyFences[Random().nextInt(emptyFences.length)];
              placeFence(
                simulationFence,
                randomPosition,
                simulationFence[calcFenceIndex(randomPosition)].type ==
                        FenceType.verticalFence
                    ? true
                    : false,
                false,
                true,
              );
            } else {
              // Randomly pick one of the possible moves.
              // print("RANDOM POSSIBLE MOVES 2");
              randomPosition =
                  possibleMoves[Random().nextInt(possibleMoves.length)];
              changePosition(randomPosition);
            }
          }
        }

        // Switch turns and calculate possible moves.
        switchTurns();
      }

      // print('out of rollout');
    }

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

  // Select the best node basing on UCB1 formula
  TreeNode getBestMove(TreeNode node, int explorationConstant) {
    // Define best score & best moves
    double bestScore = -1.0 / 0.0; // minus infinity
    List<TreeNode> bestMoves = [];
    double? moveScore;

    // Loop over child nodes
    for (final childNode in node.children.values) {
      // get move score using UCT formula
      moveScore = childNode.score / childNode.visits +
          explorationConstant * sqrt(log(node.visits / childNode.visits));

      // if (explorationConstant == 0) {
      //   print('childeNode.position: ${childNode.position}');
      //   print('movescore: $moveScore');
      // }
      //
      // print('childNode.position ${childNode.position} moveScore: $moveScore');

      // better move has been found
      if (moveScore > bestScore) {
        bestScore = moveScore;
        bestMoves = [childNode];
      }

      // found as good move as already available
      else if (moveScore == bestScore) {
        bestMoves.add(childNode);
      }
    }
    // print("bestMoves");
    // for (int x = 0; x < bestMoves.length; x++) {
    //   print(bestMoves[x].position);
    // }
    // return one of the best moves randomly
    return bestMoves[Random().nextInt(bestMoves.length)];
  }
}
