
import 'package:flutter/material.dart';
import 'package:meet_ceylon/model/chatMessages.dart';

import '../../constants.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key key,
    this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: MediaQuery.of(context).platformBrightness == Brightness.dark
      //     ? Colors.white
      //     : Colors.black,
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding / 1,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryVariant.withOpacity(message.isSender ? 1 : 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message.text,
        style: TextStyle(
          color: message.isSender
              ? Colors.white
              : Theme.of(context).textTheme.bodyText1.color,
        ),
      ),
    );
  }
}