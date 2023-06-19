import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:quoridor/screens/widgets/square.dart';
import '../../models/fence_model.dart';
import 'package:quoridor/controllers/game_controller.dart';
import 'package:quoridor/constants/game_constants.dart';

class Board extends StatelessWidget {
  final GameController gameController = Get.find<GameController>();

  Board({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: GetBuilder<GameController>(
              builder: (context) => StaggeredGrid.count(
                crossAxisCount: (GameConstants.squaresInRow * 2) +
                    (GameConstants.fencesInRow * 1),
                children: _boardCells(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<StaggeredGridTile> _boardCells() {
    List<StaggeredGridTile> boardCells = [];
    for (int i = 0; i < GameConstants.totalInBoard; i++) {
      if (gameController.path.contains(i)) {
        boardCells.add(StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: Square(gameController: gameController, index: i),
        ));
      } else {
        int index =
            gameController.fence.indexWhere((element) => element.position == i);

        boardCells.add(StaggeredGridTile.count(
          crossAxisCellCount:
              gameController.fence[index].type == FenceType.horizontalFence
                  ? 2
                  : 1,
          mainAxisCellCount:
              gameController.fence[index].type == FenceType.verticalFence
                  ? 2
                  : 1,
          child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (gameController.fence[index].type ==
                        FenceType.horizontalFence ||
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
                  color: gameController.fence[index].placed
                      ? Colors.grey
                      : Colors.blue)),
        ));
      }
    }
    return boardCells;
  }
}
