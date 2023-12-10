import 'dart:math';

class TreeNode {
  TreeNode? parent;
  Map<int, TreeNode> children = {};
  int position;
  bool isTerminal;
  late bool isFullyExpanded = isTerminal;
  int visits = 0;
  int score = 0;
  List<int>? emptyValidFences;

  TreeNode({
    this.parent,
    required this.position,
    required this.isTerminal,
    this.emptyValidFences,
  });

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

  // TreeNode? parent;
  // Map<int, TreeNode> children = {};
  // int position;
  // int score = 0;
  // int visits = 0;
  // bool isTerminal = false;
  // List<int>? emptyValidFences;
  //
  // TreeNode({
  //   this.parent,
  //   required this.position,
  //   this.emptyValidFences,
  // });
  //
  // bool isLeaf() => children.isEmpty;
  // bool isNew() => visits == 0;
  //
  // double uct() {
  //   if (visits == 0) {
  //     // Unexplored nodes have maximum values so we favour exploration
  //     return 1.0 / 0.0; // Infinity
  //   } else {
  //     return score / visits + 0.2 * sqrt(log(parent!.visits / visits));
  //   }
  // }
  //
  // double winRate() => score / visits;
  //
  // TreeNode getBestMove() {
  //   // Define best score & best moves
  //   double bestScore = -1.0 / 0.0; // minus infinity
  //   List<TreeNode> bestMoves = [];
  //   double? moveScore;
  //
  //   // Loop over child nodes
  //   for (final childNode in children.values) {
  //     // get move score using UCT formula
  //     moveScore = childNode.uct();
  //
  //     // better move has been found
  //     if (moveScore > bestScore) {
  //       bestScore = moveScore;
  //       bestMoves = [childNode];
  //     }
  //
  //     // found as good move as already available
  //     else if (moveScore == bestScore) {
  //       bestMoves.add(childNode);
  //     }
  //   }
  //   // return one of the best moves randomly
  //   return bestMoves[Random().nextInt(bestMoves.length)];
  // }
}
