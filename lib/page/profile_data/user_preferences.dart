import 'package:flutter/material.dart';
import 'package:meet_ceylon/page/home.dart';
import 'package:meet_ceylon/provider/position_feedback_provider.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class UserPreferences extends StatefulWidget {
  @override
  _UserPreferencesState createState() => _UserPreferencesState();
}

class _UserPreferencesState extends State<UserPreferences> {
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
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
          padding: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 50),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 20.0, //10 for example
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  child: Center(
                    child: Text(
                      'Fill your personal information',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 5,
                ),
                Container(
                  child: Center(
                    child: Text(
                      'Add atleast 3 photos to continue. You can change these later.',
                      style: TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Colors.black,
                          fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 5,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.all(5),
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        crossAxisCount: 3,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.5),
                        children: [
                          GestureDetector(
                            onTap: () {
                              print("clicked me");
                            },
                            child: SizedBox(
                              // width: SizeConfig.safeBlockHorizontal * 30,
                              height: SizeConfig.safeBlockVertical * 20,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  //side: BorderSide(width: 5, color: Colors.green)
                                ),
                                child: ListTile(),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if(_value) _value = false;
                                else _value = true;
                              });
                            },
                            child: SizedBox(
                              //width: SizeConfig.safeBlockHorizontal * 30,
                              height: SizeConfig.safeBlockVertical * 20,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  //side: BorderSide(width: 5, color: Colors.green)
                                ),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                          image: DecorationImage(
                                            image: new AssetImage(
                                                'assets/images/sports.jpg'),
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(0.5),
                                                BlendMode.softLight),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment(0.9, -0.9),
                                      child: _value ?   Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                            Icons.check,
                                            size: 10.0,
                                            color: Colors.black,
                                          ) ,
                                        ),
                                      ) : SizedBox.shrink(),
                                    ),
                                    Align(
                                      alignment: Alignment(-0.9, 0.9),
                                      child: Text(
                                        'Sports',
                                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white70),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _value = true;
                              });
                            },
                            child: SizedBox(
                              //width: SizeConfig.safeBlockHorizontal * 30,
                              height: SizeConfig.safeBlockVertical * 20,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  //side: BorderSide(width: 5, color: Colors.green)
                                ),
                                child: ListTile(),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print("clicked me");
                            },
                            child: SizedBox(
                              // width: SizeConfig.safeBlockHorizontal * 30,
                              height: SizeConfig.safeBlockVertical * 20,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  //side: BorderSide(width: 5, color: Colors.green)
                                ),
                                child: ListTile(),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print("clicked me");
                            },
                            child: SizedBox(
                              //width: SizeConfig.safeBlockHorizontal * 30,
                              height: SizeConfig.safeBlockVertical * 20,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  //side: BorderSide(width: 5, color: Colors.green)
                                ),
                                child: ListTile(),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print("clicked me");
                            },
                            child: SizedBox(
                              //width: SizeConfig.safeBlockHorizontal * 30,
                              height: SizeConfig.safeBlockVertical * 20,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  //side: BorderSide(width: 5, color: Colors.green)
                                ),
                                child: ListTile(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 5,
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: SizedBox(
                      height: SizeConfig.safeBlockVertical * 7, //10 for example
                      width:
                          SizeConfig.safeBlockHorizontal * 100, //10 for example
                      child: Container(
                        decoration: new BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 25.0, // soften the shadow
                              spreadRadius: 2.0, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                10.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          child: Text("Continue"),
                          onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              //returning builder for Home()
                              return Builder(
                                builder: (BuildContext context) =>
                                    ChangeNotifierProvider(
                                  create: (context) =>
                                      FeedbackPositionProvider(),
                                  child: MaterialApp(
                                    title: 'Tinder Swiping',
                                    theme: ThemeData(
                                      // scaffoldBackgroundColor: const Color(0x1F000000),
                                      bottomSheetTheme: BottomSheetThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight:
                                                    Radius.circular(20.0)),
                                          ),
                                          backgroundColor:
                                              Colors.black.withOpacity(0.5)),

                                      primarySwatch: Colors.deepOrange,
                                      visualDensity:
                                          VisualDensity.adaptivePlatformDensity,
                                    ),
                                    home: Home(),
                                  ),
                                ),
                              );
                            }));
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(color: Colors.red))),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black54),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.grey)),
                        ),
                      ),
                    ),
                  ),
                ),
                // Expanded(child: Container(),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
