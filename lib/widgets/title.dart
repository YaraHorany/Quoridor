import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String title;
  final double size;

  const TitleText({
    Key? key,
    required this.title,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Samantha',
        color: Colors.white,
        fontSize: MediaQuery.of(context).size.width * size,
      ),
    );
  }
}
