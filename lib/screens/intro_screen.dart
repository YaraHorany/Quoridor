import 'package:flutter/material.dart';
import 'package:quoridor/screens/about_us.dart';
import 'package:quoridor/screens/game_screen.dart';
import 'package:quoridor/screens/game_rules.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          'Quoridor',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.info,
              color: Colors.black,
            ),
            tooltip: "About",
            onPressed: () {
              Get.to(const GameRules());
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
      body: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(const GameScreen());
              },
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'images/multiplayer.png',
                    color: Colors.brown,
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.12,
                  ),
                  Text(
                    "Multiplayer",
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                print('Single player mode');
              },
              child: Column(
                children: [
                  const Icon(
                    Icons.remove_from_queue,
                    size: 90,
                    color: Colors.brown,
                  ),
                  Text(
                    "SinglePlayer",
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
