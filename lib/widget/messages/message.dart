
import 'package:flutter/material.dart';
import 'package:meet_ceylon/model/chatMessages.dart';
import 'package:meet_ceylon/widget/messages/photo_message.dart';
import 'package:meet_ceylon/widget/messages/text_message.dart';

import '../../constants.dart';



class Message extends StatelessWidget {
  const Message({
    Key key,
    @required this.message,
    this.photo_message,
  }) : super(key: key);

  final ChatMessage message;
  final PhotoMessage photo_message;

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(ChatMessage message) {
      switch (message.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message);
        case ChatMessageType.image:
          return PhotoMessage(image: photo_message);
        default:
          return SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment:
        message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            CircleAvatar(
              radius: 12,
              backgroundColor: Theme.of(context).colorScheme.primaryVariant,
              backgroundImage: NetworkImage(
                  "https://i.stack.imgur.com/NiBMY.png?s=420&g=1"),
            ),
            SizedBox(width: kDefaultPadding / 2),
          ],
          messageContaint(message),
          ///Todo used to indicate the message status
          // if (message.isSender) MessageStatusDot(status: message.messageStatus)
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus status;

  const MessageStatusDot({Key key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.not_sent:
          return kErrorColor;
        case MessageStatus.not_view:
          return Theme.of(context).textTheme.bodyText1.color.withOpacity(0.1);
        case MessageStatus.viewed:
          return kPrimaryColor;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: kDefaultPadding / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}