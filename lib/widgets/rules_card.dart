import 'package:flutter/material.dart';

class RulesCard extends StatelessWidget {
  final String title;
  final String content1;
  final Image? image1;
  final String? content2;
  final Image? image2;
  final Image? image3;

  const RulesCard({
    Key? key,
    required this.title,
    required this.content1,
    this.image1,
    this.content2,
    this.image2,
    this.image3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(content1),
            image1 != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(child: image1),
                  )
                : Container(),
            content2 != null ? Text(content2!) : Container(),
            image2 != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        image2!,
                        const SizedBox(width: 10),
                        image3 != null ? image3! : Container(),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
