import 'package:flutter/material.dart';
import '../utils/dimensions.dart';

class ContentText extends StatelessWidget {
  final String content;
  final double? size;
  final bool italicFont;

  const ContentText({
    Key? key,
    required this.content,
    this.size,
    required this.italicFont,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
        color: Colors.white,
        fontSize: size == null
            ? Dimensions.fontSize14
            : Dimensions.screenWidth * size!,
        fontStyle: italicFont ? FontStyle.italic : FontStyle.normal,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
