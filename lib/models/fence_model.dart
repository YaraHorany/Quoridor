enum FenceType {
  squareFence,
  horizontalFence,
  verticalFence,
}

class FenceModel {
  bool? placed;
  bool? temporaryFence;
  final FenceType? type;

  FenceModel({
    this.placed,
    this.temporaryFence,
    this.type,
  });

  factory FenceModel.copy({required FenceModel obj}) => FenceModel(
        placed: obj.placed,
        temporaryFence: obj.temporaryFence,
        type: obj.type,
      );
}
