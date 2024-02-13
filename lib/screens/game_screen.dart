import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_controller.dart';
import 'package:quoridor/widgets/board.dart';
import '../models/player_model.dart';
import 'intro_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GameScreen extends StatelessWidget {
  final GameController gameController = Get.find<GameController>();
  GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
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
                          _remainedFences(gameController.game.player1),
                          _remainedFences(gameController.game.player2),
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
                flex: 2,
                child: Board(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _draggableFence(DragType.horizontalDrag),
                        const SizedBox(height: 10),
                        _draggableFence(DragType.verticalDrag),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                          title: "",
                          titlePadding: const EdgeInsets.all(0),
                          middleText:
                              "Are you sure to start a new game? (Current game will be lost!)",
                          textConfirm: "Start",
                          onConfirm: () {
                            gameController.reset();
                            Get.to(() => IntroScreen());
                          },
                          textCancel: "Cancel",
                          onCancel: () {
                            Get.to(() => GameScreen());
                          },
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.blue),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: const Center(
                            child: Text(
                          "New Game",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Obx(() {
            print('OBX');
            return Center(
              child: gameController.isLoading.value == true
                  ? const SpinKitCircle(
                      color: Colors.grey,
                      size: 100.0,
                    )
                  : Container(),
            );
          }),
        ],
      ),
    );
  }

  Widget _draggableFence(DragType dragType) {
    double width = dragType == DragType.horizontalDrag ? 70 : 15;
    double height = dragType == DragType.horizontalDrag ? 15 : 70;
    return Draggable(
      feedback: Container(
        color: Colors.grey,
        width: width,
        height: height,
      ),
      onDragStarted: () {
        gameController.dragType = dragType;
        gameController.update();
      },
      data: Colors.grey,
      child: Container(
        color: Colors.grey,
        width: width,
        height: height,
      ),
    );
  }

  Widget _remainedFences(Player player) => Column(
        children: [
          Row(
            children: [
              const Text('Player'),
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: player.color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          Obx(() => Text(player.fences.toString())),
        ],
      );
}
