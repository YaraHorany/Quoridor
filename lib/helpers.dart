import 'package:quoridor/utils/game_constants.dart';

bool isNotLastColumn(int index) =>
    index % GameConstants.totalInRow != GameConstants.totalInRow - 1;

bool isNotLastRow(int index) =>
    index ~/ GameConstants.totalInRow != GameConstants.totalInRow - 1;

bool inBoardRange(int index) =>
    index >= 0 && index < 289 && (index ~/ GameConstants.totalInRow) % 2 == 0;

bool reachedFirstRow(int index) {
  for (int i = 0; i <= 16; i += 2) {
    if (i == index) {
      return true;
    }
  }
  return false;
}

bool reachedLastRow(int index) {
  for (int i = 272; i <= 288; i += 2) {
    if (i == index) {
      return true;
    }
  }
  return false;
}
