import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:quoridor/models/tree_node.dart';
import '../helpers.dart';
import '../utils/game_constants.dart';
import 'fence_model.dart';
import 'game_model.dart';

class AI {
  final int numSimulations;
  late Game simulationGame;
  bool aiFirstMove = true;
  RxBool isLoading = false.obs;
  RxDouble winRate = 0.0.obs;

  AI({required this.numSimulations});

  void copyGame(Game game) {
    simulationGame = Game.copy(obj: game);
    simulationGame.player1.fences.value = game.player1.fences.value;
    simulationGame.player2.fences.value = game.player2.fences.value;
  }

  // https://medium.com/@_michelangelo_/monte-carlo-tree-search-mcts-algorithm-for-dummies-74b2bae53bfa
  Future<void> chooseNextMove(Game game) async {
    late int randomPosition;
    TreeNode? node;

    // Heuristic: For first move of each pawn go forward if possible
    if (aiFirstMove &&
        game.possibleMoves
            .contains(game.player2.position + (2 * GameConstants.totalInRow))) {
      randomPosition = game.player2.position + (2 * GameConstants.totalInRow);
    } else {
      isLoading.value = true;

      node = await _search(game);
      randomPosition = node.position;

      debugPrint('win rate:');
      print(node.getWinRate());
      winRate.value = node.getWinRate();
    }

    aiFirstMove = false;
    game.play(randomPosition);
  }

  // Search for the best move in the current position
  Future<TreeNode> _search(Game game) async {
    TreeNode? node;
    late int score;

    game.calculatePossibleMoves(); // NOT SURE IF NEEDED
    copyGame(game);

    // create root node
    TreeNode root = TreeNode(
      position: simulationGame.player2.position,
      parent: null,
      isTerminal: reachedFirstRow(simulationGame.player1.position) ||
          reachedLastRow(simulationGame.player2.position),
      probableMoves: simulationGame.getProbableMoves(),
    );

    // Walk through iterations
    await _runSimulations(
        length: numSimulations,
        execute: (index) {
          copyGame(game);

          // select a node (selection phase)
          node = select(root);

          // score current node (simulation phase)
          score = rollout(node!.position);

          // backPropagate results
          backPropagate(node!, score);
        });

    isLoading.value = false;
    root.maxSimulationsChild();
    // pick up the best move in the current position
    return root.getBestMove(0);
  }

  // I divided my work into many small chunks
  // and the next chunk will be added to the event queue when the current chunk finishes the execution.
  // So the other events can be executed between the chunks. (the UI won't be stuck)
  // https://hackernoon.com/executing-heavy-tasks-without-blocking-the-main-thread-on-flutter-6mx31lh
  Future<bool> _runSimulations({
    required int length,
    required Function(int index) execute,
    int chunkLength = 25,
  }) {
    final completer = Completer<bool>();
    exec(int i) {
      if (i >= length) return completer.complete(true);
      for (int j = i; j < min(length, i + chunkLength); j++) {
        execute(j);
      }
      Future.delayed(const Duration(milliseconds: 0), () {
        exec(i + chunkLength);
      });
    }

    exec(0);
    return completer.future;
  }

  // Select most promising node
  TreeNode? select(TreeNode node) {
    // make sure that we're dealing with non-terminal nodes
    while (!node.isTerminal) {
      // case where the node is fully expanded
      if (node.isFullyExpanded) {
        node = node.getBestMove(2);
        simulationGame.play(node.position);
        node.probableMoves ??= simulationGame.getProbableMoves();
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
          isTerminal: simulationGame.squares.contains(move)
              ? simulationGame.player1.turn
                  ? reachedFirstRow(move) ||
                      reachedLastRow(simulationGame.player2.position)
                  : reachedFirstRow(simulationGame.player1.position) ||
                      reachedLastRow(move)
              : false,
        );
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
    List<int> probableMoves = [], probableFences = [];
    int? probableFence;

    if (!reachedFirstRow(simulationGame.player1.position) &&
        !reachedLastRow(simulationGame.player2.position)) {
      simulationGame.play(position);
      // debugPrint('rollout');
      while (!reachedFirstRow(simulationGame.player1.position) &&
          !reachedLastRow(simulationGame.player2.position)) {
        if (Random().nextDouble() < 0.7) {
          // debugPrint('move to shortest path');
          // Move pawn to one of the shortest paths.
          probableMoves = simulationGame.getMovesToShortestPath();
          simulationGame.changePosition(
              probableMoves[Random().nextInt(probableMoves.length)]);
        } else {
          probableFences = simulationGame.getProbableFences();
          if (!simulationGame.outOfFences() && probableFences.isNotEmpty) {
            // debugPrint('place a fence');
            // Place a probable fence.
            probableFence =
                probableFences[Random().nextInt(probableFences.length)];
            // place a fence
            simulationGame.placeFence(
              probableFence,
              simulationGame.fences[probableFence].type ==
                      FenceType.verticalFence
                  ? true
                  : false,
              true,
              false,
            );
          } else {
            // Randomly pick one of the possible moves.
            // debugPrint('randomly move');
            simulationGame.changePosition(simulationGame.possibleMoves[
                Random().nextInt(simulationGame.possibleMoves.length)]);
          }
        }

        // Switch turns and calculate possible moves.
        simulationGame.switchTurns();
      }
    }

    return reachedLastRow(simulationGame.player2.position) ? 1 : 0;
  }

  // backPropagate the number of visits and score up to the root node
  void backPropagate(TreeNode node, int score) {
    while (true) {
      // update node's visits
      node.visits++;

      // update node's score
      node.score += score;

      if (node.parent == null) {
        break;
      }
      // set node to parent
      node = node.parent!;
    }
  }
}
