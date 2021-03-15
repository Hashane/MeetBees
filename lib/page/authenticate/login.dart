import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/auth.dart';


class Login extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;


  @override
  _LoginState createState() => _LoginState();

  const Login({
    Key key,
    @required this.auth,
    @required this.firestore,
  }):super(key: key);

}



class _LoginState extends State<Login> {
@override
Widget build(BuildContext context) {
 return MaterialApp(
    home:Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Container(
        child: Column(
          children: [
            ElevatedButton(onPressed: () {  }, child: Text("Sign in with Facebook")),
            ElevatedButton(onPressed: () async {
              dynamic result = await Auth(widget.auth).signInWithGoogle();
              if(result == null){
                print("Error");
              }else{
                print(result);
              }
            }, child: Text("Sign in with Google")),
          ],
        )
      ),
    ),
  );
}
}
