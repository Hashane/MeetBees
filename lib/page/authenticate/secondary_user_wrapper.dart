import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/page/profile_data/personal_info.dart';
import 'package:meet_ceylon/provider/position_feedback_provider.dart';
import 'package:meet_ceylon/widget/loading_widget.dart';
import 'package:provider/provider.dart';

import '../home.dart';

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
          await _firestore.collection("users").doc(_auth.currentUser.uid).get();
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
    return FutureBuilder<bool>(
      future: checkIfDocExists(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data
              ? homeBuilder()
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
          theme: ThemeData(
            // scaffoldBackgroundColor: const Color(0x1F000000),
            bottomSheetTheme: BottomSheetThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                ),
                backgroundColor: Colors.black.withOpacity(0.5)),

            primarySwatch: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Home(),
        ),
      ),
    );
  }
}
