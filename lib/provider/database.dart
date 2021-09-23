import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fUser;
import 'package:meet_ceylon/model/user.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection("SL");


class Database {
  static Future<void> addItem({
    String uid,
    String name,
    int age,
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
    DocumentReference documentReferencer = _mainCollection.doc(uid);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "age": age,
      "birthday": birthday,
      "gender": gender,
      "preferred_gender": preferredGender,
      "interests": interests,
      "email": email,
      "phone": phone,
      "image_uris": imageUris,
      "geolocation": GeoPoint(lat, long),
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
        _mainCollection.doc(fUser.FirebaseAuth.instance.currentUser.uid).collection('items').doc(docId);

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
    CollectionReference usersCollection = _mainCollection;

    return usersCollection.snapshots();
  }

  static Stream<QuerySnapshot> fetchUsers() {
    CollectionReference usersCollection = _mainCollection;
    final Query filtered = usersCollection.where("isProUser", isEqualTo: true);
    return filtered.snapshots();
    // return usersCollection.snapshots();
  }

  static Future<void> deleteItem({
    String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(fUser.FirebaseAuth.instance.currentUser.uid).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }

  static Future<User> getUserInfo() async {
    // print(fUser.FirebaseAuth.instance.currentUser.uid);
    DocumentReference documentReferencer = _mainCollection.doc(fUser.FirebaseAuth.instance.currentUser.uid);
    User _user;
    await documentReferencer.get().then((document) {
      _user = User.fromJson(document.data());
    }).catchError((e) => print(e));
    return _user;
  }
}
