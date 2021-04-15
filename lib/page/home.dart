import 'package:flutter/material.dart';
import 'package:meet_ceylon/data/users.dart';
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
  final List<User> users = dummyUsers;
  final firebaseAuth.FirebaseAuth _firebaseAuth =
      firebaseAuth.FirebaseAuth.instance;
  bool _visible = true;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
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
                      users.isEmpty
                          ? Text(
                              "We've run out of potential matches in your area. Go global and see poeple around the world. You can turn off global profiles in your settings at any time.")
                          : Stack(children: users.map(buildUser).toList()),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 10,
                      ),
                      buildButtonSection()
                    ],
                  ),
                ),
              ],
            ),
            buildInfoCard(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWidget(),
    );
  }

  _signOut() async {
    await _firebaseAuth.signOut();
  }

  Widget buildAppBar() => AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.person, color: Colors.grey),
              onPressed: _signOut),
          //Icon(Icons.person, color: Colors.grey),
          SizedBox(width: 16),
        ],
        leading: Icon(
          Icons.local_fire_department,
          color: Colors.deepOrangeAccent[100],
        ),
        title: Icon(Icons.chat, color: Colors.grey),
      );

  Widget buildUser(User user) {
    final userIndex = users.indexOf(user);
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
          photoAssetPaths: user.photos,
          visiblePhotoIndex: 0,
        ),
        feedback: Material(
          type: MaterialType.transparency,
          child: UserCardWidget(
            user: user,
            isUserInFocus: isUserInFocus,
            photoAssetPaths: user.photos,
            visiblePhotoIndex: 0,
          ),
        ),
        childWhenDragging: Container(),
        onDragEnd: (details) => onDragEnd(details, user),
      ),
    );
  }

  void onDragEnd(DraggableDetails details, User user) {
    final minimumDrag = 100;
    if (details.offset.dx > minimumDrag) {
      user.isSwipedOff = true;
    } else if (details.offset.dx < -minimumDrag) {
      user.isLiked = true;
    }

    if (user.isSwipedOff == true || user.isLiked == true) {
      setState(() {
        users.remove(user);
      });
    }
  }

  Widget buildInfoCard() {
    //for the button i create another column
    return Visibility(
      child: Container(
        child: Column(
          children: <Widget>[
            //first element in column is the transparent offset
            Container(
              height: SizeConfig.safeBlockHorizontal * 105,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: new Container(
                height: SizeConfig.safeBlockVertical * 15,
                width: SizeConfig.safeBlockHorizontal * 80,
                child: new Card(
                  color: Colors.white,
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

  Widget buildButtonSection() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              highlightColor: Colors.deepOrange,
              onPressed: () {}),
          IconButton(
              icon: Icon(Icons.info_outline_rounded),
              highlightColor: Colors.deepOrange,
              onPressed: () {
                setState(() {
                  _visible = !_visible;
                });
                _userBottomSheetModal(context);
              }),
          IconButton(
              icon: Icon(Icons.arrow_forward_rounded),
              highlightColor: Colors.deepOrange,
              onPressed: () {}),
        ],
      ),
    );
  }

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

  //onClose we set infoard visible
  void _onCloseModal(void value) {
    setState(() {
      _visible = true;
    });
  }

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
