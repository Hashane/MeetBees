import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meet_ceylon/model/chatMessages.dart';
import 'package:meet_ceylon/model/message.dart';
import 'package:meet_ceylon/model/chat.dart' as ChatModel;

/// Data Access Object for messages.
///
/// * Creates a DatabaseReference which references a node called 'messages'.
///
/// * This code looks for a JSON document inside Realtime Database called 'messages'. If it doesn’t exist, Firebase will create it.
class MessageDao {
  final String currentUserId = FirebaseAuth.instance.currentUser.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final DatabaseReference _ref = FirebaseDatabase(
          databaseURL:
              "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
      .reference();

  String _chatID = "";

  ///if chatID is present, go straight to "ChatMessages" node and write the message under the same "Chat ID"
  ///
  /// * This is the scenario where user initiates a existing chat from the Inbox.
  ///
  void saveMessage(ChatMessage message, String id) {
    if (message.chatID == null)
      _chatID = id;
    else
      _chatID = message.chatID;

    _ref
        .child("ChatMessages")
        .child(_chatID)
        .once()
        .then((DataSnapshot snapshot) {
      ///Writting messages under correct ChatID
      _ref
          .child("ChatMessages")
          .child(_chatID)
          .push()
          .set(message.toChatMessagesJson());

      ///Also updating the last message
      _ref.child("Chats").child(_chatID).update({
        'lastSentMessage': message.messageType == ChatMessageType.text ? message.text : "Image",
      });
    });
    print("Pushed to Existing");
  }

  // void testOld(ChatMessage message) {
  //   final List<String> _chatIDList = [];
  //
  //   ///This is when a user initiates a new chat with a new user for the first time.
  //   ///Check if userid exists in the "UserChats" node
  //   _ref
  //       .child("UserChats")
  //       .child(message.uID)
  //       .once()
  //       .then((DataSnapshot snapshot) {
  //     if (snapshot.exists) {
  //       ///this is the key of the node which is the UID
  //       //print(snapshot.key);
  //
  //       ///Snapshot values to a map
  //       Map data = snapshot.value;
  //
  //       ///count how many chat records under user id.
  //       // print(data.length);
  //
  //       if (data.length > 0) {
  //         ///loop all the entries to grab the value of each key,value pair
  //         data.entries.forEach((element) {
  //           _chatIDList.add(element.value.toString());
  //         });
  //
  //         if (_chatIDList.length > 0 && _chatIDList != null) {
  //           print(_chatIDList);
  //
  //           ///looping chat ID list to see if there's a existing sub node with the chat ID
  //           _chatIDList.forEach((element) {
  //             _ref
  //                 .child("Chats")
  //                 .child(element)
  //                 .once()
  //                 .then((DataSnapshot snapshot) {
  //               ///if found, put the values to a map and convert it to a list
  //               /// in order to only read the 'last' which means 'members' value set.
  //
  //               if (snapshot.exists) {
  //                 Map data = snapshot.value;
  //
  //                 ///extracting the member at the 1st position id which belongs to the second user.
  //                 var secondUsersId = data["members"][1];
  //                 print("this is the 2nd user" + data["members"][1]);
  //
  //                 _chatID = snapshot.key;
  //
  //                 /// if any of the member ids match with the second user's user id we proceed.
  //                 if (message.u2ID == secondUsersId && _chatID != null) {
  //                   ///if so get the root element to which this belongs to
  //                   ///This is the ChatID we have been looking for.
  //                   ///using this ChatID we can list the new messages under
  //                   // print(snapshot.key);
  //
  //                   print("user found & second users id matches....!!!");
  //                   saveMessage(message, _chatID);
  //                 } else {
  //                   print("found user but second users id doesn't match..");
  //                   openNewChat(message);
  //                 }
  //               }
  //             });
  //           });
  //         }
  //       }
  //     } else {
  //       print("cant find User. Opening new chat.....");
  //       openNewChat(message);
  //     }
  //   });
  // }


void test(ChatMessage chatMessage) async {
Map<Object, Object>_chatList;
    _chatList = await getData(chatMessage);

 if(_chatList != null){
   print(_chatList);
    List<dynamic> secondUsersId = _chatList["members"];


    /// if any of the member ids match with the second user's user id we proceed.
    if (chatMessage.u2ID == secondUsersId.elementAt(1)) {
      saveMessage(chatMessage, _chatID);
    }else{
      /// when the has not chat with this particular user, we start a new chat.
      openNewChat(chatMessage);
    }
 }

}

  Future<Map<Object, Object>> getData(ChatMessage chatMessage) async {
    var usersMainChatsSnapshot = FirebaseDatabase(databaseURL: "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/").reference().child('UserChats/$currentUserId').once();

    final List<String>_chatIDList  = [];
    Map<Object, Object> obj;

    await for (var userChatSnapshot in  usersMainChatsSnapshot.asStream()) {

      _chatIDList.clear(); ///Keep track of chatID
      Map dictionary = userChatSnapshot.value;
      if (dictionary != null) {
        for (var dictItem in dictionary.entries) {
          _chatID;
          ChatModel.Chat thisChat;
          if (dictItem.key != null) {
            _chatID = dictItem.value; ///globally saving

            obj = (await FirebaseDatabase(databaseURL: "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/").reference().child("Chats/$_chatID").once()).value;

          } else {
           obj = Map();
          }
          _chatIDList.add(_chatID); ///adding chatid to list
        }
      }else{
        ///When this particular user hasn't chat with anyone before
        openNewChat(chatMessage);
      }
      return obj;
    }
  }

  void openNewChat(ChatMessage message) async{
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
    ///

    //Todo optional Save ChatID as a Map
    Map<String, String> someMap = {
      "chatID": _chatID,
    };

    //_ref.child("UserChats").child(message.uID).push().set(someMap);
    _ref.child("UserChats").child(message.uID).push().set(_chatID);

    ///Saving the chatID under the 2nd user
    _ref.child("UserChats").child(message.u2ID).push().set(_chatID);

    ///Before we fetch current user info from the firebase we check if they are already stored in the realtime DB
    bool _exists = await selfInfoExists(FirebaseDatabase(
        databaseURL:
        "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
        .reference()
        .child("Users/$currentUserId"));


    //Todo Need to change the hardcoded Collection name
    final CollectionReference _mainCollection = _firestore.collection("SL");

    ///Fetching current user image & thumb from firestore and store under "Users" node
    if(!_exists){
      _mainCollection.doc(message.uID).get().then((value){
        ///save user info as a map
        Map<String, String> _userInfoMap = {
          "name": value.get("name"),
          "thumb": value.get("image_uris")[0],
        };
        _ref.child("Users").child(message.uID).push().set(_userInfoMap);
      });
    }

    ///Fetching second users info and store
    _mainCollection.doc(message.u2ID).get().then((value){
      ///save user info as a map
      Map<String, String> _userInfoMap = {
        "name": value.get("name"),
        "thumb": value.get("image_uris")[0],
      };
      _ref.child("Users").child(message.u2ID).push().set(_userInfoMap);
    });

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

  Future<bool> selfInfoExists(DatabaseReference databaseReference) async{
    DataSnapshot snapshot = await databaseReference.once();
    bool isExist = false;
    if( snapshot.value == null ){
      isExist = false;
    }else{
      isExist = true;
    }
    return isExist;
  }

}
