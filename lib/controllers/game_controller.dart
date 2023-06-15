import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/fence_model.dart';
import '../models/player_model.dart';

class GameController extends GetxController {
  late Player player1, player2;
  List<Fence> fence = [];
  List<int> path = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    buildBoard();
  }

  void buildBoard() {
    player1 = Player(position: 8, color: Colors.green);
    player2 = Player(position: 280, color: Colors.orange);

    for (int i = 0; i < 17 * 17; i++) {
      if ((i ~/ 17) % 2 == 0) {
        if (i % 2 == 0) {
          path.add(i);
        } else {
          print(i);
          fence.add(Fence(
              position: i,
              color: Colors.blue,
              type: FenceType.verticalRectangle));
        }
      } else {
        if (i % 2 == 0) {
          fence.add(Fence(
            position: i,
            color: Colors.blue,
            type: FenceType.square,
          ));
        } else {
          fence.add(Fence(
              position: i,
              color: Colors.blue,
              type: FenceType.horizontalRectangle));
        }
      }
    }
  }
}
