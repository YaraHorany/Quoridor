class TreeNode {
  TreeNode? parent;
  Map<int, TreeNode> children = {};
  int position;
  bool isTerminal;
  late bool isFullyExpanded = isTerminal;
  int visits = 0;
  int score = 0;

  TreeNode({
    this.parent,
    required this.position,
    required this.isTerminal,
  });
}
