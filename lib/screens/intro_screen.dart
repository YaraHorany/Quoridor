import 'package:flutter/material.dart';
import 'package:quoridor/screens/about.dart';
import 'package:quoridor/screens/game_screen.dart';
import 'package:quoridor/screens/game_rules.dart';
import 'package:quoridor/widgets/content.dart';
import 'package:quoridor/widgets/title.dart';
import 'package:get/get.dart';
import '../controllers/game_controller.dart';
import 'package:quoridor/utils/dimensions.dart';

class IntroScreen extends StatelessWidget {
  final GameController gameController = Get.find<GameController>();

  IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: const TitleText(title: "Quoridor", size: 0.1),
        leading: IconButton(
          icon: const Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
          tooltip: "About",
          onPressed: () {
            Get.to(() => const AboutPage());
          },
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.rule,
                color: Colors.white,
              ),
              tooltip: "Rules",
              onPressed: () {
                Get.to(() => const GameRules());
              }),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                gameController.playAgainstAI(false);
                Get.to(() => GameScreen());
              },
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'images/multiplayer.png',
                    color: Colors.white,
                    width: Dimensions.screenWidth * 0.5,
                    height: Dimensions.screenHeight * 0.3,
                  ),
                  const ContentText(
                      content: "MultiPlayer", size: 0.08, italicFont: false),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.defaultDialog(
                  title: "Choose AI level",
                  titlePadding: EdgeInsets.symmetric(
                      vertical: Dimensions.height10,
                      horizontal: Dimensions.width10),
                  content: Column(
                    children: [
                      const Text("Higher level AI takes more time."),
                      SizedBox(height: Dimensions.height10),
                      _levelButton("Novice", 1000),
                      _levelButton("Average", 2500),
                      _levelButton("Good", 7500),
                      _levelButton("Strong", 10000),
                    ],
                  ),
                );
              },
              child: Column(
                children: [
                  Icon(
                    Icons.remove_from_queue,
                    size: Dimensions.icon180,
                    color: Colors.white,
                  ),
                  const ContentText(
                      content: "SinglePlayer", size: 0.08, italicFont: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlinedButton _levelButton(String level, int numSimulations) =>
      OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        onPressed: () {
          gameController.playAgainstAI(true, simulationNum: numSimulations);
          Get.to(() => GameScreen());
        },
        child: ContentText(
          content: level,
          italicFont: false,
        ),
      );
}
