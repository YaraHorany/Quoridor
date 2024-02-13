import 'package:flutter/material.dart';
import 'package:quoridor/screens/about_me.dart';
import 'package:quoridor/screens/game_screen.dart';
import 'package:quoridor/screens/game_rules.dart';
import 'package:quoridor/widgets/content.dart';
import 'package:quoridor/widgets/title.dart';
import 'package:get/get.dart';
import '../controllers/game_controller.dart';

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
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.3,
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
                  titlePadding: const EdgeInsets.all(10),
                  content: Column(
                    children: [
                      const Text("Higher level AI takes more time."),
                      const SizedBox(height: 10),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: () {
                            gameController.playAgainstAI(true,
                                simulationNum: 200);
                            Get.to(() => GameScreen());
                          },
                          child: const Text("Novice")),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: () {
                            gameController.playAgainstAI(true,
                                simulationNum: 500);
                            Get.to(() => GameScreen());
                          },
                          child: const Text("Average")),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: () {
                            gameController.playAgainstAI(true,
                                simulationNum: 1000);
                            Get.to(() => GameScreen());
                          },
                          child: const Text("Good")),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: () {
                            gameController.playAgainstAI(true,
                                simulationNum: 5000);
                            Get.to(() => GameScreen());
                          },
                          child: const Text("Strong")),
                    ],
                  ),
                );
              },
              child: Column(
                children: const [
                  Icon(
                    Icons.remove_from_queue,
                    size: 180,
                    color: Colors.white,
                  ),
                  ContentText(
                      content: "SinglePlayer", size: 0.08, italicFont: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
