import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers.dart';
import '../models/ai_model.dart';
import '../models/fence_model.dart';
import '../models/game_model.dart';
import '../models/player_model.dart';
import 'package:quoridor/utils/game_constants.dart';
import 'package:quoridor/utils/dimensions.dart';
import '../screens/intro_screen.dart';

enum DragType {
  horizontalDrag,
  verticalDrag,
}

class GameController extends GetxController {
  late Game game;
  AI? ai;
  DragType? dragType;
  late bool singlePlayerGame;
  RxString msg = "".obs;

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

  // Reset the game
  void reset() {
    game.reset();
    update();
  }

  // Initialize an AI only if it's a single player game.
  void playAgainstAI(bool mood, {int? simulationNum}) {
    singlePlayerGame = mood;
    if (singlePlayerGame) {
      ai = AI(numSimulations: simulationNum!);
    }
  }

  // Move the pawns and check if the game has ended.
  Future<void> move(int index) async {
    if (singlePlayerGame && game.player2.turn) return;
    if (game.move(index)) {
      if (_winnerFound()) return;
      if (singlePlayerGame && game.player2.turn) {
        await ai!.chooseNextMove(game);
        _winnerFound();
        // update();
      }
      update();
    }
  }

  // Draw a horizontal/vertical fence.
  Future<void> drawFence(int boardIndex) async {
    String? msg;
    if (singlePlayerGame && game.player2.turn) return;
    if (!game.outOfFences()) {
      if (dragType == DragType.verticalDrag) {
        msg = game.checkAndUpdateFence(
            boardIndex, FenceType.horizontalFence, GameConstants.totalInRow);
      } else {
        msg = game.checkAndUpdateFence(boardIndex, FenceType.verticalFence, 1);
      }
      update();
      if (msg != null) {
        if (msg == '') {
          // update();
          if (singlePlayerGame && game.player2.turn) {
            await ai!.chooseNextMove(game);
            // update();
            _winnerFound();
            update();
          }
        } else {
          _popUpMessage(msg);
        }
      }
      // update();
    } else {
      _popUpMessage('   There are no more\n fences for you to place');
    }
  }

  // Draw a temporary horizontal/vertical fence.
  void drawTemporaryFence(int boardIndex, bool val) {
    if (singlePlayerGame && game.player2.turn) return;
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

  // Show a message on the screen
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

  // Check if there's a winner and display an appropriate dialog.
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
                      margin: EdgeInsets.symmetric(
                          vertical: Dimensions.height5,
                          horizontal: Dimensions.width5),
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height10,
                          horizontal: Dimensions.width10),
                      decoration: BoxDecoration(
                        color: reachedFirstRow(game.player1.position)
                            ? game.player1.color
                            : game.player2.color,
                        shape: BoxShape.circle,
                      )),
                  const Text('WON'),
                ],
              ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text(
              'Restart',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Get.to(() => IntroScreen());
              reset();
            },
          ),
        ],
      ).then((value) => reset());
      return true;
    }
    return false;
  }
}
