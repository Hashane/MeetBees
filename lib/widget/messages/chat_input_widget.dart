import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_ceylon/model/chatMessages.dart';

import 'package:meet_ceylon/provider/message_dao.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';

import 'message.dart';

class ChatInputField extends StatelessWidget {
  final String chatID, user2id, thumbUri,name;

  const ChatInputField({
    Key key, this.chatID, this.user2id, this.thumbUri, this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //message text field controller to extract value
    final _messageController = TextEditingController();

    SizeConfig().init(context);

    void _sendMessage() {

      ///Extracting time from DateTime
      DateTime now = DateTime.now();
      String _formattedTime = DateFormat.Hms().format(now);

      ///current user id
      final String _currentUserId = FirebaseAuth.instance.currentUser.uid;

      //Todo this is the SEND function for existing chats. where chat id not null.

      final _messageDao = MessageDao();
      final message = ChatMessage(
          text:_messageController.text,
          date: DateTime.now(),
          messageType: ChatMessageType.text,
          messageStatus: MessageStatus.viewed,
          isSender: true,
          time: _formattedTime,
          uID: _currentUserId,
          u2ID: user2id,//"0zU1Zjf7mVY3aRbbngYMi0azXbg2", //M9IKekozV2Qgklcg41yt3cfclgT2", //"0ooqj1kSWtbEj1TvzXpaVn5so3L2",// "M9IKekozV2Qgklcg41yt3cfclgT2", ///todo for testing purpose only
          chatID: chatID,
          thumb: thumbUri,
          name: name,

      );

      if(chatID != null){
        _messageDao.saveMessage(message,null);
      }else {
        _messageDao.test(message);
      }
      _messageController.clear();
    }
    // void _sendNewMessage(){
    //   ///Extracting time from DateTime
    //   DateTime now = DateTime.now();
    //   String _formattedTime = DateFormat.Hms().format(now);
    //
    //   ///current user id
    //   final String _currentUserId = FirebaseAuth.instance.currentUser.uid;
    //
    //   final _messageDao = MessageDao();
    //   final message = ChatMessage(
    //     text:_messageController.text,
    //     date: DateTime.now(),
    //     messageType: ChatMessageType.text,
    //     messageStatus: MessageStatus.viewed,
    //     isSender: true,
    //     time: _formattedTime,
    //     uID: _currentUserId,
    //     u2ID: user2id, //"0ooqj1kSWtbEj1TvzXpaVn5so3L2",// "M9IKekozV2Qgklcg41yt3cfclgT2",
    //     chatID: null,
    //
    //   );
    //   _messageDao.openNewChat(message);
    //   _messageController.clear();
    // }

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
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
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



