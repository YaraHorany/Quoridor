import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green,
      backgroundColor: Colors.orangeAccent.shade100,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () => Navigator.pop(context),
          iconSize: MediaQuery.of(context).size.width * 0.12,
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          "About",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: MediaQuery.of(context).size.width * 0.08,
            fontWeight: FontWeight.bold,
            // color: Colors.tealAccent,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            color: Colors.transparent,
            margin: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
            elevation: 0.0,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  const Padding(padding: EdgeInsets.all(5.0)),
                  // Image.asset(
                  //   'images/Othello.jpg',
                  //   height: MediaQuery.of(context).size.height * 0.27,
                  // ),
                  Center(
                    child: Text(
                      "Quoridor",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.11,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "version : 3.1.0",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            width: MediaQuery.of(context).size.width,
            height: 1.0,
            color: Colors.black,
          ),
          const Card(
              color: Colors.transparent,
              elevation: 0.0,
              margin: EdgeInsets.all(10.0),
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Othello is all about occupying the position of opponent. The more you occupy is the more chances for your VICTORY.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ))),
          Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            width: MediaQuery.of(context).size.width,
            height: 1.0,
            color: Colors.black,
          ),
          Container(
            padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 5.0),
            child: Container(
              child: Card(
                color: Colors.transparent,
                elevation: 0.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Contact Us",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    // leading:  Image.asset(
                    //   'images/Developers.png',
                    //   // color: Colors.black,
                    // ),
                    Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Icon(
                              Icons.developer_mode,
                              size: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'We_developers',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7.0),
                    Row(
                      children: <Widget>[
                        const Padding(padding: EdgeInsets.only(left: 5.0)),
                        const Text("Email us at :"),
                        Text(
                          "yara.horany1@gmail.com",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
