import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  final String uid;
  final String name;
  final int age;
  final String birthday;
  final String gender;
  final String preferred_gender;
  final List<int> interests;
  final String email;
  final String phone;
  final List<String> imageUris;
  final GeoPoint geolocation;
  final String country;
  final String city;
  bool isProUser;
  bool boosted;
  final int boosts;
  final Timestamp lastSignIn;
  final Timestamp signUpDate;
  bool isLiked;
  bool isSwipedOff;


  User({
    @required this.uid,
    this.name,
    this.age,
    this.birthday,
    this.gender,
    this.preferred_gender,
    this.interests,
    this.email,
    this.phone,
    this.imageUris,
    this.geolocation,
    this.country,
    this.city,
    this.boosts,
    this.lastSignIn,
    this.signUpDate,
    isLiked = false,
    isSwipedOf = false,
  });

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        uid = json['uid'],
        age = json['age'],
        birthday = json['birthday'],
        gender = json['gender'],
        preferred_gender = json['preferred_gender'],
        email = json['email'],
        phone = json['phone'],
        imageUris = json['image_uris'].cast<String>(),
        interests = json['interests'].cast<int>(),
        isProUser = json['isProUser'],
        geolocation = json['geolocation'],
        country = json['country '],
        city = json['city'],
        boosts = json['boosts'],
        boosted = json['boosted'],
        lastSignIn = json['last_sign_in'],
        signUpDate = json['account_created'];


}
