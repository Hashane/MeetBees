import 'package:flutter/material.dart';
import 'package:meet_ceylon/data/users.dart';
import 'package:meet_ceylon/provider/position_feedback_provider.dart';
import 'package:meet_ceylon/widget/bottom_nav_widget.dart';
import 'package:meet_ceylon/model/user.dart';
import 'package:meet_ceylon/widget/user_card_widget.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final List<User> users = dummyUsers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            users.isEmpty
                ? Text("We've run out of potential matches in your area. Go global and see poeple around the world. You can turn off global profiles in your settings at any time.")
                : Stack(children: users.map(buildUser).toList()),

            Expanded(child: Container()),
            BottomNavWidget()
          ],
        ),
      ),
    );
  }


  Widget buildAppBar() =>
      AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Icon(Icons.person, color: Colors.grey),
          SizedBox(width: 16),
        ],
        leading: Icon(
          Icons.local_fire_department, color: Colors.deepOrangeAccent[100],),
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
      onPointerCancel: (_){
        final provider = Provider.of<FeedbackPositionProvider>(context, listen: false);
        provider.resetPosition();
      },
      onPointerUp: (_){
        final provider = Provider.of<FeedbackPositionProvider>(context, listen: false);
        provider.resetPosition();
      },
      child: Draggable(
          child: UserCardWidget(user: user, isUserInFocus: isUserInFocus),
          feedback: Material(
            type: MaterialType.transparency,
            child: UserCardWidget(user: user, isUserInFocus: isUserInFocus),
          ),
        //childWhenDragging: Container(),
        onDragEnd: (details) => onDragEnd(details, user),
      ),
    );
  }

 void onDragEnd(DraggableDetails details, User user) {
    final minimumDrag = 100;
    if(details.offset.dx > minimumDrag){
      user.isSwipedOff = true;
    }else if(details.offset.dx < -minimumDrag){
      user.isLiked = true;
    }

    setState(() {
      users.remove(user);
    });
 }

}