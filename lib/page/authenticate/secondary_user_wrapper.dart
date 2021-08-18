import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/page/main/main_screen.dart';
import 'package:meet_ceylon/page/profile_data/personal_info.dart';
import 'package:meet_ceylon/provider/position_feedback_provider.dart';
import 'package:meet_ceylon/widget/loading_widget.dart';
import 'package:provider/provider.dart';

import '../custom_theme.dart';
import '../main/home.dart';

class SecondaryWrapper extends StatefulWidget {
  @override
  _SecondaryWrapperState createState() => _SecondaryWrapperState();
}

class _SecondaryWrapperState extends State<SecondaryWrapper> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _doExists = false;

  /// Checks If document with current user's uid as the reference exsits in the "users" collection
  ///
  /// * Returns a Future of a boolean value
  Future<bool> checkIfDocExists() async {
    try {
      // Get reference to Firestore collection
      DocumentSnapshot ds =
          await _firestore.collection("SL").doc(_auth.currentUser.uid).get();
      if (ds.exists == false) {
        ds =
            await _firestore.collection("AUS").doc(_auth.currentUser.uid).get();
      }
      return ds.exists;
    } catch (e) {
      throw e;
    }
  }

  ///Displays proper screen depending on the future value
  ///
  ///* Transforms Future (of boolean value) into a String asynchronously during the build process using FutureBuilder
  ///
  @override
  Widget build(BuildContext context) {
    MyAppTheme _myAppTheme = new MyAppTheme(isDark: false);
    return FutureBuilder<bool>(
      future: checkIfDocExists(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data
              ? ChangeNotifierProvider(  //passing the provider
                  create: (context) => FeedbackPositionProvider(),
                  child: MaterialApp(
                      title: 'Meet Ceylon',
                      theme: _myAppTheme.themeData,
                      home: MainScreen()))
              : MaterialApp(home: PersonalInfo());
        } else {
          return loading();
        }
      },
    );
  }

  ///initializing the async method in the initState() function
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfDocExists();
  }

  ///Building the home widget
  Widget homeBuilder() {
    return Builder(
      builder: (BuildContext context) => ChangeNotifierProvider(
        create: (context) => FeedbackPositionProvider(),
        child: MaterialApp(
          title: 'Meet Ceylon',
          home: Home(),
        ),
      ),
    );
  }
}
