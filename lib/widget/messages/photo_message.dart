import 'package:flutter/material.dart';

import '../../constants.dart';

class PhotoMessage extends StatelessWidget {
  const PhotoMessage ({
    Key key,
    this.image,
  }) : super(key: key);

  final PhotoMessage image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network("https://i.stack.imgur.com/NiBMY.png?s=420&g=1"),
            ),
          ],
        ),
      ),
    );
  }
}