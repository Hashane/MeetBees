import 'package:flutter/material.dart';
import 'package:meet_ceylon/model/chatMessages.dart';

import 'package:meet_ceylon/provider/message_dao.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';

import 'message.dart';

class ChatInputField extends StatelessWidget {

  const ChatInputField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //message text field controller to extract value
    final _messageController = TextEditingController();

    SizeConfig().init(context);

    void _sendMessage() {


      final _messageDao = MessageDao();
      final message = ChatMessage(text: _messageController.text,date: DateTime.now());
      _messageDao.saveMessage(message);
      _messageController.clear();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10 / 2,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.safeBlockHorizontal * 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                  gradient: LinearGradient(
                    stops: [0.0, 1.0],
                    begin: FractionalOffset.centerLeft,
                    end: FractionalOffset.centerRight,
                    colors: <Color>[
                      Colors.orangeAccent,
                      Colors.red,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color
                          .withOpacity(0.64),
                    ),
                    SizedBox(width: SizeConfig.safeBlockHorizontal * 1),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Type message",
                          hintStyle: Theme.of(context).textTheme.bodyText2,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: SizeConfig.safeBlockHorizontal * 1),
                    IconButton(
                      onPressed: () {_sendMessage();},
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .color
                            .withOpacity(0.64),
                      ),
                    ),
                    SizedBox(width: SizeConfig.safeBlockHorizontal * 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



