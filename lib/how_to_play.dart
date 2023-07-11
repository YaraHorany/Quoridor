import 'package:flutter/material.dart';

class HowToPlay extends StatelessWidget {
  const HowToPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () => Navigator.pop(context),
          iconSize: MediaQuery.of(context).size.width * 0.12,
        ),
        title: Text(
          "How To Play",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.tealAccent,
            fontSize: MediaQuery.of(context).size.width * 0.08,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.lightGreen,
      body: ListView(
        children: <Widget>[
          Card(
              elevation: 10.0,
              margin: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                      text: "Description:\n",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                    text:
                        "                 Othello is all about occupying the position of opponent. The more you occupy is the more chances of your VICTORY.",
                    style: TextStyle(color: Colors.black),
                  ),
                ])),
              )),
          Card(
              elevation: 10.0,
              margin: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                      text: "Game Play:\n",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                    text:
                        "                 Othello is a strategy board game played between 2 players.\n\n"
                        "One player chooses black and the other white."
                        "Each player gets 32 discs\n "
                        "Black always starts the game.\n\n"
                        "The game alternates between white and black until:\n"
                        "     Anyone of the players cannot make a VALID MOVE. then, GAME ENDS",
                    style: TextStyle(color: Colors.black),
                  ),
                ])),
              )),
          Card(
              elevation: 10.0,
              margin: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                      text: "VALID MOVES:\n",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                    text: "Black always moves first\n"
                        "     A move is made by placing a disc of the player's color on the board in a position that \"out-flank's\" one or more of the opponent's discs.\n\n"
                        "     A disc or row of discs is out-flanked when it is surrounded at the ends by disc of the opponent color.\n\n"
                        "     A disc may \"out-flank\" any number of discs in one or more rows in any direction (horizontal, vertical, diagonal).",
                    style: TextStyle(color: Colors.black),
                  ),
                ])),
              )),
          Card(
              elevation: 10.0,
              margin: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Image.asset('images/oth1.jpg',
                        width: MediaQuery.of(context).size.width * 0.5),
                    const Padding(padding: EdgeInsets.all(5.0)),
                    Image.asset('images/oth4.jpg'),
                  ],
                ),
              )),
          Card(
              elevation: 10.0,
              margin: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                      text: "End of the Game:\n",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                    text:
                        "      When it is no longer possible for Anyone of the players to make a Valid Move, then, GAME IS OVER.\n\n"
                        "then the discs are now counted and the player with the majority of his or her color discs on the board is the winner.\n"
                        "A TIE is possible.\n",
                    style: TextStyle(color: Colors.black),
                  ),
                ])),
              )),
          SizedBox(height: MediaQuery.of(context).size.width * 0.2),
        ],
      ),
    );
  }
}
