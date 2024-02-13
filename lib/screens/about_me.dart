import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quoridor/widgets/title.dart';
import 'package:quoridor/widgets/content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () => Get.back(),
          iconSize: MediaQuery.of(context).size.width * 0.1,
        ),
        elevation: 0.0,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            color: Colors.transparent,
            elevation: 0.0,
            child: Column(
              children: <Widget>[
                // const Padding(padding: EdgeInsets.all(5.0)),
                const Center(child: TitleText(title: "Quoridor", size: 0.2)),
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
          const SizedBox(height: 10),
          _drawLine(context),
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
          _drawLine(context),
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
                        content: "Contact Me", size: 0.06, italicFont: true),
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.only(left: 5.0)),
                      const Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      TextButton(
                        onPressed: () async {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'yara.horany1@gmail.com',
                          );
                          if (!await launchUrl(emailLaunchUri)) {
                            throw Exception('Could not launch $emailLaunchUri');
                          }
                        },
                        child: const ContentText(
                            content: "  : yara.horany1@gmail.com",
                            size: 0.04,
                            italicFont: true),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.only(left: 5.0)),
                      const FaIcon(FontAwesomeIcons.linkedinIn,
                          color: Colors.white),
                      TextButton(
                        onPressed: () {
                          _launchUrl(
                              'https://www.linkedin.com/in/yara-horany-8a5045187/');
                        },
                        child: const ContentText(
                            content:
                                "  : linkedin.com/in/yara-horany-8a5045187",
                            size: 0.04,
                            italicFont: true),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.only(left: 5.0)),
                      const FaIcon(FontAwesomeIcons.github,
                          color: Colors.white),
                      TextButton(
                          onPressed: () {
                            _launchUrl('https://github.com/YaraHorany');
                          },
                          child: const ContentText(
                              content: " : github.com/YaraHorany",
                              size: 0.04,
                              italicFont: true)),
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

  Widget _drawLine(BuildContext context) => Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        width: MediaQuery.of(context).size.width,
        height: 1.0,
        color: Colors.white,
      );

  void _launchUrl(String strUrl) async {
    final Uri url = Uri.parse(strUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
