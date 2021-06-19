import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection("SL");

class Database {
  static String userUid;

  static Future<void> addItem({
    String uid,
    String name,
    String age,
    String birthday,
    String gender,
    String preferredGender,
    List<int> interests,
    String email,
    String phone,
    List<String> imageUris,
    double lat,
    double long,
    String country,
    String city,
    bool isProUser,
    bool boosted,
    int boosts,
    DateTime lastSignIn,
    DateTime signUpDate,
}) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(uid);


    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "age": age,
      "birthday" : birthday,
      "gender": gender,
      "preferred_gender": preferredGender,
      "interests": interests,
      "email": email,
      "phone": phone,
      "image_uris": imageUris,
      "geolocation": GeoPoint(lat,long),
      "country": country,
      "city": city,
      "isProUser": isProUser,
      "boosts": boosts,
      "boosted": boosted,
      "last_sign_in": lastSignIn,
      "account_created": signUpDate,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("User registered in the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateItem({
    String title,
    String description,
    String docId,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('items').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection =
    _mainCollection.doc(userUid).collection('items');

    return notesItemCollection.snapshots();
  }

  static Future<void> deleteItem({
    String docId,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}