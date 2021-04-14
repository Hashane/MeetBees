import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:meet_ceylon/provider/size_confiogurations.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  OTPScreen(this.phone);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
              )),
          Positioned(
            width: SizeConfig.screenWidth,
            top: SizeConfig.screenWidth * 0.30,
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.screenWidth * 0.10),
              child: Column(
                children: [
                  Container(
                    child: Text(
                      "Verify +94-${widget.phone}",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 28),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(20.0),
                    child: PinPut(
                      fieldsCount: 6,
                      onSubmit: (String pin) async {
                       try{
                         // Create a PhoneAuthCredential with the code
                         PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationCode, smsCode: pin);
                         // Sign the user in (or link) with the credential
                         await FirebaseAuth.instance.signInWithCredential(credential);
                       }catch(e){
                          FocusScope.of(context).unfocus();
                          _showSnackBar(pin, context);
                        }
                      },
                      focusNode: _pinPutFocusNode,
                      controller: _pinPutController,
                      submittedFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      selectedFieldDecoration: _pinPutDecoration,
                      followingFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.deepPurpleAccent.withOpacity(.5),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: ElevatedButton(
                      child: Text("Continue"),
                      onPressed: () {

                      },
                      style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.deepOrange),
                          shadowColor:
                          MaterialStateProperty.all<Color>(Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

 void _showSnackBar(String pin, BuildContext context) {
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
     content: const Text('Invalid OTP'),
     duration: const Duration(seconds: 1),
     // action: SnackBarAction(
     //   label: 'ACTION',
     //   onPressed: () { },
     // ),
   ));
  }

  void _verifyOTP () async {
    await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: '+1${widget.phone}',
    verificationCompleted: (PhoneAuthCredential credential) async {
      await FirebaseAuth.instance.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      print(e.message);
    },
    codeSent: (String verificationId, int resendToken) {
      setState(() {
        _verificationCode = verificationId;
      });
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      setState(() {
        _verificationCode = verificationId;
      });
    },
      timeout: Duration(seconds: 60));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyOTP();
  }
}
