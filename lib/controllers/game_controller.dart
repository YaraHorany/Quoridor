import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers.dart';
import '../models/fence_model.dart';
import '../models/game_model.dart';
import '../models/tree_node.dart';
import '../models/player_model.dart';
import 'package:quoridor/utils/game_constants.dart';

enum DragType {
  horizontalDrag,
  verticalDrag,
}

class GameController extends GetxController {
  late Game game;
  Game? simulationGame;
  DragType? dragType;
  RxString msg = "".obs;
  late bool singlePlayerGame;
  int? numSimulations;
  bool aiFirstMove = true;
  RxBool isLoading = false.obs;
  bool running = false;

  @override
  void onInit() {
    super.onInit();

    game = Game(
      player1: Player(position: 280, color: Colors.green, turn: true),
      player2: Player(position: 8, color: Colors.orange, turn: false),
      fences: [],
      turn: 0,
      emptyFences: [],
      squares: [],
      possibleMoves: [],
    );

    game.buildBoard();
    update();
  }

  void reset() {
    aiFirstMove = true;
    game.reset();
    update();
  }

  void playAgainstAI(bool mood, {int? simulationNum}) {
    singlePlayerGame = mood;
    if (singlePlayerGame) {
      numSimulations = simulationNum;
    }
  }

  void move(int index) {
    if (game.move(index)) {
      if (_winnerFound()) return;
      if (singlePlayerGame && game.player2.turn) {
        _aiMove();
      }
      update();
    }
  }

  void drawFence(int boardIndex) {
    String? msg;
    if (!game.outOfFences()) {
      if (dragType == DragType.verticalDrag) {
        msg = game.checkAndUpdateFence(
            boardIndex, FenceType.horizontalFence, GameConstants.totalInRow);
      } else {
        msg = game.checkAndUpdateFence(boardIndex, FenceType.verticalFence, 1);
      }
      if (msg != null) {
        if (msg == '') {
          update();
          if (singlePlayerGame && game.player2.turn) {
            _aiMove();
          }
        } else {
          _popUpMessage(msg);
        }
      }
    } else {
      _popUpMessage('   There are no more\n walls for you to place');
    }
  }

  void drawTemporaryFence(int boardIndex, bool val) {
    if (!game.outOfFences()) {
      if (dragType == DragType.verticalDrag) {
        game.updateTemporaryFence(boardIndex, val, FenceType.horizontalFence,
            GameConstants.totalInRow);
      } else {
        game.updateTemporaryFence(boardIndex, val, FenceType.verticalFence, 1);
      }
      update();
    }
  }

  void _popUpMessage(String message) {
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
    if (reachedFirstRow(game.player1.position) ||
        reachedLastRow(game.player2.position)) {
      Get.defaultDialog(
        title: "",
        content: singlePlayerGame
            ? reachedFirstRow(game.player1.position)
                ? const Text("You WON! BRAVO!")
                : const Text("You LOST! Let's play again!")
            : Row(
                children: [
                  const Text('                 PLAYER'),
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: reachedFirstRow(game.player1.position)
                          ? game.player1.color
                          : game.player2.color,
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
              reset();
            },
          ),
        ],
      ).then((value) => reset());
      return true;
    }
    return false;
  }

  Future<void> _aiMove() async {
    late int randomPosition;
    late TreeNode node;

    // Heuristic: For first move of each pawn go forward if possible
    if (aiFirstMove &&
        game.possibleMoves
            .contains(game.player2.position + (2 * GameConstants.totalInRow))) {
      randomPosition = game.player2.position + (2 * GameConstants.totalInRow);
    } else {
      node = _search();
      randomPosition = node.position;
    }
    aiFirstMove = false;

    game.play(randomPosition);
    _winnerFound();
  }

  // Search for the best move in the current position
  TreeNode _search() {
    TreeNode? node;
    late int score;

    game.calculatePossibleMoves(); // NOT SURE IF NEEDED
    simulationGame = Game.copy(obj: game);
    simulationGame!.player1.fences.value = game.player1.fences.value;
    simulationGame!.player2.fences.value = game.player2.fences.value;

    // create root node
    TreeNode root = TreeNode(
      position: simulationGame!.player2.position,
      parent: null,
      isTerminal: reachedFirstRow(simulationGame!.player1.position) ||
          reachedLastRow(simulationGame!.player2.position),
      probableMoves: simulationGame!.getProbableMoves(),
    );

    // walk through iterations
    for (int iteration = 0; iteration < numSimulations!; iteration++) {
      print("iteration: $iteration");
      simulationGame = Game.copy(obj: game);
      simulationGame!.player1.fences.value = game.player1.fences.value;
      simulationGame!.player2.fences.value = game.player2.fences.value;
      print('simulationGame.emptyFences: ${simulationGame!.emptyFences}');
      for (int i = 0; i < GameConstants.totalInBoard; i++) {
        if (simulationGame!.fences[i].placed == true) {
          print('$i is placed');
        }
      }

      // select a node (selection phase)
      node = simulationGame!.select(root);

      // score current node (simulation phase)
      score = simulationGame!.rollout(node!.position);

      // backPropagate results
      simulationGame!.backPropagate(node, score);
    }
    // pick up the best move in the current position
    return root.getBestMove(0);
  }
}
