import 'package:flutter/material.dart';
import 'package:quoridor/widgets/rules_card.dart';

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
          const RulesCard(
              title: "Object of the Game",
              content1:
                  "To be the first to reach the line opposite to one's base line."),
          RulesCard(
            title: "Game Play",
            content1:
                "Each player in turn, chooses to move his pawn or to put up one of his fences.\n"
                "When he has run out of fences, the player must move his pawn.\n"
                "At the beginning the board is empty.\n"
                "Choose and place your pawn in the center of the first line of your side of the board,"
                "your opponent takes another pawn and places it in the center of the first line of his side of the board"
                "(the one facing yours). Then take 10 fences each.",
            image1: Image.asset('images/rules/game1.png'),
            content2: "A draw will determine who starts first.",
          ),
          RulesCard(
            title: "Pawn Moves",
            content1:
                "The pawns are moved one square at a time, horizontally or vertically,"
                "forwards or backwards, never diagonally (fig.2).",
            image1: Image.asset('images/rules/game2.png'),
            content2: "The pawns must bypass the fences (fig.3)."
                "If, while you move, you face your opponent's pawn you can jump over.",
            image2: Image.asset('images/rules/game3.png'),
          ),
          RulesCard(
            title: "Positioning of the fences",
            content1:
                "The fences must be placed between 2 sets of 2 squares (fig.4).",
            image1: Image.asset('images/rules/game4.png'),
            content2:
                "By placing fences, you force your opponent to move around it"
                "and increase the number of moves they need to make."
                "But be careful, you are not allowed to lock up to lock up your opponents pawn,"
                "it must always be able to reach it's goal by at least one square (fig.5).",
            image2: Image.asset('images/rules/game5.png'),
          ),
          RulesCard(
            title: "Face To Face",
            content1:
                "When two pawns face each other on neighboring squares which are not separated"
                "by a fence, the player whose turn it is can jump the opponent's pawn "
                "(and place himself behind him), thus advancing an extra square (fig.6).",
            image1: Image.asset('images/rules/game6.png'),
            content2:
                "If there is a fence behind the said pawn, the player can place his pawn"
                "to the left or the right of the other pawn (fig.8 and 9)",
            image2: Image.asset('images/rules/game8.png'),
            image3: Image.asset('images/rules/game9.png'),
          ),
          RulesCard(
            title: "End of the Game",
            content1:
                "The first player who reaches one of the 9 squares opposite his base line is the winner (fig. 7).",
            image2: Image.asset('images/rules/game7.png'),
          ),
        ],
      ),
    );
  }
}
