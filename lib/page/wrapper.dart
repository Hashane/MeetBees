import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/auth.dart';
import 'package:meet_ceylon/page/home.dart';
import 'package:meet_ceylon/provider/position_feedback_provider.dart';
import 'package:meet_ceylon/widget/loading_widget.dart';
import 'package:provider/provider.dart';

import 'authenticate/login.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: Auth(_auth).user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.data?.uid == null){
              //not logged in
              return Login(auth: _auth,firestore: _firestore,);
            }else{
             return Builder(
                builder: (BuildContext context)=> ChangeNotifierProvider(
                create: (context) => FeedbackPositionProvider(),
                 child: MaterialApp(
                   title: 'Tinder Swiping',
                   theme: ThemeData(
                     primarySwatch: Colors.deepOrange,
                     visualDensity: VisualDensity.adaptivePlatformDensity,
                   ),
                   home: Home(),
               ),),
             );
            }
        }else{
          return LoadingWidget();
        }
      },); //user stream

  }
}
