import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

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
            onPressed: () {},
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
        child: const Icon(Icons.remove_from_queue),
      ),
    );
  }
}
