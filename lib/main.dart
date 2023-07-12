import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quoridor/screens/about_us.dart';
import 'package:quoridor/screens/how_to_play.dart';
import 'package:quoridor/screens/game_screen.dart';
import 'package:quoridor/screens/intro_screen.dart';
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
          page: () => const IntroScreen(),
          binding: BindingsBuilder(
            () => {
              Get.lazyPut<GameController>(() => GameController()),
            },
          ),
        ),
      ],
    );
  }
}
