  // AI:

  // void aiMove() {
  //   search();
  //   switchTurns();
  //   _winnerFound();
  // }
  //
  // void search() {
  //   Player? tempPlayer1, tempPlayer2;
  //   int? player1PathLen, player2PathLen;
  //
  //   aiMoves++;
  //
  //   // if AI is one step away from target, then move the pawn to the target to win the game.
  //   for (int i = 272; i <= 288; i += 2) {
  //     if (possibleMoves.contains(i)) {
  //       print('One step away from the target');
  //       changePosition(i);
  //       return;
  //     }
  //   }
  //
  //   // for first move go forward if possible
  //   if (aiMoves == 1 &&
  //       possibleMoves
  //           .contains(player2.position + (2 * GameConstants.totalInRow))) {
  //     print('First step - Go forward');
  //     changePosition(player2.position + (2 * GameConstants.totalInRow));
  //   } else if (aiMoves <= 4) {
  //     // move pawn to one of the shortest paths
  //     print('First 4 steps - move to shortest path');
  //     moveToShortestPath();
  //   } else {
  //     tempPlayer1 = Player.copy(obj: player1);
  //     tempPlayer2 = Player.copy(obj: player2);
  //
  //     player1PathLen = tempPlayer1
  //         .findMinPaths(tempPlayer1.bfs(fence, tempPlayer2.position),
  //             tempPlayer2.position)[0]
  //         .length;
  //     player2PathLen = tempPlayer2
  //         .findMinPaths(tempPlayer2.bfs(fence, tempPlayer1.position),
  //             tempPlayer1.position)[0]
  //         .length;
  //
  //     // if AI is closer to the target than the player.
  //     if (player2PathLen < player1PathLen) {
  //       if (Random().nextDouble() > 0.8 && !outOfFences()) {
  //         // place walls only to interrupt the opponent's path.
  //         print('AI is closer to target - Place a fence.');
  //         interruptPath(player1PathLen);
  //       } else {
  //         // move pawn to one of the shortest paths
  //         print('AI is closer to target - move to shortest path.');
  //         moveToShortestPath();
  //       }
  //     } else {
  //       if (Random().nextDouble() <= 0.6 && !outOfFences()) {
  //         // place walls only to interrupt the opponent's path.
  //         print('AI is farther to target - Place a fence.');
  //         interruptPath(player1PathLen);
  //       } else {
  //         // move pawn to one of the shortest paths
  //         print('AI is farther to target - move to shortest path.');
  //         moveToShortestPath();
  //       }
  //     }
  //   }
  // }
  //
  // // move pawn to one of the shortest paths
  // void moveToShortestPath() {
  //   List<List<int>> possiblePaths = [];
  //   late int randomPosition;
  //   Player tempPlayer2 = Player.copy(obj: player2);
  //
  //   possiblePaths = tempPlayer2.findMinPaths(
  //       tempPlayer2.bfs(fence, player1.position), player1.position);
  //
  //   if (possiblePaths.isEmpty) {
  //     randomPosition = possibleMoves[Random().nextInt(possibleMoves.length)];
  //   } else {
  //     randomPosition = possiblePaths[Random().nextInt(possiblePaths.length)][1];
  //   }
  //   changePosition(randomPosition);
  // }
  //
  // // place walls only to interrupt the opponent's path.
  // void interruptPath(int playerPathLen) {
  //   late Player tempPlayer1, tempPlayer2;
  //   List<List<int>> possiblePaths = [];
  //   List<int> maxIndexes = [];
  //   List<int> possibleIndexes = [];
  //   int? randomFence;
  //   int maxLen = playerPathLen;
  //   List<int> emptyFences = getEmptyValidFences(fence);
  //
  //   for (int i = 0; i < emptyFences.length; i++) {
  //     // place a temporary fence
  //     placeFence(
  //       fence,
  //       emptyFences[i],
  //       fence[calcFenceIndex(emptyFences[i])].type == FenceType.verticalFence
  //           ? true
  //           : false,
  //       true,
  //       true,
  //     );
  //
  //     tempPlayer1 = Player.copy(obj: player1);
  //     possiblePaths = tempPlayer1.findMinPaths(
  //         tempPlayer1.bfs(fence, player2.position), player2.position);
  //
  //     if (possiblePaths[0].length > maxLen) {
  //       maxIndexes.clear();
  //       maxLen = possiblePaths[0].length;
  //       maxIndexes.add(emptyFences[i]);
  //     } else if (possiblePaths[0].length == maxLen) {
  //       maxIndexes.add(emptyFences[i]);
  //     }
  //
  //     // remove the temporary fence
  //     placeFence(
  //       fence,
  //       emptyFences[i],
  //       fence[calcFenceIndex(emptyFences[i])].type == FenceType.verticalFence
  //           ? true
  //           : false,
  //       true,
  //       false,
  //     );
  //   }
  //
  //   if (maxLen != playerPathLen) {
  //     tempPlayer2 = Player.copy(obj: player2);
  //     playerPathLen = tempPlayer2
  //         .findMinPaths(
  //             tempPlayer2.bfs(fence, player1.position), player1.position)[0]
  //         .length;
  //
  //     for (int i = 0; i < maxIndexes.length; i++) {
  //       // place a temporary fence
  //       placeFence(
  //         fence,
  //         maxIndexes[i],
  //         fence[calcFenceIndex(maxIndexes[i])].type == FenceType.verticalFence
  //             ? true
  //             : false,
  //         true,
  //         true,
  //       );
  //
  //       tempPlayer2 = Player.copy(obj: player2);
  //       possiblePaths = tempPlayer2.findMinPaths(
  //           tempPlayer2.bfs(fence, player1.position), player1.position);
  //
  //       if (possiblePaths[0].length <= playerPathLen) {
  //         possibleIndexes.add(maxIndexes[i]);
  //       }
  //       // remove the temporary fence
  //       placeFence(
  //         fence,
  //         maxIndexes[i],
  //         fence[calcFenceIndex(maxIndexes[i])].type == FenceType.verticalFence
  //             ? true
  //             : false,
  //         true,
  //         false,
  //       );
  //     }
  //
  //     if (possibleIndexes.isNotEmpty) {
  //       randomFence = possibleIndexes[Random().nextInt(possibleIndexes.length)];
  //       print('Place a fence to interrupt opponent without effect AI');
  //     } else {
  //       randomFence = maxIndexes[Random().nextInt(maxIndexes.length)];
  //       print('Place a fence to interrupt opponent');
  //     }
  //     placeFence(
  //       fence,
  //       randomFence,
  //       fence[calcFenceIndex(randomFence)].type == FenceType.verticalFence
  //           ? true
  //           : false,
  //       false,
  //       true,
  //     );
  //   } else {
  //     // no fence can increase the opponent's path
  //     // move pawn to one of the shortest paths
  //     print('no fence can increase the opponent - move to shortest path');
  //     moveToShortestPath();
  //   }
  // }






  
  // AI - MCTS Algorithm

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
    for (int iteration = 0; iteration < 2500; iteration++) {
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
              possiblePaths = tempPlayer1.findMinPaths(
                  tempPlayer1.bfs(simulationFence, tempPlayer2.position),
                  tempPlayer2.position);
              // print(possiblePaths);
            } else {
              possiblePaths = tempPlayer2.findMinPaths(
                  tempPlayer2.bfs(simulationFence, tempPlayer1.position),
                  tempPlayer1.position);
              // print(possiblePaths);
            }
            if (possiblePaths.isEmpty) {
              randomPosition =
                  possibleMoves[Random().nextInt(possibleMoves.length)];
            } else {
              // print(possiblePaths[Random().nextInt(possiblePaths.length)]);
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

              tempPlayer1 = Player.copy(obj: simulationP1!);
              tempPlayer2 = Player.copy(obj: simulationP2!);

              if (simulationP1!.turn) {
                possiblePaths = tempPlayer2.findMinPaths(
                    tempPlayer2.bfs(simulationFence, tempPlayer1.position),
                    tempPlayer1.position);
                // print(possiblePaths);
              } else {
                possiblePaths = tempPlayer1.findMinPaths(
                    tempPlayer1.bfs(simulationFence, tempPlayer2.position),
                    tempPlayer2.position);
                // print(possiblePaths);
              }
              if (possiblePaths[0].length >= maxLen) {
                maxLen = possiblePaths[0].length;
                index = i;
              }

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
          }
        } else {
          if (Random().nextDouble() < 0.7) {
            // move pawn to one of the shortest paths
            tempPlayer1 = Player.copy(obj: simulationP1!);
            tempPlayer2 = Player.copy(obj: simulationP2!);
            // heuristic
            if (simulationP1!.turn) {
              possiblePaths = tempPlayer1.findMinPaths(
                  tempPlayer1.bfs(simulationFence, tempPlayer2.position),
                  tempPlayer2.position);
            } else {
              possiblePaths = tempPlayer2.findMinPaths(
                  tempPlayer2.bfs(simulationFence, tempPlayer1.position),
                  tempPlayer1.position);
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