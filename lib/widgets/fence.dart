import 'package:flutter/material.dart';
import '../../controllers/game_controller.dart';

class Fence extends StatelessWidget {
  final GameController gameController;
  final int boardIndex;

  const Fence({
    Key? key,
    required this.gameController,
    required this.boardIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onMove: (data) {
        gameController.drawTemporaryFence(boardIndex, true);
      },
      onLeave: (data) {
        gameController.drawTemporaryFence(boardIndex, false);
      },
      onAccept: (data) {
        gameController.drawFence(boardIndex);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          color: gameController.game.fences[boardIndex].placed!
              ? Colors.grey
              : gameController.game.fences[boardIndex].temporaryFence!
                  ? Colors.green
                  : Colors.blue,
        );
      },
    );
  }
}
