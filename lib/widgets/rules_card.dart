import 'package:flutter/material.dart';
import '../utils/dimensions.dart';

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
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius12)),
      ),
      margin: EdgeInsets.symmetric(
          vertical: Dimensions.height10, horizontal: Dimensions.width10),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.height10, horizontal: Dimensions.width10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: Dimensions.height10),
            Text(content1),
            image1 != null
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: Dimensions.height10),
                    child: Center(child: image1),
                  )
                : Container(),
            content2 != null ? Text(content2!) : Container(),
            image2 != null
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: Dimensions.height10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        image2!,
                        SizedBox(width: Dimensions.width10),
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
