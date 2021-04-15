import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meet_ceylon/provider/auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'dart:io' show Platform;

import 'package:meet_ceylon/widget/loading_widget.dart';
import 'phone_authenticate.dart';


class Login extends StatelessWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const Login({
    Key key,
    @required this.auth,
    @required this.firestore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      home: loginScreen(this.auth, this.firestore),
    );
  }
}


class loginScreen extends StatefulWidget {
  FirebaseAuth auth;
  FirebaseFirestore firestore;

  loginScreen(FirebaseAuth auth, FirebaseFirestore firestore){
      this.auth = auth;
      this.firestore = firestore;
  }

  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return isLoading ? loading() : Scaffold(
      backgroundColor: Colors.white,
      body:
      Container(
        decoration: new BoxDecoration(
          gradient: LinearGradient(
            stops: [0.0, 1.0],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: <Color>[
              Colors.orangeAccent,
              Colors.deepOrange,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConfig.safeBlockVertical*20, //10 for example
                child:
                Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                child: Center(
                  child: Text(
                    'Meet Ceylon',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical*10,),
              SizedBox(
                height: SizeConfig.safeBlockVertical*7, //10 for example
                width: SizeConfig.safeBlockHorizontal*100, //10 for example
                child: Container(
                  decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 25.0, // soften the shadow
                        spreadRadius: 2.0, //extend the shadow
                        offset: Offset(
                          0.0, // Move to right 10  horizontally
                          10.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    child: Text("Log in with Phone Number"),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => new PhoneAuthenticate()),
                      );
                    },
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.black54),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        shadowColor:
                        MaterialStateProperty.all<Color>(Colors.grey)),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 5,),
              SizedBox(
                height: SizeConfig.safeBlockVertical*7, //10 for example
                width: SizeConfig.safeBlockHorizontal*100, //10 for example
                child: Container(
                  decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 25.0, // soften the shadow
                        spreadRadius: 2.0, //extend the shadow
                        offset: Offset(
                          0.0, // Move to right 10  horizontally
                          10.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    child: Text("Log in with Google"),
                    onPressed: () async {
                       setState(() {
                        isLoading = true;
                      });
                      dynamic result =
                      await Auth(widget.auth).signInWithGoogle();
                      if (result == null) {
                        setState(() {
                          isLoading = false;
                        });
                        print("Error");
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        print(result);
                      }
                    },
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.black54),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        shadowColor:
                        MaterialStateProperty.all<Color>(Colors.grey)),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 5,),
              SizedBox(
                height: SizeConfig.safeBlockVertical*7, //10 for example
                width: SizeConfig.safeBlockHorizontal*100, //10 for example
                child: Container(
                  decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 25.0, // soften the shadow
                        spreadRadius: 2.0, //extend the shadow
                        offset: Offset(
                          0.0, // Move to right 10  horizontally
                          10.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    child: Text("Log in with Facebook"),
                    onPressed: () async {
                      dynamic result =
                      await Auth(widget.auth).signInWithFacebook();
                      if (result == null) {
                        print("Error");
                      } else {
                        print(result);
                      }
                    },
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.black54),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        shadowColor:
                        MaterialStateProperty.all<Color>(Colors.grey)),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 5,),
              if(Platform.isIOS) SizedBox(
                height: SizeConfig.safeBlockVertical*7, //10 for example
                width: SizeConfig.safeBlockHorizontal*100, //10 for example
                child: Container(
                  decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 25.0, // soften the shadow
                        spreadRadius: 2.0, //extend the shadow
                        offset: Offset(
                          0.0, // Move to right 10  horizontally
                          10.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    child: Text("Log in with Apple Email"),
                    onPressed: () async {
                      dynamic result =
                      await Auth(widget.auth).signInWithGoogle();
                      if (result == null) {
                        print("Error");
                      } else {
                        print(result);
                      }
                    },
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.black54),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        shadowColor:
                        MaterialStateProperty.all<Color>(Colors.grey)),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical * 4, horizontal: SizeConfig.safeBlockHorizontal * 4),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Trouble logging in?',
                        style: TextStyle(
                            color: Colors.black, fontSize: 14),
                      ),
                    ),
                  )
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Center(
                      child: Text(
                        'Terms of Service',
                        style: TextStyle(
                            color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(width: SizeConfig.safeBlockHorizontal * 2,),
                  Container(
                    child: Center(
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                            color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }
}

