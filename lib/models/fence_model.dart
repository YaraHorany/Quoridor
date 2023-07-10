enum FenceType {
  squareFence,
  horizontalFence,
  verticalFence,
}

class FenceModel {
  final int position;
  bool placed;
  bool temporaryFence;
  final FenceType type;

  FenceModel({
    required this.position,
    required this.placed,
    required this.temporaryFence,
    required this.type,
  });

  factory FenceModel.copy({required FenceModel obj}) => FenceModel(
        position: obj.position,
        placed: obj.placed,
        temporaryFence: obj.temporaryFence,
        type: obj.type,
      );
}
