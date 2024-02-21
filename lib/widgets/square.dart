import 'package:flutter/material.dart';
import 'package:quoridor/controllers/game_controller.dart';
import '../utils/dimensions.dart';

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
        gameController.update();
        gameController.aiMove();
      },
      child: Container(
        color: gameController.game.possibleMoves.contains(index)
            ? Colors.lightBlueAccent
            : Colors.white,
        child: (gameController.game.player1.position == index ||
                gameController.game.player2.position == index)
            ? Container(
                margin: EdgeInsets.symmetric(
                    vertical: Dimensions.height5 * 3 / 5,
                    horizontal: Dimensions.width5 * 3 / 5),
                decoration: BoxDecoration(
                  color: gameController.game.player1.position == index
                      ? gameController.game.player1.color
                      : gameController.game.player2.color,
                  shape: BoxShape.circle,
                ),
              )
            : Center(
                child: Text(
                  index.toString(),
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
      ),
    );
  }
}
