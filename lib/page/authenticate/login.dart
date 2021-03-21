import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Login extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  @override
  _LoginState createState() => _LoginState();

  const Login({
    Key key,
    @required this.auth,
    @required this.firestore,
  }) : super(key: key);
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
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
                    height: 155.0,
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
                  SizedBox(height: 65.0),
                  SizedBox(
                    width: double.infinity,
                    height: 45.0,
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
                        onPressed: (){},
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
                  SizedBox(height: 35.0),
                  SizedBox(
                    width: double.infinity,
                    height: 45.0,
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
                  SizedBox(height: 35.0),
                  SizedBox(
                    width: double.infinity,
                    height: 45.0,
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
                  SizedBox(height: 35.0),
                  SizedBox(
                    width: double.infinity,
                    height: 45.0,
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
                      padding: EdgeInsets.all(40),
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
                  SizedBox(height: 55.0),
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
                      SizedBox(width: 25.0),
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
        ),
      ),
    );
  }
}
