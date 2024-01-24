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
    // int fenceIndex = gameController.calcFenceIndex(boardIndex);
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
          color: gameController.fence[boardIndex].placed!
              ? Colors.grey
              : gameController.fence[boardIndex].temporaryFence!
                  ? Colors.green
                  : Colors.blue,
        );
      },
    );
  }
}
