import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quoridor/widgets/title.dart';
import 'package:quoridor/widgets/content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/dimensions.dart';

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
                SizedBox(height: Dimensions.height10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.border30),
                  child: Image.asset(
                    'images/quoridor.jpg',
                    height: MediaQuery.of(context).size.height * 0.27,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.height10),
          _drawLine(context),
          Card(
            color: Colors.transparent,
            elevation: 0.0,
            margin: EdgeInsets.symmetric(
                vertical: Dimensions.height10, horizontal: Dimensions.width10),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height10,
                  horizontal: Dimensions.width10),
              child: const ContentText(
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
            padding: EdgeInsets.only(
                left: Dimensions.width5,
                right: Dimensions.width5,
                top: Dimensions.height5),
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
                  SizedBox(height: Dimensions.height5),
                  Row(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: Dimensions.width5)),
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
                      Padding(
                          padding: EdgeInsets.only(left: Dimensions.width5)),
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
                      Padding(
                          padding: EdgeInsets.only(left: Dimensions.width5)),
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
        margin: EdgeInsets.only(
            left: Dimensions.width10, right: Dimensions.width10),
        width: Dimensions.screenWidth,
        height: Dimensions.height5 / 5,
        color: Colors.white,
      );

  void _launchUrl(String strUrl) async {
    final Uri url = Uri.parse(strUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
