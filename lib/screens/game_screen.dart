import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_controller.dart';
import 'package:quoridor/widgets/board.dart';
import '../models/player_model.dart';
import '../utils/dimensions.dart';
import 'intro_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GameScreen extends StatelessWidget {
  final GameController gameController = Get.find<GameController>();
  GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disable back button on game screen.
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: Dimensions.width30,
                        right: Dimensions.width30,
                        top: Dimensions.height30,
                        bottom: Dimensions.height5),
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
                        SizedBox(height: Dimensions.height40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() =>
                                Text(gameController.msg.value.toString())),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(flex: 3, child: Board()),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _draggableFence(DragType.horizontalDrag),
                          SizedBox(height: Dimensions.height10),
                          _draggableFence(DragType.verticalDrag),
                          SizedBox(height: Dimensions.height10),
                          Obx(() => Text(
                              (gameController.ai!.winRate.value).toString())),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          if (gameController.ai!.isLoading.value == false) {
                            Get.defaultDialog(
                              title: "",
                              titlePadding: const EdgeInsets.all(0),
                              middleText:
                                  "Are you sure to start a new game? \n(Current game will be lost!)",
                              actions: [
                                OutlinedButton(
                                    onPressed: () {
                                      gameController.reset();
                                      Get.to(() => IntroScreen());
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    child: const Text("Start",
                                        style: TextStyle(color: Colors.white))),
                                OutlinedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimensions.radius5)),
                              color: Colors.blue),
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10,
                              vertical: Dimensions.height10),
                          margin: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10,
                              vertical: Dimensions.height10),
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
            Obx(
              () => Center(
                child: gameController.ai!.isLoading.value == true
                    ? BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 1,
                          sigmaY: 1,
                        ),
                        child: SpinKitCircle(
                          color: Colors.grey,
                          size: Dimensions.loadingCircle100,
                        ),
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Draggable _draggableFence(DragType dragType) {
    double width = dragType == DragType.horizontalDrag
        ? Dimensions.width10 * 7
        : Dimensions.width5 * 3;
    double height = dragType == DragType.horizontalDrag
        ? Dimensions.height5 * 3
        : Dimensions.height10 * 7;
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

  Column _remainedFences(Player player) => Column(
        children: [
          Row(
            children: [
              const Text('Player'),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: Dimensions.height5,
                    horizontal: Dimensions.width5),
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.height10,
                    horizontal: Dimensions.width10),
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
