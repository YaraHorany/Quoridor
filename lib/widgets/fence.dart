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
    int fenceIndex = gameController.calcFenceIndex(boardIndex);
    return DragTarget(
      onMove: (data) {
        gameController.drawTemporaryFence(boardIndex);
      },
      onLeave: (data) {
        gameController.removeTemporaryFence(boardIndex);
      },
      onAccept: (data) {
        gameController.drawFence(boardIndex);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          color: gameController.fence[fenceIndex].placed
              ? Colors.grey
              : gameController.fence[fenceIndex].temporaryFence
                  ? Colors.green
                  : Colors.blue,
        );
      },
    );
  }
}
