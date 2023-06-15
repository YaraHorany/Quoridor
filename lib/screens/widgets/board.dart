import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../../models/fence_model.dart';
import 'package:quoridor/controllers/game_controller.dart';

class Board extends StatelessWidget {
  final GameController gameController = Get.put(GameController());

  List<StaggeredGridTile> _boardCells() {
    List<StaggeredGridTile> boardCells = [];
    for (int i = 0; i < 289; i++) {
      if (gameController.path.contains(i)) {
        boardCells.add(StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: GestureDetector(
            child: Container(
              color: Colors.white,
              child: (gameController.player1.position == i ||
                      gameController.player2.position == i)
                  ? Container(
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: gameController.player1.position == i
                            ? gameController.player1.color
                            : gameController.player2.color,
                        shape: BoxShape.circle,
                      ),
                    )
                  : Center(
                      child: Text(
                        i.toString(),
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
            ),
          ),
        ));
      } else {
        int index =
            gameController.fence.indexWhere((element) => element.position == i);
        print(gameController.fence[index].position);
        print(gameController.fence[index].type);
        boardCells.add(StaggeredGridTile.count(
          crossAxisCellCount:
              gameController.fence[index].type == FenceType.horizontalRectangle
                  ? 2
                  : 1,
          mainAxisCellCount:
              gameController.fence[index].type == FenceType.verticalRectangle
                  ? 2
                  : 1,
          child: Container(color: Colors.blue),
        ));
      }
    }
    return boardCells;
  }

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
            child: StaggeredGrid.count(
              crossAxisCount: (9 * 2) + (8 * 1),
              children: _boardCells(),
            ),
          ),
        ],
      ),
    );
  }
}
