import 'package:flutter/material.dart';
import 'package:quoridor/screens/about_us.dart';
import 'package:quoridor/screens/game_screen.dart';
import 'package:quoridor/screens/game_rules.dart';
import 'package:quoridor/widgets/content.dart';
import 'package:quoridor/widgets/title.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';

import '../controllers/game_controller.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({Key? key}) : super(key: key);
  final GameController gameController = Get.find<GameController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: const TitleText(title: "Quoridor", size: 0.1),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.info,
              color: Colors.black,
            ),
            tooltip: "About",
            onPressed: () {
              Get.to(const AboutPage());
            },
          ),
          IconButton(
              icon: const Icon(
                Icons.share,
                color: Colors.black,
              ),
              tooltip: "Share",
              onPressed: () {
                print("Sharing Game");
                Share.share('com.example.quoridor');
              }),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              gameController.singlePlayerGame(false);
              Get.to(GameScreen());
            },
            child: Column(
              children: <Widget>[
                Image.asset(
                  'images/multiplayer.png',
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.height * 0.12,
                ),
                const ContentText(
                    content: "Multiplayer", size: 0.05, italicFont: false),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              gameController.singlePlayerGame(true);
              Get.to(GameScreen());
            },
            child: Column(
              children: const [
                Icon(
                  Icons.remove_from_queue,
                  size: 90,
                  color: Colors.white,
                ),
                ContentText(
                    content: "SinglePlayer", size: 0.05, italicFont: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
