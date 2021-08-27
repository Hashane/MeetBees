import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:meet_ceylon/model/chatMessages.dart';
import 'package:meet_ceylon/model/message.dart';

/// Data Access Object for messages.
///
/// * Creates a DatabaseReference which references a node called 'messages'.
///
/// * This code looks for a JSON document inside Realtime Database called 'messages'. If it doesn’t exist, Firebase will create it.
class MessageDao {
//  final String currentUserId = FirebaseAuth.instance.currentUser.uid;

  final DatabaseReference _ref = FirebaseDatabase(
          databaseURL:
              "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
      .reference();

  final DatabaseReference _messagesRef = FirebaseDatabase(
          databaseURL:
              "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
      .reference()
      .child('messages');

  String _chatID = "";

  // final DatabaseReference _chatsRef = FirebaseDatabase(
  //         databaseURL:
  //             "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
  //     .reference()
  //     .child('Chats');
  //
  //
  // final DatabaseReference _chatMessagesRef = FirebaseDatabase(
  //     databaseURL:
  //     "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
  //     .reference()
  //     .child('ChatMessages');

  /// Performs saving
  void saveMessage(ChatMessage message) {

    final List<String> _chatIDList = [];
    final List<String> _userList = [];

    ///if chatID is present, go straight to "ChatMessages" node and write the message under the same "Chat ID"
    ///
    /// * This is the scenario where user initiates a existing chat from the Inbox.
    if (message.chatID != null) {
      _ref
          .child("ChatMessages")
          .child(message.chatID)
          .once()
          .then((DataSnapshot snapshot) {
        ///Writing messages under correct ChatID
        _ref
            .child("ChatMessages")
            .child(message.chatID)
            .push()
            .set(message.toChatMessagesJson());

        ///Also updating the last message
        _ref.child("Chats").child(message.chatID).update({
          'lastSentMessage': message.text,
        });
      });
      print("caught me offguard");

    } else {

      ///This is when a user initiates a new chat with a new user for the first time.
      ///Check if userid exists in the "UserChats" node
      _ref
          .child("UserChats")
          .child(message.uID)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.exists) {
          ///this is the key of the node which is the UID
          // print(snapshot.key);

          ///Snapshot values to a map
          Map data = snapshot.value;

          ///count how many chat records under user id.
          // print(data.length);

          if (data.length > 0) {
            ///loop all the entries to grab the value of each key,value pair
            data.entries.forEach((element) {
              _chatIDList.add(element.value.toString());

              //print(element.value.toString());
            });

            if (_chatIDList.isNotEmpty) {
              ///looping chat ID list to see if there's a existing sub node with the chat ID
              _chatIDList.forEach((element) {
                _ref
                    .child("Chats")
                    .child(element)
                    .once()
                    .then((DataSnapshot snapshot) {
                  ///if found, put the values to a map and convert it to a list
                  /// in order to only read the 'last' which means 'members' value set.
                  if (snapshot.exists) {
                    Map data = snapshot.value;
                    var membersValSet = data.entries.toList().last;

                    ///extracting the member at the 1st position id which belongs to the second user.
                    //  print(membersValSet.value[1]);

                    /// if any of the member ids match with the second user's user id we proceed.
                    if (message.u2ID == membersValSet.value[1]) {
                      ///if so get the root element to which this belongs to
                      ///This is the ChatID we have been looking for.
                      ///using this ChatID we can list the new messages under
                      // print(snapshot.key);

                      _chatID = snapshot.key;
                      pushToexisting(_chatID, message);
                    }
                  }
                });
              });
            }
          }
        } else {
          ///Read the chatID before pushing
          _chatID = _ref.child("Chats").push().key;

          ///Create a child with ChatID in the "Chats" node
          _ref.child("Chats").child(_chatID).set(message.toChatsJson());

          ///Using the same ChatID
          _ref
              .child("ChatMessages")
              .child(_chatID.toString())
              .push()
              .set(message.toChatMessagesJson());

          ///User chats
          _ref.child("UserChats").child(message.uID).push().set(_chatID);

          print("done");
        }
      });
    }
  }

  /**
    ///Check if userid exists in the "UserChats" node
    _ref.child("UserChats").child(message.uID).once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        ///this is the key of the node which is the UID
        print(snapshot.key);

        ///Snapshot values to a map
        Map data = snapshot.value;

        ///count how many chat records under user id.
        print(data.length);

        if (data.length > 0) {
          ///loop all the entries to grab the value of each key,value pair
          data.entries.forEach((element) {
            _chatIDList.add(element.value.toString());

            print(element.value.toString());
          });

          if (_chatIDList.isNotEmpty) {
            _chatIDList.forEach((element) {
              _ref
                  .child("Chats")
                  .child(element)
                  .once()
                  .then((DataSnapshot snapshot) {
                if (snapshot.exists) {
                  print("yo");
                }
              });
            });
          }
        }
      } else {
        ///If not that means this user hasn't chat with anyone before.
        ///If so go to Chats and create a chat first and lastly list the user id under the "User Chats" node.

        ///Read the chatID before pushing
        _chatID = _ref.child("Chats").push().key;

        ///Create a child with ChatID in the "Chats" node
        _ref.child("Chats").child(_chatID).set(message.toChatsJson());

        ///Using the same ChatID
        _ref.child("ChatMessages").child(_chatID.toString()).push().set(message.toChatMessagesJson());

        ///User chats
        _ref.child("UserChats").child(message.uID).push().set(_chatID);

        print("done");
      }
    });

    **/

  //every user must have an email
  // _ref.child("Chats").child('-Mi2SzB7zppzrjIZHmtp').once().then((DataSnapshot snapshot) {
  //   if (snapshot.exists){
  //     print(snapshot.value['members'][1]);
  //
  //   }
  // });

  ///Creates the chat id by pushing initial data to "Chats" node
  //var chatID =  _ref.child("Chats").push().set(message.toChatsJson());

  ///Read the chatID before pushing
  //String _chatID = _ref.child("Chats").push().key;

  ///Create a child with ChatID
  //  _ref.child("Chats").child(_chatID).set(message.toChatsJson());
  // _ref.child("Chats").child("-Mi2TSyWonsa9spjvmYp")..update({
  //   'lastsentMessage': 'aaaaaas'
  // });

  ///Using the same ChatID
  //_ref.child("ChatMessages").child(_chatID.toString()).push().set(message.toChatMessagesJson());

  //  _ref.child("UserChats").child(message.uID).push().set(_chatID);

  ///ChatMessages node
  //  _chatMessagesRef.child(chatID.toString()).push().set(message.toJson());

  //_messagesRef.onDisconnect();
  // FirebaseDatabase(databaseURL: "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/").reference().child('messages').once().then((DataSnapshot snapshot) {
  //   print('Connected to second database and read ${snapshot.value}');
  // });
  //_ref.child("Messages").push().set(message.toJson());

  /// For the retrieval method we only need to expose a Query since we’ll use a cool widget called a FirebaseAnimatedList,
  /// which interacts directly with our DatabaseReference.
  Query getMessageQuery() {
    return _messagesRef;
  }

  void pushToexisting(String chatid, ChatMessage message) {
    _ref
        .child("ChatMessages")
        .child(chatid)
        .once()
        .then((DataSnapshot snapshot) {
      ///Writting messages under correct ChatID
      _ref
          .child("ChatMessages")
          .child(chatid)
          .push()
          .set(message.toChatMessagesJson());

      ///Also updating the last message
      _ref.child("Chats").child(chatid).update({
        'lastSentMessage': message.text,
      });
    });
    print("caught me offguard yo");
  }
}
