import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/game_controller.dart';
import '../widgets/board.dart';

class GameScreen extends StatelessWidget {
  final GameController gameController = Get.put(GameController());

  GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Board(),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('player 1:'),
                    Obx(() => Text(gameController.player1.fences.toString())),
                  ],
                ),
                Column(
                  children: [
                    const Text('player 2:'),
                    Obx(() => Text(gameController.player2.fences.toString())),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
