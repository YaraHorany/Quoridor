import 'package:flutter/material.dart';
import '../../controllers/game_controller.dart';
import '../../models/fence_model.dart';

class Fence extends StatelessWidget {
  final GameController gameController;
  final int i;

  const Fence({
    Key? key,
    required this.gameController,
    required this.i,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int index = gameController.fenceIndex(i);
    return DragTarget(
      onMove: (data) {
        if (gameController.fence[index].type == FenceType.horizontalFence &&
            gameController.dragType == DragType.horizontalDrag &&
            i % 34 != 33) {
          gameController.fence[index].placed = true;
          gameController.fence[gameController.fenceIndex(i + 1)].placed = true;
          gameController.fence[gameController.fenceIndex(i + 2)].placed = true;
          gameController.update();
        } else if (gameController.fence[index].type ==
                FenceType.verticalFence &&
            gameController.dragType == DragType.verticalDrag &&
            i ~/ 17 != 16) {
          gameController.fence[index].placed = true;
          gameController.fence[gameController.fenceIndex(i + 17)].placed = true;
          gameController.fence[gameController.fenceIndex(i + 34)].placed = true;
          gameController.update();
        }
      },
      onLeave: (data) {
        if (gameController.fence[index].type == FenceType.horizontalFence &&
            gameController.dragType == DragType.horizontalDrag &&
            i % 34 != 33) {
          gameController.fence[index].placed = false;
          gameController.fence[gameController.fenceIndex(i + 1)].placed = false;
          gameController.fence[gameController.fenceIndex(i + 2)].placed = false;
          gameController.update();
        } else if (gameController.fence[index].type ==
                FenceType.verticalFence &&
            gameController.dragType == DragType.verticalDrag &&
            i ~/ 17 != 16) {
          gameController.fence[index].placed = false;
          gameController.fence[gameController.fenceIndex(i + 17)].placed =
              false;
          gameController.fence[gameController.fenceIndex(i + 34)].placed =
              false;
          gameController.update();
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          color: gameController.fence[index].placed ? Colors.grey : Colors.blue,
        );
      },
    );
  }
}
