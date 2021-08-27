import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/model/chatMessages.dart';
import 'package:meet_ceylon/provider/message_dao.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:meet_ceylon/widget/page_routes/scale_page_route.dart';

import '../test.dart';

class Chat extends StatefulWidget {
  final Function onNav;

  const Chat({Key key, this.onNav}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Widget kBackBtn = Icon(
    Icons.arrow_back_ios,
    size: 40.0,
  );

  ///stream subscription
  Stream _messSubs;
  final List<ChatMessage> chats = [];

  var lastMessageSet, membersValSet;

  ///Realtime updates from chat
  final DatabaseReference _ref = FirebaseDatabase(
          databaseURL:
              "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
      .reference();

  ///To track all the chats the user has started
  final List<String> _chatIDList = [];
  final List<String> _lastMList = [];
  final List<String> _membersList = [];
  final List<String> _thumbList = [];
  final List<String> _usernameList = [];
  //final List<String> _chatIDList = [];

  ///Current user id
  final String currentUserId = FirebaseAuth.instance.currentUser.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("Chat", style: Theme.of(context).textTheme.headline5),
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.secondary,
        ),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.safeBlockVertical * 5,
              ),
              Center(
                child: Container(
                  width: SizeConfig.safeBlockHorizontal * 80,
                  height: SizeConfig.safeBlockVertical * 5,
                  decoration: new BoxDecoration(
                    border: Border.all(color: Colors.transparent),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_fire_department,
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 3),
                      Text(
                        "Use flames to get more matches",
                        style: TextStyle(
                            color: Colors.white, fontStyle: FontStyle.normal),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 2,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Recent matches",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, ScaleRoute(page: Screen2()));
                },
                child: Text('Go to next screen'),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 3,
              ),
              recentMatches(),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 5,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Message History",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal),
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 3,
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _chatIDList.length,
                  itemBuilder: (context, index) {
                    return ChatBox(index);
                  })
            ],
          ),
        ),
      ),
      //bottomNavigationBar: showModalBottomSheet();
    );
  }

  void LiveListen() {
    /// Fetching all the chats under the logged in user and adding their "ChatIds" to a list
    var query = _ref.child("UserChats").child(currentUserId);
    query.onChildAdded.forEach((event) {
      _chatIDList.add(event.snapshot.value);
    });

    ///Once the query completes and list is ready
    query.once().whenComplete(() => {
          _chatIDList.forEach((element) {
            ///Grab individual Chat information using the "ChatIds" in the list
            _ref
                .child("Chats")
                .child(element)
                .once()
                .then((DataSnapshot snapshot) async {
              if (snapshot.exists) {
                ///Sample snapshot -
                /// {lastSentMessage: a, members: [PRRP71u1p1SwCWo8JguIf8T4xG73, 0ooqj1kSWtbEj1TvzXpaVn5so3L2]}
                Map data = snapshot.value;

                ///From the map takes 'last' set which contains all the member information
                var membersValSet = data.entries.toList().last;

                ///from that set we grab the member at the 01 position (which is the 2nd user id)
                _membersList.add(membersValSet.value[1]);

                ///First set of the map contains the lastMessages
                var lastMessageSet = data.entries.toList().first;

                _lastMList.add(lastMessageSet.value);
                //print(lastMessageSet.value);

                ///2nd User's thumbnail and name is fetched here
                var collection = FirebaseFirestore.instance.collection('SL');
                var docSnapshot =
                    await collection.doc(membersValSet.value[1]).get();
                if (docSnapshot.exists) {

                  Map<String, dynamic> data = docSnapshot.data();
                  _usernameList.add(data['name']);
                  _thumbList.add(data['image_uris'][0]);

                  if (mounted) {
                    setState(() {
                      /** **/
                    });
                  }


                }
              }
            });
          }),
        });
  }

  Widget recentMatches() {
    return PhysicalModel(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.grey[100],
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: SizeConfig.safeBlockHorizontal * 75,
        height: SizeConfig.safeBlockVertical * 10,
        decoration: new BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 45, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  width: SizeConfig.safeBlockHorizontal * 15,
                  height: SizeConfig.safeBlockVertical * 10,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://i.stack.imgur.com/NiBMY.png?s=420&g=1"),
                    ),
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: SizeConfig.safeBlockHorizontal * 15,
                height: SizeConfig.safeBlockVertical * 10,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://i.stack.imgur.com/NiBMY.png?s=420&g=1"),
                  ),
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                width: SizeConfig.safeBlockHorizontal * 15,
                height: SizeConfig.safeBlockVertical * 10,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://i.stack.imgur.com/NiBMY.png?s=420&g=1"),
                  ),
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ChatBox(int index) {
    if(_usernameList != null && _usernameList.length > index &&  _lastMList != null && _lastMList.length > index &&
        _chatIDList != null &&  _chatIDList.length > index && _membersList != null && _membersList.length > index) {
      return Card(
        elevation: 5,
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: Theme
            .of(context)
            .colorScheme
            .surface,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "https://i.stack.imgur.com/NiBMY.png?s=420&g=1"),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _usernameList[index],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 1,
                          ),
                          Opacity(
                            opacity: 0.64,
                            child: Text(
                              _lastMList.elementAt(index),
                              style:
                              TextStyle(color: Colors.black54, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 8,
                        child: Text(
                          "Yesterday",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              widget.onNav(_chatIDList[index], _membersList[index]);
            },
          ),
        ),
      );
    }else{
      return Card(
        elevation: 5,
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: Colors.grey[100],
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://i.stack.imgur.com/NiBMY.png?s=420&g=1"),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Hashane",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 1,
                      ),
                      Text(
                        "See you!",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      )
                    ],
                  ),
                  Positioned(
                    right: 8,
                    child: Text(
                      "Yesterday",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

  }

  @override
  void initState() {
    super.initState();
    LiveListen();
  }

}
