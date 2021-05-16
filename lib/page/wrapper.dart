import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/page/profile_data/personal_info.dart';
import 'package:meet_ceylon/provider/auth.dart';
import 'package:meet_ceylon/page/home.dart';
import 'package:meet_ceylon/provider/position_feedback_provider.dart';
import 'package:meet_ceylon/widget/loading_widget.dart';
import 'package:provider/provider.dart';

import 'authenticate/login.dart';
import 'authenticate/phone_authenticate.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isFirstTime = false;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: Auth(_auth).user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if(snapshot.connectionState == ConnectionState.active){
            print(snapshot.data?.displayName);

            //Check if the user authenticated for the first time.
            _firestore.collection('users').doc(snapshot.data?.uid)
                .get().then((DocumentSnapshot ds){
                  if(ds.exists){
                    isFirstTime = ds.data()["isFirstTime"];
                    print(isFirstTime);
                  }
            });

            if(snapshot.data?.uid == null){
              //not logged in
              return Login(auth: _auth,firestore: _firestore,);
              return MaterialApp(home: PersonalInfo());
            }
            else {
                if (isFirstTime == true) { return MaterialApp(home: PersonalInfo());}
                else {
                return Builder(
                  builder: (BuildContext context) =>
                      ChangeNotifierProvider(
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
                            visualDensity: VisualDensity
                                .adaptivePlatformDensity,
                          ),
                          home: Home(),
                        ),),
                );
              }
            }
        }else if(snapshot.connectionState == ConnectionState.waiting){ return loading();}
        else{
          return loading();
        }
      },); //user stream

  }
}
