import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_controller.dart';
import 'package:quoridor/widgets/board.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 30, bottom: 5),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Player 1'),
                          Obx(() => Text(Get.find<GameController>()
                              .player1
                              .fences
                              .toString())),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Player 2'),
                          Obx(() => Text(Get.find<GameController>()
                              .player2
                              .fences
                              .toString())),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => Text(
                          Get.find<GameController>().msg.value.toString())),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Board(),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Draggable(
                  feedback: Container(
                    color: Colors.grey,
                    width: 70,
                    height: 15,
                  ),
                  onDragStarted: () {
                    Get.find<GameController>().dragType =
                        DragType.horizontalDrag;
                    Get.find<GameController>().update();
                  },
                  data: Colors.grey,
                  child: Container(
                    color: Colors.grey,
                    width: 70,
                    height: 15,
                  ),
                ),
                const SizedBox(height: 10),
                Draggable(
                  feedback: Container(
                    color: Colors.grey,
                    width: 15,
                    height: 70,
                  ),
                  onDragStarted: () {
                    Get.find<GameController>().dragType = DragType.verticalDrag;
                    Get.find<GameController>().update();
                  },
                  data: Colors.grey,
                  child: Container(
                    color: Colors.grey,
                    width: 15,
                    height: 70,
                  ),
                ),
                // Column(
                //   children: [
                //     TextButton(
                //       onPressed: () {
                //         Get.find<GameController>().resetGame();
                //       },
                //       child: const Text('Restart'),
                //     ),
                //     Obx(() => Text(
                //         Get.find<GameController>().winner.value.toString())),
                //     Obx(() =>
                //         Text(Get.find<GameController>().msg.value.toString())),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
