import 'dart:ui';

enum FenceType {
  square,
  horizontalRectangle,
  verticalRectangle,
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