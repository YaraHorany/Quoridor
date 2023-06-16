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

  void moveForward() {
    position += (GameConstants.squaresInRow * 2);
  }

  void moveBackward() {
    position -= (GameConstants.squaresInRow * 2);
  }
}
