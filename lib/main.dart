import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quoridor/screens/game_screen/game_screen.dart';

import 'controllers/game_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quoridor Board Game',
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => GameScreen(),
          binding: BindingsBuilder(() => {
                Get.lazyPut<GameController>(() => GameController()),
              }),
        ),
      ],
    );
  }
}
