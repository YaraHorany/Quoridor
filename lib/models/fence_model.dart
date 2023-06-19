enum FenceType {
  squareFence,
  horizontalFence,
  verticalFence,
}

class FenceModel {
  final int position;
  bool placed;
  final FenceType type;

  FenceModel({
    required this.position,
    required this.placed,
    required this.type,
  });
}
