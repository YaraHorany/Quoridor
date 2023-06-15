import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'cell.dart';
import 'package:quoridor/controllers/game_controller.dart';

class Board extends StatelessWidget {
  final GameController gameController = Get.put(GameController());
  List<String> board = [];

  List<StaggeredGridTile> _boardCells() {
    board = gameController.board;
    List<StaggeredGridTile> boardCells = [];
    for (int i = 0; i < 289; i++) {
      if (board[i] == 'path' || board[i] == 'p1' || board[i] == 'p2') {
        boardCells.add(StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: Cell(
            color: board[i] == 'p1'
                ? Colors.green
                : board[i] == 'p2'
                    ? Colors.orange
                    : null,
          ),
        ));
      } else if (board[i] == 'vertical empty fence' ||
          board[i] == 'vertical taken fence') {
        boardCells.add(StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 2,
          child: Container(
              color: board[i] == 'vertical empty fence'
                  ? Colors.blue
                  : Colors.grey),
        ));
      } else if (board[i] == 'horizontal empty fence' ||
          board[i] == 'horizontal taken fence') {
        boardCells.add(StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: GestureDetector(
            child: Container(
                color: board[i] == 'horizontal empty fence'
                    ? Colors.blue
                    : Colors.grey),
          ),
        ));
      } else {
        boardCells.add(StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
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
