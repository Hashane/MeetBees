import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/page/authenticate/secondary_user_wrapper.dart';
import 'package:meet_ceylon/services/auth.dart';
import 'package:meet_ceylon/widget/loading_widget.dart';

import 'login.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth(_auth).user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          print(snapshot.data?.displayName);
          if (snapshot.data?.uid == null) {
            //not logged in
            return Login(
              auth: _auth,
              firestore: _firestore,
            );
          } else {
            return SecondaryWrapper();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return loading();
        } else {
          return loading();
        }
      },
    ); //user stream
  }
}
