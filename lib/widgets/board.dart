import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:quoridor/widgets/square.dart';
import '../../models/fence_model.dart';
import 'package:quoridor/controllers/game_controller.dart';
import 'package:quoridor/utils/game_constants.dart';
import '../utils/dimensions.dart';
import 'fence.dart';

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
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width10, vertical: Dimensions.height10),
            margin: EdgeInsets.symmetric(
                horizontal: Dimensions.width10, vertical: Dimensions.height10),
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
      if (gameController.game.squares.contains(i)) {
        boardCells.add(StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: Square(gameController: gameController, index: i),
        ));
      } else {
        boardCells.add(
          StaggeredGridTile.count(
            crossAxisCellCount:
                gameController.game.fences[i].type == FenceType.horizontalFence
                    ? 2
                    : 1,
            mainAxisCellCount:
                gameController.game.fences[i].type == FenceType.verticalFence
                    ? 2
                    : 1,
            child: Fence(gameController: gameController, boardIndex: i),
          ),
        );
      }
    }
    return boardCells;
  }
}
