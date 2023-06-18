enum FenceType {
  squareFence,
  horizontalFence,
  verticalFence,
}

class Fence {
  final int position;
  bool placed;
  final FenceType type;

  Fence({
    required this.position,
    required this.placed,
    required this.type,
  });
}
