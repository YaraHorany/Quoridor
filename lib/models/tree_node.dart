import 'dart:math';

class TreeNode {
  TreeNode? parent;
  Map<int, TreeNode> children = {};
  int position;
  bool isTerminal;
  late bool isFullyExpanded = isTerminal;
  int visits = 0;
  int score = 0;
  List<int>? probableMoves;

  TreeNode({
    this.parent,
    required this.position,
    required this.isTerminal,
    this.probableMoves,
  });

  // Select the best node basing on UCB1 formula
  TreeNode getBestMove(int explorationConstant) {
    // Define best score & best moves
    double bestScore = -1.0 / 0.0; // minus infinity
    List<TreeNode> bestMoves = [];
    double? moveScore;

    // Loop over child nodes
    for (final childNode in children.values) {
      // get move score using UCT formula
      moveScore = childNode.score / childNode.visits +
          explorationConstant * sqrt(log(visits / childNode.visits));

      // better move has been found
      if (moveScore > bestScore) {
        bestScore = moveScore;
        bestMoves = [childNode];
      }

      // found as good move as already available
      else if (moveScore == bestScore) {
        bestMoves.add(childNode);
      }
    }
    // return one of the best moves randomly
    return bestMoves[Random().nextInt(bestMoves.length)];
  }
}
