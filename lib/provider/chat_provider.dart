import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/model/chat.dart' as ChatModel;

class ChatProvider {
  ///Realtime updates from chat
  final DatabaseReference _ref = FirebaseDatabase(
      databaseURL:
      "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
      .reference();

  /// Fetching all the chat ids under a particular userId
  /// then adding those chat ids into a list
  ///
  Stream<List<String>> getData(String currentUserId) async* {
    List<String> _foundChats = [];
    var usersChatsStream = _ref.child('UserChats/$currentUserId').onValue;

    await for (var userChatSnapshot in usersChatsStream) {
      _foundChats.clear();

      ///Keep track of chatID
      Map dictionary = userChatSnapshot.snapshot.value;
      if (dictionary != null) {
        for (var dictItem in dictionary.entries) {
          String chatID;
          if (dictItem.key != null) {
            chatID = dictItem.value;
          } else {
            chatID = "";
          }
          _foundChats.add(chatID);
        }
      }
      yield _foundChats;
    }
  }

  /// Looping the chat id list to get the Chat related information
  /// such as lastSentMessage & thumb to indicate inside each users inbox
  ///
  /// Actively listening to "Chats" node to listen to any realtime updates
  /// in order to update the chat box UI with the lastSentMessage
  ///
  Stream<List<ChatModel.Chat>> getInfo(List<String> li) async* {
    List<ChatModel.Chat> foundChats = [];

    for (var i in li) {
      ChatModel.Chat thisChat;

      _ref.child("Chats/$i").onValue.listen((event) {
        if (event.snapshot.value != null) {
          thisChat = ChatModel.Chat.fromJson(event.snapshot.value, null, null);
          foundChats.add(thisChat);
        }
      });
      yield foundChats;
    }
  }

  ///
  /// DatabaseReference points to Users node of the DB
  /// fetching second users info
  ///
  Stream<List<ChatModel.Chat>> secondUserInfo(String userID) async* {
    final _secondUser = userID;
    DatabaseReference databaseReference = _ref.child("Users/$_secondUser");

    List<ChatModel.Chat> secondUsers = [];
    ChatModel.Chat secondUser;
    secondUsers.clear();

    DataSnapshot snapshot = await databaseReference.once();
    if (snapshot.value != null) {
      /// Since name & image is stored as a map in the DB we assign the values to a map and then iterate to access the JSON object map
      Map dictionary = snapshot.value;
      if (dictionary != null) {
        ///Json object is transformed to the chat model
        secondUser = ChatModel.Chat.fromUsers(dictionary, null, null);
        secondUsers.add(secondUser);
      }
    }
    yield secondUsers;
  }
}
