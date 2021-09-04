import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/model/chatMessages.dart';

import '../../constants.dart';
import 'chat_input_widget.dart';
import 'message.dart';

class Body extends StatefulWidget {
  final String chatID, user2id, thumbUri,name;

  const Body({Key key, this.chatID, this.user2id, this.thumbUri, this.name}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<ChatMessage> chatList = [];
  StreamSubscription _streamSubscription;

  @override
  Widget build(BuildContext context) {
    return
      Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child:
            // StreamBuilder(
            //     stream: getData(),
            //     builder: (context, snapshot) {
            //       itemCount:chatList.length;
            //       chatList.clear();
            //       if (snapshot.hasData && chatList.isEmpty) {
            //         snapshot.data.docs.forEach((element) {
            //           Map<String, dynamic> obj = element.data();
            //           users.add(User.fromJson(obj));
            //
            //           //print("loading");
            //         });
            //       }
            //       return matchedUserCarousel();
            //     }),

            ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) =>
                  Message(message: chatList[index]),
            ),
          ),
        ),
        ChatInputField(chatID: widget.chatID,user2id: widget.user2id, thumbUri: widget.thumbUri, name: widget.name, ),
      ],
    );
  }

  Stream<List<ChatMessage>> getData() async* {
    var usersChatsStream = FirebaseDatabase(
        databaseURL:
        "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
        .reference()
        .child('ChatMessages/${widget.chatID}')
        .onValue;

    List<ChatMessage> foundChats = [];

    await for (var userChatSnapshot in usersChatsStream) {
      foundChats.clear();
      ///Keep track of chatID
      Map dictionary = userChatSnapshot.snapshot.value;
      if (dictionary != null) {
        for (var dictItem in dictionary.entries) {
          ChatMessage thisChat;
          if (dictItem.key != null){
            thisChat =  ChatMessage.fromJson(dictItem.value, null,null, null, null, null, null, null);
            print(dictItem.value);


          } else {
            thisChat = ChatMessage();
          }

          foundChats.add(thisChat);
        }
      }
      yield foundChats;
    }
  }

  @override
  void initState() {

    _streamSubscription = getData().listen((data) {
      if (!mounted) return;
      setState(() {
        chatList = data;
      });
    });

  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}

