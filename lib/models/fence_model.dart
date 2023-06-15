import 'dart:ui';

enum FenceType {
  square,
  horizontalRectangle,
  verticalRectangle,
}

class Fence {
  final int position;
  Color color;
  final FenceType type;

  Fence({
    required this.position,
    required this.color,
    required this.type,
  });
}
