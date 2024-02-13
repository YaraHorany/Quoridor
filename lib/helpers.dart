import 'package:quoridor/utils/game_constants.dart';

bool isNotLastColumn(int index) =>
    index % GameConstants.totalInRow != GameConstants.totalInRow - 1;

bool isNotLastRow(int index) =>
    index ~/ GameConstants.totalInRow != GameConstants.totalInRow - 1;

bool inBoardRange(int index) => (index >= 0 &&
    index < GameConstants.totalInBoard &&
    (index ~/ GameConstants.totalInRow) % 2 == 0);

bool reachedFirstRow(int index) {
  for (int i = 0; i < GameConstants.totalInRow; i += 2) {
    if (i == index) {
      return true;
    }
  }
  return false;
}

bool reachedLastRow(int index) {
  for (int i = GameConstants.totalInBoard - GameConstants.totalInRow;
      i < GameConstants.totalInBoard;
      i += 2) {
    if (i == index) {
      return true;
    }
  }
  return false;
}
