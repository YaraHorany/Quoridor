import 'dart:ui';
import 'package:quoridor/constants/game_constants.dart';

class Player {
  int position;
  int fences;
  final Color color;

  Player({
    required this.position,
    required this.fences,
    required this.color,
  });

  void moveUp(int steps) {
    position -= (GameConstants.totalInRow * 2 * steps);
  }

  void moveDown(int steps) {
    position += (GameConstants.totalInRow * 2 * steps);
  }

  void moveRight(int steps) {
    position += (2 * steps);
  }

  void moveLeft(int steps) {
    position -= (2 * steps);
  }
}
