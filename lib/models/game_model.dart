import 'package:quoridor/models/player_model.dart';
import 'package:quoridor/models/fence_model.dart';
import '../helpers.dart';
import '../utils/game_constants.dart';

class Game {
  Player player1, player2;
  List<FenceModel> fences;
  int turn;
  List<int> possibleMoves, emptyFences, squares;

  Game({
    required this.player1,
    required this.player2,
    required this.fences,
    required this.turn,
    required this.emptyFences,
    required this.squares,
    required this.possibleMoves,
  });

  factory Game.copy({required Game obj}) {
    // List<FenceModel> fences = [];
    // for (var fence in obj.fences) {
    //   fences.add(FenceModel.copy(obj: fence));
    // }
    return Game(
      player1: Player.copy(obj: obj.player1),
      player2: Player.copy(obj: obj.player2),
      fences: obj.fences.map((fence) => FenceModel.copy(obj: fence)).toList(),
      turn: obj.turn,
      emptyFences: obj.emptyFences.map((e) => e).toList(),
      squares: obj.squares.map((e) => e).toList(),
      possibleMoves: obj.possibleMoves.map((e) => e).toList(),
    );
  }

  void reset() {
    player1.position = 280;
    player1.fences.value = 10;
    player1.turn = true;

    player2.position = 8;
    player2.fences.value = 10;
    player2.turn = false;

    turn = 0;
    buildBoard();
  }

  void buildBoard() {
    squares.clear();
    fences.clear();
    emptyFences.clear();

    for (int i = 0; i < GameConstants.totalInBoard; i++) {
      if ((i ~/ GameConstants.totalInRow) % 2 == 0) {
        if (i % 2 == 0) {
          squares.add(i);
          fences.add(FenceModel()); // Add a null object
        } else {
          fences.add(FenceModel(
              placed: false,
              type: FenceType.verticalFence,
              temporaryFence: false));
          if (isNotLastRow(i)) {
            emptyFences.add(i);
          }
        }
      } else {
        if (i % 2 == 0) {
          fences.add(FenceModel(
            placed: false,
            type: FenceType.squareFence,
            temporaryFence: false,
          ));
        } else {
          fences.add(FenceModel(
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
    possibleMoves = player1.showPossibleMoves(fences, player2.position);
  }

  bool move(int index) {
    if (possibleMoves.contains(index)) {
      changePosition(index);
      switchTurns();
      return true;
    }
    return false;
  }

  // Move or place a fence.
  void play(int position) {
    if (squares.contains(position)) {
      changePosition(position);
    } else {
      placeFence(
        position,
        fences[position].type == FenceType.verticalFence ? true : false,
        true,
        false,
      );
    }
    // Switch turns and calculate possible moves.
    switchTurns();
  }

  // Change current player's position and increase turn counter.
  void changePosition(int index) {
    turn++;
    if (player1.turn) {
      player1.position = index;
    } else {
      player2.position = index;
    }
  }

  // Switch turns and calculate possible moves for next player.
  void switchTurns() {
    player1.changeTurn();
    player2.changeTurn();
    calculatePossibleMoves();
  }

  // Calculate possibleMoves variable based on player turn.
  void calculatePossibleMoves() {
    possibleMoves = player1.turn
        ? player1.showPossibleMoves(fences, player2.position)
        : player2.showPossibleMoves(fences, player1.position);
  }

  String? checkAndUpdateFence(int boardIndex, FenceType type, int num) {
    if (fences[boardIndex].type != type) {
      if (fences[boardIndex].type == FenceType.squareFence) {
        boardIndex -= num;
      }
      if (emptyFences.contains(boardIndex)) {
        if (canReachOtherSide(
            boardIndex,
            fences[boardIndex].type == FenceType.verticalFence
                ? true
                : false)) {
          placeFence(
              boardIndex,
              fences[boardIndex].type == FenceType.verticalFence ? true : false,
              true,
              false);
          switchTurns();
          return '';
        } else {
          updateTemporaryFence(boardIndex, false, FenceType.squareFence, 0);
          return 'Placing a fence here will make\n    an unwinnable position';
        }
      }
    }
    return null;
  }

  void updateTemporaryFence(int boardIndex, bool val, FenceType type, int num) {
    if (fences[boardIndex].type != type) {
      if (fences[boardIndex].type == FenceType.squareFence) {
        boardIndex -= num;
      }
      if (emptyFences.contains(boardIndex)) {
        fences[boardIndex].temporaryFence = val;
        if (fences[boardIndex].type == FenceType.verticalFence) {
          fences[boardIndex + GameConstants.totalInRow].temporaryFence = val;
          fences[boardIndex + (GameConstants.totalInRow * 2)].temporaryFence =
              val;
        } else {
          fences[boardIndex + 1].temporaryFence = val;
          fences[boardIndex + 2].temporaryFence = val;
        }
      }
    }
  }

  // Place a fence vertically or horizontally and update fences number.
  void placeFence(int boardIndex, bool isVertical, bool val, bool isTemp) {
    isVertical
        ? _placeVerticalFence(boardIndex, val)
        : _placeHorizontalFence(boardIndex, val);
    if (!isTemp) {
      turn++;
      updateEmptyFences(boardIndex);
    }

    _changeFencesNum(val);
  }

  // Place a vertical fence.
  void _placeVerticalFence(int boardIndex, bool val) {
    for (int i = 0; i < GameConstants.fenceLength; i++) {
      fences[boardIndex + (GameConstants.totalInRow * i)].placed = val;
    }
  }

  // Place a horizontal fence.
  void _placeHorizontalFence(int boardIndex, bool val) {
    for (int i = 0; i < GameConstants.fenceLength; i++) {
      fences[boardIndex + i].placed = val;
    }
  }

  // Update emptyFences list.
  void updateEmptyFences(int boardIndex) {
    emptyFences.remove(boardIndex);
    if (fences[boardIndex].type == FenceType.horizontalFence) {
      emptyFences.remove(boardIndex + 1 - GameConstants.totalInRow);
      if (boardIndex - 2 >= 0 && boardIndex - 2 < GameConstants.totalInBoard) {
        emptyFences.remove(boardIndex - 2);
      }
      if (boardIndex + 4 >= 0 && boardIndex + 4 < GameConstants.totalInBoard) {
        emptyFences.remove(boardIndex + 2);
      }
    } else {
      emptyFences.remove(boardIndex + GameConstants.totalInRow - 1);
      if (boardIndex - (GameConstants.totalInRow * 2) >= 0 &&
          boardIndex - (GameConstants.totalInRow * 2) <
              GameConstants.totalInBoard) {
        emptyFences.remove(boardIndex - (GameConstants.totalInRow * 2));
      }
      if (boardIndex + (GameConstants.totalInRow * 4) >= 0 &&
          boardIndex + (GameConstants.totalInRow * 4) <
              GameConstants.totalInBoard) {
        emptyFences.remove(boardIndex + (GameConstants.totalInRow * 2));
      }
    }
  }

  // Increase OR decrease fences num by one.
  void _changeFencesNum(bool val) {
    if (player1.turn) {
      player1.fences.value += (val == true) ? -1 : 1;
    } else {
      player2.fences.value += (val == true) ? -1 : 1;
    }
  }

  // Return true if current player has no fences left, otherwise return false.
  bool outOfFences() =>
      player1.turn ? player1.outOfFences() : player2.outOfFences();

  // Return true if opponent player has no fences left, otherwise return false.
  bool opponentOutOfFences() =>
      player1.turn ? player2.outOfFences() : player1.outOfFences();

  bool testIfAdjacentToOtherFenceForVerticalFenceTop(int boardIndex) {
    if (inBoardRange(boardIndex - (GameConstants.totalInRow * 2))) {
      if (fences[boardIndex - GameConstants.totalInRow - 1].placed! ||
          fences[boardIndex - GameConstants.totalInRow + 1].placed! ||
          fences[boardIndex - (GameConstants.totalInRow * 2)].placed!) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  bool testIfAdjacentToOtherFenceForVerticalFenceBottom(int boardIndex) {
    if (inBoardRange(boardIndex + (GameConstants.totalInRow * 4))) {
      if (fences[boardIndex + (GameConstants.totalInRow * 3) - 1].placed! ||
          fences[boardIndex + (GameConstants.totalInRow * 3) + 1].placed! ||
          fences[boardIndex + (GameConstants.totalInRow * 4)].placed!) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  bool testIfAdjacentToOtherFenceForVerticalFenceMiddle(int boardIndex) {
    if (fences[boardIndex + GameConstants.totalInRow - 1].placed! ||
        fences[boardIndex + GameConstants.totalInRow + 1].placed!) {
      return true;
    }
    return false;
  }

  bool testIfConnectedOnTwoPointsForVerticalFence(int boardIndex) {
    bool top = testIfAdjacentToOtherFenceForVerticalFenceTop(boardIndex);
    bool bottom = testIfAdjacentToOtherFenceForVerticalFenceBottom(boardIndex);
    bool middle = testIfAdjacentToOtherFenceForVerticalFenceMiddle(boardIndex);
    return (top && bottom) || (top && middle) || (bottom && middle);
  }

  bool testIfAdjacentToOtherFenceForHorizontalFenceLeft(int boardIndex) {
    if (boardIndex % GameConstants.totalInRow != 0) {
      if (fences[boardIndex - 1 - GameConstants.totalInRow].placed! ||
          fences[boardIndex - 1 + GameConstants.totalInRow].placed! ||
          fences[boardIndex - 4].placed!) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  bool testIfAdjacentToOtherFenceForHorizontalFenceRight(int boardIndex) {
    if (boardIndex % GameConstants.totalInRow != 14) {
      if (fences[boardIndex + 3 - GameConstants.totalInRow].placed! ||
          fences[boardIndex + 3 + GameConstants.totalInRow].placed! ||
          fences[boardIndex + 4].placed!) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  bool testIfAdjacentToOtherFenceForHorizontalFenceMiddle(int boardIndex) {
    if (fences[boardIndex + 1 - GameConstants.totalInRow].placed! ||
        fences[boardIndex + 1 + GameConstants.totalInRow].placed!) {
      return true;
    }
    return false;
  }

  bool testIfConnectedOnTwoPointsForHorizontalFence(int boardIndex) {
    bool left = testIfAdjacentToOtherFenceForHorizontalFenceLeft(boardIndex);
    bool right = testIfAdjacentToOtherFenceForHorizontalFenceRight(boardIndex);
    bool middle =
        testIfAdjacentToOtherFenceForHorizontalFenceMiddle(boardIndex);
    return (left && right) || (left && middle) || (right && middle);
  }

  // Checking that both players are NOT completely blocked from reaching the opposing baseline
  bool canReachOtherSide(int boardIndex, bool isVertical) {
    late Player tempPlayer1, tempPlayer2;
    late bool result;

    if (isVertical) {
      if (!testIfConnectedOnTwoPointsForVerticalFence(boardIndex)) {
        return true;
      }
    } else {
      if (!testIfConnectedOnTwoPointsForHorizontalFence(boardIndex)) {
        return true;
      }
    }

    tempPlayer1 = Player.copy(obj: player1);
    tempPlayer2 = Player.copy(obj: player2);

    // place a temporary fence.
    placeFence(boardIndex, isVertical, true, true);
    result = tempPlayer1.bfsSearch(fences) && tempPlayer2.bfsSearch(fences);
    // remove temporary fence.
    placeFence(boardIndex, isVertical, false, true);

    return result;
  }

  List<int> getProbableMoves() {
    List<int> probableMoves = [];
    if (opponentOutOfFences()) {
      // Heuristic: If opponent has no walls left, my pawn moves only to one of the shortest paths.
      probableMoves += getMovesToShortestPath();
      // Heuristic: If opponent has no walls left, place walls only to interrupt the opponent's path, not to support my pawn.
      if (!outOfFences()) {
        // Disturb opponent
        probableMoves += getFencesNextPlayer(
          player1.turn ? player2.position : player1.position,
        );
        probableMoves += getFencesToInterruptPath();
      }
    } else {
      probableMoves += possibleMoves;
      if (!outOfFences()) {
        probableMoves += getProbableFences();
      }
    }
    // Remove duplicates before returning.
    return probableMoves.toSet().toList();
  }

  // Return all the non placed fences that won't block any player from reaching the opposing baseline.
  List<int> getEmptyValidFences() {
    List<int> emptyValidFences = [];
    for (int i = 0; i < emptyFences.length; i++) {
      if (canReachOtherSide(
          emptyFences[i],
          fences[emptyFences[i]].type == FenceType.verticalFence
              ? true
              : false)) {
        emptyValidFences.add(emptyFences[i]);
      }
    }
    return emptyValidFences;
  }

  // Return all fences which surround the player.
  List<int> getFencesNextPlayer(int position) {
    List<int> fencesNextPlayer = [];
    if (position >= (GameConstants.totalInRow * 2)) {
      // row >= 1
      if (position % (GameConstants.totalInRow * 2) >= 2) {
        // col >= 1
        if (emptyFences.contains(position - GameConstants.totalInRow - 2) &&
            canReachOtherSide(position - GameConstants.totalInRow - 2, false)) {
          fencesNextPlayer.add(position - GameConstants.totalInRow - 2);
        }
        if (emptyFences
                .contains(position - (GameConstants.totalInRow * 2) - 1) &&
            canReachOtherSide(
                position - (GameConstants.totalInRow * 2) - 1, true)) {
          fencesNextPlayer.add(position - (GameConstants.totalInRow * 2) - 1);
        }
        if (position % (GameConstants.totalInRow * 2) >= 4 &&
            emptyFences.contains(position - GameConstants.totalInRow - 4) &&
            canReachOtherSide(position - GameConstants.totalInRow - 4, false)) {
          // col >= 2
          fencesNextPlayer.add(position - GameConstants.totalInRow - 4);
        }
      }
      if (position % (GameConstants.totalInRow * 2) <= 14) {
        // col <= 7
        if (emptyFences.contains(position - GameConstants.totalInRow) &&
            canReachOtherSide(position - GameConstants.totalInRow, false)) {
          fencesNextPlayer.add(position - GameConstants.totalInRow);
        }
        if (emptyFences
                .contains(position - (GameConstants.totalInRow * 2) + 1) &&
            canReachOtherSide(
                position - (GameConstants.totalInRow * 2) + 1, true)) {
          fencesNextPlayer.add(position - (GameConstants.totalInRow * 2) + 1);
        }
        if (position % (GameConstants.totalInRow * 2) <= 12 &&
            emptyFences.contains(position - GameConstants.totalInRow + 2) &&
            canReachOtherSide(position - GameConstants.totalInRow + 2, false)) {
          // col <= 6
          fencesNextPlayer.add(position - GameConstants.totalInRow + 2);
        }
      }
      if (position >= (GameConstants.totalInRow) * 4) {
        // row >= 2
        if (position % (GameConstants.totalInRow * 2) >= 2 &&
            emptyFences
                .contains(position - (GameConstants.totalInRow * 4) - 1) &&
            canReachOtherSide(
                position - (GameConstants.totalInRow * 4) - 1, true)) {
          // col >= 1
          fencesNextPlayer.add(position - (GameConstants.totalInRow * 4) - 1);
        }
        if (position % (GameConstants.totalInRow * 2) <= 14 &&
            emptyFences
                .contains(position - (GameConstants.totalInRow * 4) + 1) &&
            canReachOtherSide(
                position - (GameConstants.totalInRow * 4) + 1, true)) {
          // col <= 7
          fencesNextPlayer.add(position - (GameConstants.totalInRow * 4) + 1);
        }
      }
    }
    if (position <
        (GameConstants.totalInRow * (GameConstants.totalInRow - 1))) {
      // row <= 7
      if (position % (GameConstants.totalInRow * 2) >= 2) {
        // col >= 1
        if (emptyFences.contains(position + GameConstants.totalInRow - 2) &&
            canReachOtherSide(position + GameConstants.totalInRow - 2, false)) {
          fencesNextPlayer.add(position + GameConstants.totalInRow - 2);
        }
        if (emptyFences.contains(position - 1) &&
            canReachOtherSide(position - 1, true)) {
          fencesNextPlayer.add(position - 1);
        }
        if (position % (GameConstants.totalInRow * 2) >= 4 &&
            emptyFences.contains(position + GameConstants.totalInRow - 4) &&
            canReachOtherSide(position + GameConstants.totalInRow - 4, false)) {
          // col >= 2
          fencesNextPlayer.add(position + GameConstants.totalInRow - 4);
        }
      }
      if (position % (GameConstants.totalInRow * 2) <= 14) {
        // col <= 7
        if (emptyFences.contains(position + GameConstants.totalInRow) &&
            canReachOtherSide(position + GameConstants.totalInRow, false)) {
          fencesNextPlayer.add(position + GameConstants.totalInRow);
        }
        if (emptyFences.contains(position + 1) &&
            canReachOtherSide(position + 1, true)) {
          fencesNextPlayer.add(position + 1);
        }
        if (position % (GameConstants.totalInRow * 2) <= 12 &&
            emptyFences.contains(position + GameConstants.totalInRow + 2) &&
            canReachOtherSide(position + GameConstants.totalInRow + 2, false)) {
          // col <= 6
          fencesNextPlayer.add(position + GameConstants.totalInRow + 2);
        }
      }
      if (position <
          (GameConstants.totalInRow * (GameConstants.totalInRow - 3))) {
        // row <= 6
        if (position % (GameConstants.totalInRow * 2) >= 2 &&
            emptyFences
                .contains(position + (GameConstants.totalInRow * 2) - 1) &&
            canReachOtherSide(
                position + (GameConstants.totalInRow * 2) - 1, true)) {
          // col >= 1
          fencesNextPlayer.add(position + (GameConstants.totalInRow * 2) - 1);
        }
        if (position % (GameConstants.totalInRow * 2) <= 14 &&
            emptyFences
                .contains(position + (GameConstants.totalInRow * 2) + 1) &&
            canReachOtherSide(
                position + (GameConstants.totalInRow * 2) + 1, true)) {
          // col <= 7
          fencesNextPlayer.add(position + (GameConstants.totalInRow * 2) + 1);
        }
      }
    }
    return fencesNextPlayer;
  }

  // Return empty left and right side horizontal fences.
  List<int> getSideHorizontalFences() {
    List<int> sideHorizontalFences = [];
    for (int i = 0; i < 8; i++) {
      if (emptyFences.contains(
              (GameConstants.totalInRow * 2 * i) + GameConstants.totalInRow) &&
          canReachOtherSide(
              (GameConstants.totalInRow * 2 * i) + GameConstants.totalInRow,
              false)) {
        sideHorizontalFences
            .add((GameConstants.totalInRow * 2 * i) + GameConstants.totalInRow);
      }
      if (emptyFences.contains((GameConstants.totalInRow * 2 * (i + 1)) - 3) &&
          canReachOtherSide(
              (GameConstants.totalInRow * 2 * (i + 1)) - 3, false)) {
        sideHorizontalFences.add((GameConstants.totalInRow * 2 * (i + 1)) - 3);
      }
    }
    return sideHorizontalFences;
  }

  // Get moves which leads you to shortest path.
  List<int> getMovesToShortestPath() {
    List<int> prev = [], bestMoves = [];
    List<List<int>> possiblePaths = [];

    Player tempPlayer1 = Player.copy(obj: player1);
    Player tempPlayer2 = Player.copy(obj: player2);

    if (player1.turn) {
      prev = tempPlayer1.bfs(fences, tempPlayer2.position);
      tempPlayer1 = Player.copy(obj: player1);
      possiblePaths = tempPlayer1.findMinPaths(prev, tempPlayer2.position);
    } else {
      prev = tempPlayer2.bfs(fences, tempPlayer1.position);
      tempPlayer2 = Player.copy(obj: player2);
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

  // place fences only to interrupt the opponent's path.
  List<int> getFencesToInterruptPath() {
    List<int> fencesToInterruptPath = [], emptyFences = [], prev = [];
    List<List<int>> possiblePaths = [];
    late int minPath;

    Player tempPlayer1 = Player.copy(obj: player1);
    Player tempPlayer2 = Player.copy(obj: player2);

    if (player1.turn) {
      prev = tempPlayer2.bfs(fences, tempPlayer1.position);
      tempPlayer2 = Player.copy(obj: player2);
      possiblePaths = tempPlayer2.findMinPaths(prev, tempPlayer1.position);
    } else {
      prev = tempPlayer1.bfs(fences, tempPlayer2.position);
      tempPlayer1 = Player.copy(obj: player1);
      possiblePaths = tempPlayer1.findMinPaths(prev, tempPlayer2.position);
    }
    if (possiblePaths.isEmpty) {
      possiblePaths.add([
        player1.turn ? player1.position : player2.position,
        possibleMoves[0]
      ]);
    }

    minPath = possiblePaths[0].length;

    emptyFences = getEmptyValidFences();

    for (int i = 0; i < emptyFences.length; i++) {
      // Add a temporary fence.
      placeFence(
        emptyFences[i],
        fences[emptyFences[i]].type == FenceType.verticalFence ? true : false,
        true,
        true,
      );

      tempPlayer1 = Player.copy(obj: player1);
      tempPlayer2 = Player.copy(obj: player2);

      if (player1.turn) {
        prev = tempPlayer2.bfs(fences, tempPlayer1.position);
        tempPlayer2 = Player.copy(obj: player2);
        possiblePaths = tempPlayer2.findMinPaths(prev, tempPlayer1.position);
      } else {
        prev = tempPlayer1.bfs(fences, tempPlayer2.position);
        tempPlayer1 = Player.copy(obj: player1);
        possiblePaths = tempPlayer1.findMinPaths(prev, tempPlayer2.position);
      }
      if (possiblePaths.isEmpty) {
        possiblePaths.add([
          player1.turn ? player1.position : player2.position,
          possibleMoves[0]
        ]);
      }
      if (possiblePaths[0].length > minPath) {
        fencesToInterruptPath.add(emptyFences[i]);
      }
      // Remove temporary fence.
      placeFence(
        emptyFences[i],
        fences[emptyFences[i]].type == FenceType.verticalFence ? true : false,
        false,
        true,
      );
    }
    return fencesToInterruptPath;
  }

  List<int> getProbableFences() {
    List<int> probableFences = [];
    if (turn >= 6) {
      // Disturb opponent
      probableFences += getFencesNextPlayer(
        player1.turn ? player2.position : player1.position,
      );
      // Leftmost and rightmost horizontal fences
      // probableFences += getSideHorizontalFences();
      // Support myself
      probableFences += getFencesNextPlayer(
        player1.turn ? player1.position : player2.position,
      );
    }
    return probableFences.toSet().toList();
  }
}
