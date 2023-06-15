import 'package:flutter/material.dart';

class Cell extends StatelessWidget {
  final Color? color;

  const Cell({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: color == null
          ? Container()
          : Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
    );
  }
}
