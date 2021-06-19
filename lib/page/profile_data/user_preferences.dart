import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/data/preferences.dart';
import 'package:meet_ceylon/page/home.dart';
import 'package:meet_ceylon/provider/database.dart';
import 'package:meet_ceylon/provider/position_feedback_provider.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:meet_ceylon/model/preference.dart';

class UserPreferences extends StatefulWidget {
  // Declare a field that holds photoList user selected
  final List<String> photoList;
  final Map<String, String> userInfoMap;
  final Map<String, String> latLong;

  @override
  _UserPreferencesState createState() => _UserPreferencesState();

  UserPreferences(
      {Key key,
      @required this.photoList,
      @required this.userInfoMap,
      @required this.latLong})
      : super(key: key);
}

class _UserPreferencesState extends State<UserPreferences> {
  FirebaseFirestore firebaseFirestore;

  //carousel
  int _currentIndex = 0;

  //map function is used by the carousel
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  //choices updater
  int choicesCount;

  //used to store user selections in a common list
  List<int> choices = [];

  //removing the items from the choices list decrementing the count by 1
  _removeChoice(int id) {
    setState(() {
      choices.remove(id);
      choicesCount -= 1;
    });
  }

  //adding items to choices list, counting the length of the list and updating the state
  _updateChoices(int id) {
    setState(() {
      choices.add(id);
      choicesCount = choices.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Card list of Preference screens
    List cardList = [
      ///passing methods(_updateChoices, _removeChoice) as callbacks from Parent Widget(UserPreferences) to each Child Widget.
      ///these callback methods will be used to update the parentwidget from bottom to top (child to parent).
      ///Any updates to the choices lists will be sent back to the parent from each child widget.
      preferenceBox(
          parentAction: _updateChoices,
          parentActionRemove: _removeChoice,
          count: choicesCount),
      preferencesSecondPage(
          parentAction: _updateChoices,
          parentActionRemove: _removeChoice,
          count: choicesCount),
      preferencesThirdPage(
          parentAction: _updateChoices,
          parentActionRemove: _removeChoice,
          count: choicesCount),
      preferencesFourthPage(
          parentAction: _updateChoices,
          parentActionRemove: _removeChoice,
          count: choicesCount),
      preferencesFifthPage(
          parentAction: _updateChoices,
          parentActionRemove: _removeChoice,
          count: choicesCount),
    ];

    //for determining screen sizes
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
                      "Let us know about your passions",
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
                      'Let others know a little bit about you',
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
                CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 1.0,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    // autoPlay: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: cardList.map((card) {
                    return Builder(builder: (BuildContext context) {
                      return card;
                    });
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: map<Widget>(cardList, (index, url) {
                    return Container(
                      width: 10.0,
                      height: 10.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? Colors.blueAccent
                            : Colors.grey,
                      ),
                    );
                  }),
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

                            //user info
                            DateTime dateTimeCreatedAt = DateTime.parse(widget.userInfoMap['birthday']);
                            DateTime dateTimeNow = DateTime.now();
                            final age = (dateTimeNow.difference(dateTimeCreatedAt).inDays/365).floor().toString();

                            //position related data
                            final country = widget.latLong['country'].trim().toLowerCase();
                            final city = widget.latLong['city'].trim().toLowerCase();
                            final latitude =  double.parse(widget.latLong['lat']);
                            final longtitude =  double.parse(widget.latLong['long']);

                            print('$country');

                            //get current user
                            var firebaseUser =  FirebaseAuth.instance.currentUser;

                            //Saving in new collection
                            await Database.addItem(
                              uid: firebaseUser.uid,
                              name: firebaseUser.displayName,
                              age: age,
                              birthday: widget.userInfoMap['birthday'],
                              gender: widget.userInfoMap['gender'],
                              preferredGender: widget.userInfoMap['gender'] == 'male' ? 'female': 'male',
                              interests: choices,
                              email: firebaseUser.email,
                              phone : firebaseUser.phoneNumber,
                              imageUris : widget.photoList,
                              lat: latitude,
                              long: longtitude,
                              country: country,
                              city: city,
                              boosts: 2,
                              isProUser: false,
                              boosted: false,
                              lastSignIn: DateTime.now(),
                              signUpDate: DateTime.now(),
                            );

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

class preferencesFifthPage extends StatefulWidget {
  //local variable to catch the count value passed on from the parent widget
  final int count;

  //Creating Callback param in Child Widget(preferenceBox)
  final ValueChanged<int> parentAction;
  final ValueChanged<int> parentActionRemove;

  @override
  _preferencesFifthPageState createState() => _preferencesFifthPageState();

  //constructor
  const preferencesFifthPage(
      {Key key, this.parentAction, this.parentActionRemove, this.count})
      : super(key: key);
}

class _preferencesFifthPageState extends State<preferencesFifthPage> {
  final List<Preference> _preferences = preferencesList5;
  @override
  Widget build(BuildContext context) {
    return Container(
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
            children: List.generate(
              6,
              (index) {
                itemCount:
                _preferences.length;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_preferences[index].isSelected) {
                        _preferences[index].isSelected = false;

                        //Execute the callback(parentActionRemove) from the Child Widget.
                        widget.parentActionRemove(_preferences[index].pid);
                      } else {
                        //if the selection count goes above the limit give a warning
                        if (widget.count != null && widget.count > 5) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Reached the Limit")));
                        } else {
                          //Execute the callback(parentAction) from the Child Widget.
                          widget.parentAction(_preferences[index].pid);
                          _preferences[index].isSelected = true;
                        }
                      }
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
                                      _preferences[index].imgUrl.toString()),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.8),
                                      BlendMode.dstATop),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(0.9, -0.9),
                            child: _preferences[index].isSelected
                                ? Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.check,
                                        size: 10.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ),
                          Align(
                            alignment: Alignment(-0.9, 0.9),
                            child: Text(
                              _preferences[index].title.toString(),
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class preferencesFourthPage extends StatefulWidget {
  //local variable to catch the count value passed on from the parent widget
  final int count;

  //Creating Callback param in Child Widget(preferenceBox)
  final ValueChanged<int> parentAction;
  final ValueChanged<int> parentActionRemove;

  @override
  _preferencesFourthPageState createState() => _preferencesFourthPageState();

  //constructor
  const preferencesFourthPage(
      {Key key, this.parentAction, this.parentActionRemove, this.count})
      : super(key: key);
}

class _preferencesFourthPageState extends State<preferencesFourthPage> {
  final List<Preference> _preferences = preferencesList4;
  @override
  Widget build(BuildContext context) {
    return Container(
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
            children: List.generate(
              6,
              (index) {
                itemCount:
                _preferences.length;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_preferences[index].isSelected) {
                        _preferences[index].isSelected = false;

                        //Execute the callback(parentActionRemove) from the Child Widget.
                        widget.parentActionRemove(_preferences[index].pid);
                      } else {
                        //if the selection count goes above the limit give a warning
                        if (widget.count != null && widget.count > 5) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Reached the Limit")));
                        } else {
                          //Execute the callback(parentAction) from the Child Widget.
                          widget.parentAction(_preferences[index].pid);
                          _preferences[index].isSelected = true;
                        }
                      }
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
                                      _preferences[index].imgUrl.toString()),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.8),
                                      BlendMode.dstATop),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(0.9, -0.9),
                            child: _preferences[index].isSelected
                                ? Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.check,
                                        size: 10.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ),
                          Align(
                            alignment: Alignment(-0.9, 0.9),
                            child: Text(
                              _preferences[index].title.toString(),
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class preferencesThirdPage extends StatefulWidget {
  //local variable to catch the count value passed on from the parent widget
  final int count;

  //Creating Callback param in Child Widget(preferenceBox)
  final ValueChanged<int> parentAction;
  final ValueChanged<int> parentActionRemove;

  @override
  _preferencesThirdPageState createState() => _preferencesThirdPageState();

  //constructor
  const preferencesThirdPage(
      {Key key, this.parentAction, this.parentActionRemove, this.count})
      : super(key: key);
}

class _preferencesThirdPageState extends State<preferencesThirdPage> {
  final List<Preference> _preferences = preferencesList3;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            children: List.generate(
              6,
              (index) {
                itemCount:
                _preferences.length;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_preferences[index].isSelected) {
                        _preferences[index].isSelected = false;

                        //Execute the callback(parentActionRemove) from the Child Widget.
                        widget.parentActionRemove(_preferences[index].pid);
                      } else {
                        //if the selection count goes above the limit give a warning
                        if (widget.count != null && widget.count > 5) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Reached the Limit")));
                        } else {
                          //Execute the callback(parentAction) from the Child Widget.
                          widget.parentAction(_preferences[index].pid);
                          _preferences[index].isSelected = true;
                        }
                      }
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
                                      _preferences[index].imgUrl.toString()),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.8),
                                      BlendMode.dstATop),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(0.9, -0.9),
                            child: _preferences[index].isSelected
                                ? Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.check,
                                        size: 10.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ),
                          Align(
                            alignment: Alignment(-0.9, 0.9),
                            child: Text(
                              _preferences[index].title.toString(),
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class preferencesSecondPage extends StatefulWidget {
  //local variable to catch the count value passed on from the parent widget
  final int count;

  //Creating Callback param in Child Widget(preferenceBox)
  final ValueChanged<int> parentAction;
  final ValueChanged<int> parentActionRemove;

  @override
  _preferencesSecondPageState createState() => _preferencesSecondPageState();

  const preferencesSecondPage(
      {Key key, this.parentAction, this.parentActionRemove, this.count})
      : super(key: key);
}

class _preferencesSecondPageState extends State<preferencesSecondPage> {
  final List<Preference> _preferences = preferencesList2;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            children: List.generate(
              6,
              (index) {
                itemCount:
                _preferences.length;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_preferences[index].isSelected) {
                        _preferences[index].isSelected = false;

                        //Execute the callback(parentActionRemove) from the Child Widget.
                        widget.parentActionRemove(_preferences[index].pid);
                      } else {
                        //if the selection count goes above the limit give a warning
                        if (widget.count != null && widget.count > 5) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Reached the Limit")));
                        } else {
                          //Execute the callback(parentAction) from the Child Widget.
                          widget.parentAction(_preferences[index].pid);
                          _preferences[index].isSelected = true;
                        }
                      }
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
                                      _preferences[index].imgUrl.toString()),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.8),
                                      BlendMode.dstATop),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(0.9, -0.9),
                            child: _preferences[index].isSelected
                                ? Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.check,
                                        size: 10.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ),
                          Align(
                            alignment: Alignment(-0.9, 0.9),
                            child: Text(
                              _preferences[index].title.toString(),
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

///Using CallBacks data is passed on from child widget(this) to the parent(UserPreferences).
///Parent widget shares a the common list among all the child widgets to capture user selections.
class preferenceBox extends StatefulWidget {
  //local variable to catch the count value passed on from the parent widget
  final int count;

  //Creating Callback param in Child Widget(preferenceBox)
  final ValueChanged<int> parentAction;
  final ValueChanged<int> parentActionRemove;

  @override
  _preferenceBoxState createState() => _preferenceBoxState();

  //constructor
  const preferenceBox(
      {Key key, this.parentAction, this.parentActionRemove, this.count})
      : super(key: key);
}

/// GridView.Count generates gridviews using preferences data listed.
/// Each grid contains a card which is wrapped around with a gesture detector to determine the user selection.
class _preferenceBoxState extends State<preferenceBox> {
  final List<Preference> _preferences = preferencesList;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            children: List.generate(
              6,
              (index) {
                itemCount:
                _preferences.length;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_preferences[index].isSelected) {
                        _preferences[index].isSelected = false;

                        //Execute the callback(parentActionRemove) from the Child Widget.
                        widget.parentActionRemove(_preferences[index].pid);
                      } else {
                        //if the selection count goes above the limit give a warning
                        if (widget.count != null && widget.count > 5) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Reached the Limit")));
                        } else {
                          //Execute the callback(parentAction) from the Child Widget.
                          widget.parentAction(_preferences[index].pid);
                          _preferences[index].isSelected = true;
                        }
                      }
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
                                      _preferences[index].imgUrl.toString()),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.4),
                                      BlendMode.softLight),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(0.9, -0.9),
                            child: _preferences[index].isSelected
                                ? Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.check,
                                        size: 10.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ),
                          Align(
                            alignment: Alignment(-0.9, 0.9),
                            child: Text(
                              _preferences[index].title.toString(),
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
