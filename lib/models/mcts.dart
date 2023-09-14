class TreeNode {
  int? parent;
  int position;
  bool isTerminal = false;
  bool isFullyExpanded = false;
  int visits = 0;
  int score = 0;
  Map children = {};

  TreeNode({
    required this.position,
    this.parent,
  });
}

class MCTS {
  void search() {
    // create root node
    TreeNode root = TreeNode(position: 8);
    late TreeNode node;
    late int score;

    // walk through 1000 iterations
    for (int iteration = 0; iteration < 1000; iteration++) {
      print('Iteration number: $iteration');
      node = select(root);

      // score current node (simulation phase)
      score = rollout();

      // backPropagate results
      backPropagate(node, score);
    }

    // pick up the best move in the current position
    // try{
    //   return getBestMove(root, 0);}
    //
    // except{
    // pass}
  }

  TreeNode select(TreeNode node) {
    TreeNode node = TreeNode(position: 1);
    return node;
  }

  void expand() {}

  int rollout() {
    return 0;
  }

  // backpropagate the number of visits and score up to the root node
  void backPropagate(TreeNode node, int score) {}

  void getBestMove(TreeNode node, int explorationConstant) {}
}
