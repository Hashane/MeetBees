import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/model/chatMessages.dart';

import '../../constants.dart';
import 'chat_input_widget.dart';
import 'message.dart';
import 'package:meet_ceylon/model/chat.dart' as ChatModel;

class Body extends StatefulWidget {
  final String chatID, user2id, thumbUri, name;

  const Body({Key key, this.chatID, this.user2id, this.thumbUri, this.name})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<ChatMessage> chatList = [];
  StreamSubscription _streamSubscription;
  StreamSubscription _streamSubscriptionChatIds;

  ///To track all the chats the user has started
  List<String> _chatIDList = [];
  String _chatID = "";

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  Message(message: chatList[index],thumb: widget.thumbUri),
            ),
          ),
        ),
        ChatInputField(
          chatID: widget.chatID,
          user2id: widget.user2id,
          thumbUri: widget.thumbUri,
          name: widget.name,
        ),
      ],
    );
  }


  ///
  Stream<List<ChatMessage>> getData(String id) async* {
    var usersChatsStream;
    if (id != null) {
      usersChatsStream = FirebaseDatabase(
              databaseURL:
                  "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
          .reference()
          .child('ChatMessages/${id}')
          .onValue;
    } else {
      usersChatsStream = FirebaseDatabase(
              databaseURL:
                  "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
          .reference()
          .child('ChatMessages/${widget.chatID}')
          .onValue;
    }
    List<ChatMessage> foundChats = [];

    await for (var userChatSnapshot in usersChatsStream) {
      foundChats.clear();

      ///Keep track of chatID
      Map dictionary = userChatSnapshot.snapshot.value;
      if (dictionary != null) {
        for (var dictItem in dictionary.entries) {
          ChatMessage thisChat;
          if (dictItem.key != null) {
            thisChat = ChatMessage.fromJson(
                dictItem.value, null, null, null, null, null, null, null);

            //print(dictItem.value);
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

    ///
    /// calling getChats() where we listen to live updates from "UserChats" node
    /// When a new chat is initiated we grab the chat information to see whether there's a chat recently initiated and stored in the DB with the same chatID
    /// We do that by comparing "user2id" with the members list inside "Chats" information.
    ///
    ///
    if (widget.chatID == null) {
      getChats().listen((event) {
        Map<Object, Object> _chatList = event;
        List<dynamic> secondUsersId;


        ///used to store the key of the map which is the chatID
        /// Sample _chatList -  {-MkgaxXt3YhHjjBySZfz: {thumb: https://...., name: emm, members: [DiWSdg2GxPd42wuCkGwLitkgJ4o1, IocqLejxlVc0PNO8uwaHIXpUt5R2], lastSentMessage: as},{...}}

        String _chatIDfromKey = "";

        if (_chatList != null && _chatList.length > 0) {
          _chatList.forEach((key, value) {
            _chatIDfromKey = key;
            //print("FKns KEY" + key.toString());   ///this is the chatID
            Map<Object, Object> values = value;
            values.forEach((key, value) {
              //print(value);
              if (key == "members") secondUsersId = value;
            });
          });
          //List<dynamic> secondUsersId = _chatList["members"];
          /// if any of the member ids match with the second user's user id we proceed.
          if (secondUsersId.length > 0 && secondUsersId != null) {
            if (widget.user2id == secondUsersId.elementAt(1)) {
              //saveMessage(chatMessage, _chatID);

              _streamSubscription = getData(_chatIDfromKey).listen((data) {
                if (!mounted) return;
                setState(() {
                  chatList = data;
                });
              });

             // print("This is the fucken id" + _chatIDfromKey);
            }
          }
        }
      });
    } else {
      _streamSubscription = getData(null).listen((data) {
        if (!mounted) return;
        setState(() {
          chatList = data;
        });
      });
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _streamSubscriptionChatIds?.cancel();
    super.dispose();
  }

  ///
  /// When the user initiates a chat for the first time
  /// the ChatID passed through constructor will be null
  /// Therefore none of the messages being sent or being received will not be updated in the chat ui
  ///
  ///

  ///
  /// Fetching all chats(chat ids) belongs to the current user
  /// then adding those chat ids into a list
  ///
  /// Using each chatID we query the "Chats" node where information such as  "members" is stored.
  /// Those members will be yielded
  ///
  Stream<Map<Object, Object>> getChats() async* {
    var usersChatsStream = FirebaseDatabase(
            databaseURL:
                "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
        .reference()
        .child('UserChats/$currentUserId')
        .onValue;

    List<ChatModel.Chat> foundChats = [];

    ///used to grab chat information for each chat
    Map<Object, Object> obj;

    await for (var userChatSnapshot in usersChatsStream) {
      foundChats.clear();
      _chatIDList.clear();

      ///Keep track of chatID
      Map dictionary = userChatSnapshot.snapshot.value;
      if (dictionary != null) {
        for (var dictItem in dictionary.entries) {
          String chatID;
          if (dictItem.key != null) {
            chatID = dictItem.value;
            obj = (await FirebaseDatabase(
                        databaseURL:
                            "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
                    .reference()
                    .child("Chats/$_chatID")
                    .once())
                .value;
          } else {
            chatID = "";
          }
          _chatIDList.add(chatID);
        }
      }
      // print(_chatIDList);
      yield obj;
    }
  }
}
