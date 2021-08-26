import 'package:firebase_database/firebase_database.dart';
import 'package:meet_ceylon/model/chatMessages.dart';
import 'package:meet_ceylon/model/message.dart';

/// Data Access Object for messages.
///
/// * Creates a DatabaseReference which references a node called 'messages'.
///
/// * This code looks for a JSON document inside Realtime Database called 'messages'. If it doesn’t exist, Firebase will create it.
class MessageDao {
  final DatabaseReference _messagesRef =
  FirebaseDatabase(databaseURL: "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/").reference().child('messages');

  /// Performs saving
  void saveMessage(ChatMessage message) {
    //_messagesRef.onDisconnect();
    // FirebaseDatabase(databaseURL: "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/").reference().child('messages').once().then((DataSnapshot snapshot) {
    //   print('Connected to second database and read ${snapshot.value}');
    // });
    _messagesRef.push().set(message.toJson());
  }

  /// For the retrieval method we only need to expose a Query since we’ll use a cool widget called a FirebaseAnimatedList,
  /// which interacts directly with our DatabaseReference.
  Query getMessageQuery() {
    return _messagesRef;
  }
}