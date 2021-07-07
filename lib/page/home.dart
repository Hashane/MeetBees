import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/database.dart';
import 'package:meet_ceylon/provider/position_feedback_provider.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:meet_ceylon/widget/bottom_nav_widget.dart';
import 'package:meet_ceylon/model/user.dart';
import 'package:meet_ceylon/widget/user_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'dart:developer' as developer;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<User> users = [];

  ///stream subscription
  StreamSubscription _messSubs;

  ///logging out user
  final firebaseAuth.FirebaseAuth _firebaseAuth =
      firebaseAuth.FirebaseAuth.instance;

  /// value used to determines if to hide/show infoCard
  bool _visible = true;

  ///Card carousel transform scale initial value
  int _index = 0;

  ///To determine which user being displayed in the card from the users list.
  int userIndex = 0;

  @override
  void initState() {
    super.initState();
    ///initializing stream and fetching users
    fetchUsers();
  }

  @override
  void dispose() {
    ///cancelling StreamSubscription on dispose
    _messSubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: buildAppBar(),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        users.length == 0
                            ? SizedBox(
                                height: 600,
                                child: Text(
                                    "We've run out of potential matches in your area. Go global and see poeple around the world. You can turn off global profiles in your settings at any time."))
                            : SizedBox(
                                height: 600,
                                child: Stack(
                                    children: users.map(buildUser).toList())),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 1,
                        ),
                        users.length != 0 ? buildButtonSection() : Container(),
                      ],
                    ),
                  ),
                ],
              ),
              users.length != 0 ? buildInfoCard(users[userIndex]) : Container(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavWidget(),
      ),
    );
  }

  /// Listening to the Stream & looping through the documents
  /// Assigning Each Json Object user profile to a map
  /// Mapping that JSON object map to custom User model
  /// At the end changing the state to update the users list.
  fetchUsers() {
    _messSubs = Database.readItems().listen((event) {
      event.docs.forEach((element) {
        Map<String, dynamic> obj = element.data();
        users.add(User.fromJson(obj));
        setState(() {});
      });
    });
  }

  ///Sign out function
  _signOut() async {
    await _firebaseAuth.signOut();
  }

  ///App bar on top
  Widget buildAppBar() => AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.person, size: 40.0, color: Colors.black54),
              onPressed: _signOut),
          //Icon(Icons.person, color: Colors.grey),
          SizedBox(width: 16),
        ],
        leading: Icon(
          Icons.replay,
          size: 40.0,
          color: Colors.black54,
        ),
        title: ImageIcon(
          AssetImage("assets/images/logo.png"),
          color: Colors.deepOrangeAccent,
          size: 60.0,
        ),
      );

  ///This builds the user cards
  Widget buildUser(User user) {
    userIndex = users.indexOf(user);
    final isUserInFocus = userIndex == users.length - 1;

    return Listener(
      onPointerMove: (pointerEvent) {
        final provider =
            Provider.of<FeedbackPositionProvider>(context, listen: false);
        provider.updatePosition(pointerEvent.localDelta.dx);
      },
      onPointerCancel: (_) {
        final provider =
            Provider.of<FeedbackPositionProvider>(context, listen: false);
        provider.resetPosition();
      },
      onPointerUp: (_) {
        final provider =
            Provider.of<FeedbackPositionProvider>(context, listen: false);
        provider.resetPosition();
      },
      child: Draggable(
        child: UserCardWidget(
          user: user,
          isUserInFocus: isUserInFocus,
          photoAssetPaths: user.imageUris,
          visiblePhotoIndex: 0,
        ),
        feedback: Material(
          type: MaterialType.transparency,
          child: UserCardWidget(
            user: user,
            isUserInFocus: isUserInFocus,
            photoAssetPaths: user.imageUris,
            visiblePhotoIndex: 0,
          ),
        ),
        childWhenDragging: Container(),
        onDragEnd: (details) => onDragEnd(details, user),
      ),
    );
  }

  ///Function responsible for handling drag/swipe behavior
  ///Determines if user swiped left/right
  ///Users swiped off are removed from the user list at the end.
  void onDragEnd(DraggableDetails details, User user) {
    final minimumDrag = 100;
    if (details.offset.dx > minimumDrag) {
      user.isSwipedOff = true;
    } else if (details.offset.dx < -minimumDrag) {
      user.isLiked = true;
    }

    if (user.isSwipedOff == true || user.isLiked == true) {
      print(users.length.toString());
      setState(() {
        users.removeAt(userIndex);
      });
    }
  }

  ///Displays current user's basic personal info in a card
  ///Visibility widget is used to hide/show the info card when _userBottomSheetModal pops up/down
  Widget buildInfoCard(User user) {
    //for the button i create another column
    return Visibility(
      child: Container(
        child: Column(
          children: <Widget>[
            //first element in column is the transparent offset
            Container(
              height: SizeConfig.safeBlockHorizontal * 110,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: new Container(
                height: SizeConfig.safeBlockVertical * 12,
                width: SizeConfig.safeBlockHorizontal * 87,
                child: new Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 23,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              user.age.toString(),
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 23,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          "10 kms Away",
                          style: TextStyle(
                              color: Colors.black54,
                              fontStyle: FontStyle.normal),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white70,
                  elevation: 4.0,
                ),
              ),
            ),
          ],
        ),
      ),
      visible: _visible,
    );
  }

  ///Set of action buttons underneath the Card
  ///on click of 'i' button _userBottomSheetModal will be displayed and infoCard will be hidden.
  Widget buildButtonSection() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            backgroundColor: Colors.orangeAccent,
            child: IconButton(
                icon: Icon(Icons.arrow_left),
                color: Colors.white,
                highlightColor: Colors.deepOrange,
                onPressed: () {}),
          ),
          CircleAvatar(
            backgroundColor: Colors.orangeAccent,
            child: IconButton(
                icon: Icon(Icons.info_outline_rounded),
                color: Colors.white,
                highlightColor: Colors.deepOrange,
                onPressed: () {
                  setState(() {
                    _visible = !_visible;
                  });
                  _userBottomSheetModal(context);
                }),
          ),
          CircleAvatar(
            backgroundColor: Colors.orangeAccent,
            child: IconButton(
                icon: Icon(Icons.arrow_right),
                color: Colors.white,
                highlightColor: Colors.deepOrange,
                onPressed: () {}),
          ),
        ],
      ),
    );
  }

  ///Bottom Sheet widget containing user information
  Widget _userBottomSheetModal(context) {
    Future<void> future = showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: SizeConfig.safeBlockVertical * 60,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: ListView(
                  // controller: , // set this too
                  children: [
                    userInfo(),
                    Text(
                      'Here is a little trick for you. If you add an intriguing phrase like “better looking in person”, more women will go on a date with you. Females are curious by nature, so they will want to see how you actually look like.',
                      style: TextStyle(color: Colors.white),
                    ),
                    userInfo(),
                    userInfo(),
                    userPassions(),
                  ],
                ),
              ),
            ),
          );
        });
    future.then((void value) => _onCloseModal(value));
  }


  ///on Bottom Sheet widget Close setting info card invisible
  void _onCloseModal(void value) {
    setState(() {
      _visible = true;
    });
  }

  ///Sample set of user info content
  Widget userInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 5),
        Text(
          'Hashane, 26',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 38,
          ),
        ),
        Text(
          "Software Engineer",
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 18),
        Text(
          'Here is a little trick for you. If you add an intriguing phrase like “better looking in person”, more women will go on a date with you. Females are curious by nature, so they will want to see how you actually look like.',
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  ///Card carousel used to display user images
  Widget userPassions() {
    return Center(
      child: SizedBox(
        height: 200, // card height
        child: PageView.builder(
          itemCount: 10,
          controller: PageController(viewportFraction: 0.7),
          onPageChanged: (int index) => setState(() => _index = index),
          itemBuilder: (_, i) {
            return Transform.scale(
              scale: i == _index ? 1 : 0.95,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text(
                    "Card ${i + 1}",
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
