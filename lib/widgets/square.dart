import 'package:flutter/material.dart';
import 'package:quoridor/controllers/game_controller.dart';

class Square extends StatelessWidget {
  final GameController gameController;
  final int index;

  const Square({
    Key? key,
    required this.gameController,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        gameController.move(index);
      },
      child: Container(
        color: gameController.possibleMoves.contains(index)
            ? Colors.lightBlueAccent
            : Colors.white,
        child: (gameController.player1.position == index ||
                gameController.player2.position == index)
            ? Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: gameController.player1.position == index
                      ? gameController.player1.color
                      : gameController.player2.color,
                  shape: BoxShape.circle,
                ),
              )
            : Center(
                // child: Text(
                //   index.toString(),
                //   style: const TextStyle(color: Colors.blue),
                // ),
                ),
      ),
    );
  }
}
