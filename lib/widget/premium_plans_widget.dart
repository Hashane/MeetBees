import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';

Widget premiumPlansContent(context) {
  SizeConfig().init(context);
  return Stack(
    alignment: Alignment.topCenter,
    // crossAxisAlignment: CrossAxisAlignment.start,
    // mainAxisSize: MainAxisSize.min,
    children: [
      Column(
        children: [
          SizedBox(height: SizeConfig.safeBlockVertical * 5),
          Center(
            child: Text(
              'Plans',
              style: GoogleFonts.lobster(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Lobster',
                  fontSize: 40,
                ),
              ),
            ),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Center(
            child: Text(
              'Likes or Dislikes as many as you want',
              style:
              TextStyle(fontSize: 12,color: Colors.white, fontStyle: FontStyle.normal),
            ),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 170,
                  decoration: new BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
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
                ),

                Container(
                  width: 120,
                  height: 170,
                  decoration: new BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
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
                  child: ClipRect(
                    child: Banner(
                      message: "Save 50%",
                      location: BannerLocation.topEnd,
                      color: Colors.red,
                      child: Container(
                        child: Center(
                          child: Text("premium"),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
          SizedBox(height: SizeConfig.safeBlockVertical * 1),
          Center(
            child: Text(
              'Recurring bill, cancel anytime',
              style:
              TextStyle(fontSize: 10, color: Colors.blueGrey, fontStyle: FontStyle.normal),
            ),
          ),
          Center(
            child: Text(
              'Terms of Services & Privacy Policy',
              style:
              TextStyle(fontSize: 12,color: Colors.white, fontStyle: FontStyle.normal),
            ),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 1),
          OutlinedButton(
            onPressed: null,
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(
                  SizeConfig.safeBlockHorizontal * 45,
                  SizeConfig.safeBlockVertical * 5)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.black45),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0))),
            ),
            child: Text(
              'Continue',
              style: GoogleFonts.lobster(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Lobster',
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}