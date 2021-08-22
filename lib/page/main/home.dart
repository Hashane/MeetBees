import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/page/profile_data/personal_info.dart';
import 'package:meet_ceylon/page/test.dart';
import 'package:meet_ceylon/page/user_profile/profile.dart';
import 'package:meet_ceylon/provider/database.dart';
import 'package:meet_ceylon/provider/position_feedback_provider.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:meet_ceylon/widget/app_bar_widget.dart';
import 'package:meet_ceylon/model/user.dart';
import 'package:meet_ceylon/widget/premium_plans_widget.dart';
import 'package:meet_ceylon/widget/user_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:google_fonts/google_fonts.dart';

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
        backgroundColor: Colors.grey[200],
        appBar: buildAppBar(),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        users.length == 0
                            ? SizedBox(
                                height: SizeConfig.safeBlockVertical * 70,
                                child: Text(
                                    "We've run out of potential matches in your area. Go global and see poeple around the world. You can turn off global profiles in your settings at any time."))
                            : SizedBox(
                                height: SizeConfig.safeBlockVertical * 70,
                                child: Stack(
                                    children: users.map(buildUser).toList())),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 1,
                        ),
                        users.length != 0
                            ? buildButtonSection(users[userIndex])
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
              users.length != 0
                  ? Positioned(
                      bottom: SizeConfig.safeBlockVertical * 10,
                      left: SizeConfig.safeBlockHorizontal * 1,
                      right: SizeConfig.safeBlockHorizontal * 1,
                      child: buildInfoCard(users[userIndex]))
                  : Container(),
            ],
          ),
        ),
        //bottomNavigationBar: showModalBottomSheet();
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

  _navigateProfile() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => UserProfile()
    ));
  }

  ///App bar on top
  Widget buildAppBar() => AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.person, size: 40.0, color: Colors.black54),
              onPressed: _navigateProfile),
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
  Widget buildButtonSection(User user) {
    return Container(
      padding: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: new Container(
              height: 50.0,
              width: 80.0,
              child: new Material(
                child: InkWell(
                  // When the user taps the button, show a snackbar.
                  onTap: () {
                    ///user is removed but not added to disliked list yet.
                    setState(() {
                      users.removeAt(userIndex);
                    });
                  },
                  child: Icon(Icons.clear, size: 30.0, color: Colors.black38),
                ),
                color: Colors.transparent,
              ),
              color: Colors.white,
            ),
          ),
          ClipRRect(
            child: Container(
                height: 45.0,
                width: 60.0,
                color: Colors.transparent,
                child: InkWell(
                  // When the user taps the button, show a snackbar.
                  onTap: () {
                    setState(() {
                      _visible = !_visible;
                    });
                    //_premiumPlansBottomSheetModal(context);
                    _matchedBottomSheetModal(context);
                    //_userBottomSheetModal(context, user);
                  },
                  child: Icon(Icons.more_horiz_sharp,
                      size: 50.0, color: Colors.black45),
                )),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: new Container(
              height: 50.0,
              width: 80.0,
              child: new Material(
                child: InkWell(
                  // When the user taps the button, show a snackbar.
                  onTap: () {
                    ///user is removed but not added to disliked list yet.
                    setState(() {
                      users.removeAt(userIndex);
                    });
                  },
                  child:
                      Icon(Icons.favorite, size: 30.0, color: Colors.black38),
                ),
                color: Colors.transparent,
              ),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  ///Bottom Sheet widget containing user information
  Widget _userBottomSheetModal(context, User user) {
    Future<void> future = showModalBottomSheet(
        useRootNavigator: true,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (BuildContext bc) {
          return Container(
            height: SizeConfig.safeBlockVertical * 60,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                child: ListView(
                  // controller: , // set this too
                  children: [
                    userInfo(user),
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
  Widget userInfo(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20),
        Text(
          user.name + ", " + user.age.toString(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "10 kms Away",
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(fontWeight: FontWeight.normal),
        ),
        SizedBox(height: 10),
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Icon(Icons.work, color: Colors.white),
                ),
              ),
              TextSpan(
                text: "Software Engineer",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Icon(Icons.school, color: Colors.white),
                ),
              ),
              TextSpan(
                text: "Computer Science",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        SizedBox(height: 25),
        Text(
          'Interests & Hobbies',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          runSpacing: 5.0,
          spacing: 5.0,
          children: <Widget>[
            Container(
              child: Container(
                height: 35,
                child: FittedBox(
                  fit: BoxFit.none,
                  child: Text(
                    'Basketball',
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(fontSize: 20),
                  ),
                ),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  shape: BoxShape.rectangle,
                  border: new Border.all(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
              ),
            ),
            Container(
              child: Container(
                height: 35,
                child: FittedBox(
                  fit: BoxFit.none,
                  child: Text(
                    'DIY',
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(fontSize: 20),
                  ),
                ),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  shape: BoxShape.rectangle,
                  border: new Border.all(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
              ),
            ),
            Container(
              child: Container(
                height: 35,
                child: FittedBox(
                  fit: BoxFit.none,
                  child: Text(
                    'Reading',
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(fontSize: 20),
                  ),
                ),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  shape: BoxShape.rectangle,
                  border: new Border.all(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
              ),
            ),
            Container(
              child: Container(
                height: 35,
                child: FittedBox(
                  fit: BoxFit.none,
                  child: Text(
                    'Workout',
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(fontSize: 20),
                  ),
                ),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  shape: BoxShape.rectangle,
                  border: new Border.all(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
              ),
            ),
            Container(
              child: Container(
                height: 35,
                child: FittedBox(
                  fit: BoxFit.none,
                  child: Text(
                    'Music',
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(fontSize: 20),
                  ),
                ),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  shape: BoxShape.rectangle,
                  border: new Border.all(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
        Text(
          'Bio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 15),
        Text(
          'Here is a little trick for you. If you add an intriguing phrase like “better looking in person.',
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  ///Bottom Sheet widget for matching users
  Widget _matchedBottomSheetModal(context) {
    Future<void> future = showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: false,
        context: context,
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext bc) {
          return Container(
            height: SizeConfig.safeBlockVertical * 60,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                child: ListView(
                  // controller: , // set this too
                  children: [
                    _matchingCards(),
                  ],
                ),
              ),
            ),
          );
        });
    future.then((void value) => _onCloseModal(value));
  }

  Widget _matchingCards() {
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
                'Match!',
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
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.rotate(
                    alignment: Alignment.centerRight,
                    angle: -0.3,
                    child: Container(
                        width: 120,
                        height: 170,
                        decoration: BoxDecoration(
                          // color: Colors.blue,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(users[userIndex].imageUris[0]),
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                  Transform.rotate(
                    alignment: Alignment.centerLeft,
                    angle: 0.3,
                    child: Container(
                        width: 120,
                        height: 170,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://i.stack.imgur.com/NiBMY.png?s=420&g=1"),
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                ]),
            SizedBox(height: SizeConfig.safeBlockVertical * 5),
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
                'Chat',
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
        Positioned(
          bottom: 40,
          child: ImageIcon(
            AssetImage("assets/images/logo.png"),
            color: Colors.deepOrangeAccent,
            size: 80.0,
          ),
        ),
      ],
    );
  }

  ///Bottom Sheet widget to display Premium Plans
  Widget _premiumPlansBottomSheetModal(context) {
    Future<void> future = showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: false,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext bc) {
          return Container(
            height: SizeConfig.safeBlockVertical * 60,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container(
                child: ListView(
                  // controller: , // set this too
                  children: [
                    premiumPlansContent(context),
                  ],
                ),
              ),
            ),
          );
        });
    future.then((void value) => _onCloseModal(value));
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
