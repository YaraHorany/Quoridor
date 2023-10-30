import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_controller.dart';
import 'package:quoridor/widgets/board.dart';

class GameScreen extends StatelessWidget {
  final GameController gameController = Get.find<GameController>();

  GameScreen({Key? key}) : super(key: key);

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
                          Row(
                            children: [
                              const Text('Player'),
                              Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: gameController.player1.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          Obx(() =>
                              Text(gameController.player1.fences.toString())),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              const Text('Player'),
                              Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: gameController.player2.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          Obx(() =>
                              Text(gameController.player2.fences.toString())),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => Text(gameController.msg.value.toString())),
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
                    gameController.dragType = DragType.horizontalDrag;
                    gameController.update();
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
                    gameController.dragType = DragType.verticalDrag;
                    gameController.update();
                  },
                  data: Colors.grey,
                  child: Container(
                    color: Colors.grey,
                    width: 15,
                    height: 70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
