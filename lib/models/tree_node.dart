import 'dart:math';

// The TreeNode class represents a node of the MCTS tree.
// It contains the information needed for the algorithm to run its search.
class TreeNode {
  TreeNode? parent;
  Map<int, TreeNode> children = {};
  int position;
  bool isTerminal;
  late bool isFullyExpanded = isTerminal;
  // visits represents the visit count of the node, i.e. how many times we have visited the node.
  int visits = 0;
  // score represents the sum of the value of the rollouts that have been started from this node.
  int score = 0;
  List<int>? probableMoves;

  TreeNode({
    this.parent,
    required this.position,
    required this.isTerminal,
    this.probableMoves,
  });

  double getWinRate() => score / visits;

  // Calculate the upper confidence bound for the tree.
  double ucb1(TreeNode childNode, int explorationConstant) {
    double exploitation = childNode.score / childNode.visits;
    // double exploration =
    //     explorationConstant * sqrt(log(visits / childNode.visits));
    double exploration =
        sqrt(explorationConstant * log(visits / childNode.visits));
    return exploitation + exploration;
  }

  // Select the best node basing on UCB1 formula
  TreeNode getBestMove(int explorationConstant) {
    // Define best score & best moves
    double bestScore = -1.0 / 0.0; // minus infinity
    List<TreeNode> bestMoves = [];
    double? moveScore;

    // Loop over child nodes
    for (final childNode in children.values) {
      // get move score using UCT formula
      moveScore = ucb1(childNode, explorationConstant);

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

    return bestMoves[Random().nextInt(bestMoves.length)];
  }

  // We will pick the child node from the current one that we are searching
  // from which has the maximum visit count,
  // as this is associated with a good value anyway,
  // given how the MCTS formula works
  // (i.e. it visits more often nodes that have higher estimated values).
  TreeNode maxSimulationsChild() {
    double maxSims = -1.0 / 0.0; // minus infinity
    List<TreeNode> maxSimulations = [];

    // Loop over child nodes
    for (final childNode in children.values) {
      // better child has been found
      if (childNode.visits > maxSims) {
        maxSims = (childNode.visits).toDouble();
        maxSimulations = [childNode];
      }

      // found as good child as already available
      else if (childNode.visits == maxSims) {
        maxSimulations.add(childNode);
      }
    }
    return maxSimulations[Random().nextInt(maxSimulations.length)];
  }
}
