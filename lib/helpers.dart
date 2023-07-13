import 'package:quoridor/utils/game_constants.dart';

bool isNotLastColumn(int index) =>
    index % (GameConstants.totalInRow * 2) !=
    (GameConstants.totalInRow * 2) - 1;

bool isNotLastRow(int index) =>
    index ~/ GameConstants.totalInRow != GameConstants.totalInRow - 1;

bool inBoardRange(index) =>
    index >= 0 && index < 289 && (index ~/ GameConstants.totalInRow) % 2 == 0;

bool reachedFirstRow(int index) => (index >= 0 && index <= 16);
bool reachedLastRow(int index) => (index >= 272 && index <= 288);
