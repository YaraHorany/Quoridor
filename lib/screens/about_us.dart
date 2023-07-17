import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quoridor/widgets/title.dart';
import 'package:quoridor/widgets/content.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () => Get.back(),
          iconSize: MediaQuery.of(context).size.width * 0.12,
        ),
        elevation: 0.0,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            color: Colors.transparent,
            // margin: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
            elevation: 0.0,
            child: Column(
              children: <Widget>[
                // const Padding(padding: EdgeInsets.all(5.0)),
                const Center(
                  child: TitleText(title: "Quoridor", size: 0.2),
                ),
                const Center(
                    child: ContentText(
                  content: "version: 3.7.0",
                  size: 0.05,
                  italicFont: false,
                )),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.asset(
                    'images/quoridor.jpg',
                    height: MediaQuery.of(context).size.height * 0.27,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            width: MediaQuery.of(context).size.width,
            height: 1.0,
            color: Colors.white,
          ),
          const Card(
            color: Colors.transparent,
            elevation: 0.0,
            margin: EdgeInsets.all(10.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: ContentText(
                  content:
                      "Quoridor is a two- or four-player intuitive strategy game"
                      "designed by Mirko Marchesi and published by Gigamic Games."
                      "Quoridor received the Mensa Mind Game award in 1997 and the Game Of"
                      "The Year in the United States, France, Canada and Belgium",
                  italicFont: true),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            width: MediaQuery.of(context).size.width,
            height: 1.0,
            color: Colors.white,
          ),
          Container(
            padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 5.0),
            child: Card(
              color: Colors.transparent,
              elevation: 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Center(
                    child: ContentText(
                        content: "Contact Us", size: 0.06, italicFont: true),
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.developer_mode,
                          size: MediaQuery.of(context).size.height * 0.03,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      const Align(
                        alignment: Alignment.center,
                        child: ContentText(
                          content: "We_developers",
                          size: 0.06,
                          italicFont: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7.0),
                  Row(
                    children: const <Widget>[
                      Padding(padding: EdgeInsets.only(left: 5.0)),
                      Text("Email us at :",
                          style: TextStyle(color: Colors.white)),
                      ContentText(
                          content: "yara.horany1@gmail.com",
                          size: 0.04,
                          italicFont: true)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
