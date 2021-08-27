import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meet_ceylon/model/chatMessages.dart';
import 'package:meet_ceylon/model/message.dart';

/// Data Access Object for messages.
///
/// * Creates a DatabaseReference which references a node called 'messages'.
///
/// * This code looks for a JSON document inside Realtime Database called 'messages'. If it doesn’t exist, Firebase will create it.
class MessageDao {
  final String currentUserId = FirebaseAuth.instance.currentUser.uid;

  final DatabaseReference _ref = FirebaseDatabase(
          databaseURL:
              "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
      .reference();

  String _chatID = "";

  ///if chatID is present, go straight to "ChatMessages" node and write the message under the same "Chat ID"
  ///
  /// * This is the scenario where user initiates a existing chat from the Inbox.
  ///
  void saveMessage(ChatMessage message) {
    _ref
        .child("ChatMessages")
        .child(message.chatID)
        .once()
        .then((DataSnapshot snapshot) {
      ///Writting messages under correct ChatID
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
    print("Pushed to Existing");
  }

  void openNewChat(ChatMessage message) {
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

    //Todo optional
    /// _ref.child("UserChats").child(message.u2ID).push().set(_chatID);

    print("done");
  }

  // /// For the retrieval method we only need to expose a Query since we’ll use a cool widget called a FirebaseAnimatedList,
  // /// which interacts directly with our DatabaseReference.
  // Query getMessageQuery() {
  //   return _messagesRef;
  // }

  // Query getUserChatList(){
  //   final List<String> _chatIDList = [];
  //
  //   var query = _ref.child("UserChats").child(currentUserId);
  //   query.onChildAdded.forEach((event) {
  //     _chatIDList.add(event.snapshot.value);
  //
  //   });
  //   ///After all child nodes have been fetched and put into list
  //   query.once().then((value) =>
  //
  //       ///looping chat ID list to see if there's a existing sub node with the chat ID
  //       _chatIDList.forEach((element) {
  //         _ref
  //             .child("Chats")
  //             .child(element)
  //             .once()
  //             .then((DataSnapshot snapshot) {
  //           ///if found, put the values to a map and convert it to a list
  //           /// in order to only read the 'last' which means 'members' value set.
  //           if (snapshot.exists) {
  //             Map data = snapshot.value;
  //             var membersValSet = data.entries.toList().last;
  //
  //             ///extracting the member at the 1st position id which belongs to the second user.
  //             //  print(membersValSet.value[1]);
  //
  //             /// if any of the member ids match with the second user's user id we proceed.
  //             if (currentUserId == membersValSet.value[0]) {
  //               ///if so get the root element to which this belongs to
  //               ///This is the ChatID we have been looking for.
  //               ///using this ChatID we can list the new messages under
  //                print(snapshot.key);
  //
  //               _chatID = snapshot.key;
  //
  //             }
  //           }
  //         });
  //       }));
  //
  // }


}
