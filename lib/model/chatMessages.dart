import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final String currentUserId = FirebaseAuth.instance.currentUser.uid;
enum ChatMessageType { text, audio, image, video }
enum MessageStatus { not_sent, not_view, viewed }

class ChatMessage {
  final String text;
  final ChatMessageType messageType;
  final MessageStatus messageStatus;
  final bool isSender;
  final DateTime date;
  ///custom fields
  final String uID; ///current user ID
  final String u2ID; ///user two ID
  final String time;
  final String chatID;
  final String thumb;
  final String name;

  ChatMessage({
    this.text = '',
    this.messageType,
    this.messageStatus,
    this.isSender,
    this.date,
    this.uID,
    this.u2ID,
    this.time,
    this.chatID,
    this.thumb,
    this.name
  });


  ///Transform the JSON you receive from the Realtime Database, into a Message
  ChatMessage.fromJson(Map<dynamic, dynamic> json, this.uID, this.u2ID, this.time, this.chatID, this.thumb, this.name, this.date)
      : text = json['message'] as String,
        messageType = ChatMessageType.text,
        messageStatus =  MessageStatus.viewed,
        isSender = json['sent_by']  == currentUserId ? true : false;

        ///Transform the JSON you receive from the Realtime Database, into a Message
  // factory ChatM.fromJson(MapEntry<dynamic, dynamic> data){
  //   return Chat(
  //     name: data.value['name'],
  //     lastMessage: data.value['LastSentMessage'],
  //     image: data.value['LastSentMessage'],
  //   );
  // }

  // factory ChatMessage.fromJson(Map<dynamic, dynamic> json) {
  //  String parser(dynamic source) {
  //     try {
  //       return source.toString();
  //     } on FormatException {
  //       return "";
  //     }
  //   }
  //
  //   return ChatMessage(
  //       chatID: parser(json['map entry']),
  //       // temp: parser(json['temp']),
  //       // humidity: parser(json['hum']),
  //       // heatIndex: parser(json['ht'])
  //      );
  // }

  ///Transform the Message into JSON, for saving.
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'date': date.toString(),
    'text': text,
  };

  ///Transform the Message into JSON, for saving.
 // final String CurrentUserId = FirebaseAuth.instance.currentUser.uid;
  Map<dynamic, dynamic> toChatsJson() => <dynamic, dynamic>{
    'lastSentMessage': text,
    "members" : [uID,u2ID],
    "thumb" : thumb,
    "name": name,
  };

  Map<dynamic, dynamic> toChatMessagesJson() => <dynamic, dynamic>{
    'message': text,
    "message_date" : date.toString(),
    "message_time": time,
    "sent_by": isSender ? uID : u2ID,
  };

}

List demeChatMessages = [
  ChatMessage(
    text: "Hi Sajol,",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
  ChatMessage(
    text: "Hello, How are you?",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: true,
  ),
  ChatMessage(
    text: "Damn",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
  ChatMessage(
    text: "asas",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: true,
  ),
  ChatMessage(
    text: "Error happend",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.not_sent,
    isSender: true,
  ),
  ChatMessage(
    text: "This looks great man!!",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
  ChatMessage(
    text: "Glad you like it",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.not_view,
    isSender: true,
  ),
];