import 'package:flutter/material.dart';
import '../widgets/board.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: Board(),
          ),
        ],
      ),
    );
  }
}
