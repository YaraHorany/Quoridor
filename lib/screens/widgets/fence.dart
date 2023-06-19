import 'package:flutter/material.dart';
import '../../controllers/game_controller.dart';
import '../../models/fence_model.dart';

class Fence extends StatelessWidget {
  final GameController gameController;
  final int index;

  const Fence({
    Key? key,
    required this.gameController,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (gameController.fence[index].type == FenceType.horizontalFence ||
              gameController.fence[index].type == FenceType.squareFence) {
            if (details.primaryDelta! < 0) {
              print(gameController.fence[index].position);
              print('moving left');
            } else {
              print(gameController.fence[index].position);
              print('moving right');
            }
          }
        },
        child: Container(
          color: gameController.fence[index].placed ? Colors.grey : Colors.blue,
        ));
  }
}
