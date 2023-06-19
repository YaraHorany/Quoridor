import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/game_controller.dart';
import '../widgets/board.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

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
                    Obx(() => Text(
                        Get.find<GameController>().player1.fences.toString())),
                  ],
                ),
                Column(
                  children: [
                    const Text('player 2:'),
                    Obx(() => Text(
                        Get.find<GameController>().player2.fences.toString())),
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
