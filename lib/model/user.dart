import 'package:flutter/cupertino.dart';

class User {
  final String uid;
  final String name;
  final String designation;
  final int mutualFriends;
  final int age;
  final String imgUrl;
  final List<String> photos;
  final String location;
  final String bio;
  bool isLiked;
  bool isSwipedOff;

  User({
    @required this.uid,
    this.designation,
    this.mutualFriends,
    this.name,
    this.age,
    this.imgUrl,
    this.photos,
    this.location,
    this.bio,
    this.isLiked = false,
    this.isSwipedOff = false,
  });
}
