import 'package:flutter/material.dart';

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
        fontSize: size == null ? 14 : MediaQuery.of(context).size.width * size!,
        fontStyle: italicFont ? FontStyle.italic : FontStyle.normal,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
