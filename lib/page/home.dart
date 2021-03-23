import 'package:flutter/material.dart';
import 'package:meet_ceylon/data/users.dart';
import 'package:meet_ceylon/provider/position_feedback_provider.dart';
import 'package:meet_ceylon/provider/size_confiogurations.dart';
import 'package:meet_ceylon/widget/bottom_nav_widget.dart';
import 'package:meet_ceylon/model/user.dart';
import 'package:meet_ceylon/widget/user_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<User> users = dummyUsers;
  final firebaseAuth.FirebaseAuth _firebaseAuth =
      firebaseAuth.FirebaseAuth.instance;
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: SizeConfig.safeBlockVertical * 2,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    users.isEmpty
                        ? Text(
                            "We've run out of potential matches in your area. Go global and see poeple around the world. You can turn off global profiles in your settings at any time.")
                        : Stack(children: users.map(buildUser).toList()),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 10,
                    ),
                    buildButtonSection(),
                  ],
                ),
              ),
            ],
          ),
          buildInfoCard(),
        ],
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
          Icon(Icons.person, color: Colors.grey),
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
    return Visibility(child: Container(
      child: Column(
        children: <Widget>[
          //first element in column is the transparent offset
          Container(
            height: SizeConfig.safeBlockHorizontal * 100,
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
          Expanded(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back_rounded, color: Colors.deepOrange),
            ),
          ),
          Expanded(
            child:
             IconButton(icon: Icon(Icons.info_outline_rounded),highlightColor: Colors.deepOrange,
                  onPressed: (){

                    setState(() {
                      _visible = !_visible;
                    });
               _userBottomSheetModal(context); }),

          ),
          Expanded(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_forward_rounded, color: Colors.deepOrange),
            ),
          ),
        ],
      ),
    );
  }

Widget _userBottomSheetModal(context){
  Future<void> future = showModalBottomSheet(context: context, builder: (BuildContext bc)
      {
        return Container(
          height: SizeConfig.safeBlockVertical * 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Jude Hashane, 26',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 38,
                        ),
                      ),
                      SizedBox(height: 18),
                      Text(
                        "Software Engineer",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Mutual Friends',
                        style: TextStyle(color: Colors.white),
                      )
            ],
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
}


