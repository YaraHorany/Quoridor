import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quoridor/screens/game_screen/game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quoridor Board Game',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const GameScreen(),
        ),
      ],
    );
  }
}
