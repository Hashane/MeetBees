import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/size_confiogurations.dart';


class PhoneAuthenticate extends StatefulWidget {
  @override
  _PhoneAuthenticateState createState() => _PhoneAuthenticateState();
}

class _PhoneAuthenticateState extends State<PhoneAuthenticate> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
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
                      "My Number is",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 28),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    child: TextField(
                      decoration: InputDecoration(
                        //hintText: "Phone Number",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 28),
                        prefix: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text("+94"),
                        ),
                      ),
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      controller: _controller,
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      child: Text("Continue"),
                      onPressed: () {},
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
}
