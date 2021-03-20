import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_ceylon/model/user.dart' as lUser;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';





class Auth{
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Auth(this._auth);

  Stream<User> get user{
    return _auth.authStateChanges();
  }

  Future<User> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential result =  await _auth.signInWithCredential(credential);
      User user = result.user;

      if(result.additionalUserInfo.isNewUser)

      return user;
    }catch(e){}
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow

    //final AccessToken accessToken = await FacebookAuth.instance.login();
    final AccessToken accessToken = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
      loginBehavior:
          LoginBehavior.DIALOG_ONLY, // (only android) show an authentication dialog instead of redirecting to facebook app
    );

    // Create a credential from the access token
    final FacebookAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(accessToken.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

}