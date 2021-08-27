import 'package:flutter/material.dart';
import 'package:meet_ceylon/model/chatMessages.dart';

import '../../constants.dart';
import 'chat_input_widget.dart';
import 'message.dart';

class Body extends StatelessWidget {
  final String chatID;
  final String user2id;

  const Body({Key key, this.chatID, this.user2id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: ListView.builder(
              itemCount: demeChatMessages.length,
              itemBuilder: (context, index) =>
                  Message(message: demeChatMessages[index]),
            ),
          ),
        ),
        ChatInputField(chatID: chatID,),
      ],
    );
  }
}