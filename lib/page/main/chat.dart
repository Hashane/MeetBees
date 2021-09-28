
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as usr;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/model/chat.dart' as ChatModel;
import 'package:meet_ceylon/model/user.dart';
import 'package:meet_ceylon/provider/database.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:meet_ceylon/widget/page_routes/scale_page_route.dart';
import 'package:meet_ceylon/widget/custom_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../test.dart';


class Chats extends StatefulWidget {
  final Function onNav;


  const Chats({Key key, this.onNav}) : super(key: key);


  @override
  _ChatsState createState() => _ChatsState();
}


class _ChatsState extends State<Chats> {
  StreamSubscription _streamSubscription;
  StreamSubscription _streamSubscription1;


  Widget kBackBtn = Icon(
    Icons.arrow_back_ios,
    size: 40.0,
  );


  ///stream subscription
  final List<User> users = [];


  var lastMessageSet, membersValSet;
  List<ChatModel.Chat> myChats = [];
  List<ChatModel.Chat> secondUsers = [];


  ///test
  List<String> ids = [];
  String last = "";
  String chaId = "";


  ///Realtime updates from chat
  final DatabaseReference _ref = FirebaseDatabase(
      databaseURL:
      "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
      .reference();


  ///To track all the chats the user has started
  List<String> _chatIDList = [];


  ///Current user id
  final String currentUserId = usr.FirebaseAuth.instance.currentUser.uid;


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    ///This part is cruicial when the data deleted from backend
    ///When data is changed the listener fetches any remaining chats from the list
    ///When that data is yeilded previously it was only captured in the initState but then the UI won't be updated
    _streamSubscription.onData((data) {

      ///This is when all the chats are deleted to set the list empty and update the ui
      if(data.length == 0){
        setState(() {
          myChats.clear();
        });
      }

      ///Listening for data
      _streamSubscription1 = getInfo(data).listen((data) {
        if (!mounted) return;
        setState(() {
          myChats = data;
        });
      });
    });

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

              /// recentMatches()
              StreamBuilder(
                  stream: Database.readItems(),
                  builder: (context, snapshot) {
                    itemCount:
                    users.length;
                    users.clear();
                    if (snapshot.hasData && users.isEmpty) {
                      snapshot.data.docs.forEach((element) {
                        Map<String, dynamic> obj = element.data();
                        users.add(User.fromJson(obj));

                      });
                    }
                    return matchedUserCarousel();
                  }),
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
              Text(
                myChats.length.toString(),
                style: TextStyle(color: Colors.red),
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: myChats.length,
                  itemBuilder: (context, index) {
                    return ChatBox(index);
                  }),
            ],
          ),
        ),
      ),
      //bottomNavigationBar: showModalBottomSheet();
    );
  }


  Widget matchedUserCarousel() {
    return new Container(
      height: SizeConfig.safeBlockVertical * 10,
      child: new ListView.builder(
        padding: EdgeInsets.all(6),
        scrollDirection: Axis.horizontal,
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                widget.onNav(null, users[index].uid.trim(),
                    users[index].imageUris[0], users[index].name);
              },

              ///Initiating a new chat using uid
              child: CachedNetworkImage(
                imageUrl: users[index].imageUris[0],
                imageBuilder: (context, imageProvider) => Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget ChatBox(int index) {
    ///grab the index where current userid resides in the myChats list. That means under "members" of the "Chats" node in firebase
    int usrIndex = myChats[index].user2.indexOf(currentUserId);


    /// determine the index position of the second user in relation to the current user index
    int secondUserIndex = usrIndex == 0 ? 1 : 0;


    ///using the above index we grab the second user id from the list
    String secondUser =
    myChats[index].user2.elementAt(secondUserIndex).toString();

    print("second " + secondUser);

    ///calling the method to fetch name and image of the second user


    return StreamBuilder<List<ChatModel.Chat>>(
        stream: SecondUserInfo(FirebaseDatabase(
            databaseURL:
            "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
            .reference()
            .child("Users/$secondUser")),
        builder: (context, AsyncSnapshot<List<ChatModel.Chat>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            var indexedInfo;
            // if(snapshot.data != null && snapshot.data.length != 0)
              return  Dismissible(
                    key: Key(myChats[index].name.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        myChats.removeAt(index);
                      });
                    },
                    background: Container(
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                      /// In order to match the height with the card
                      color: Colors.red,
                      child: Icon(Icons.delete),
                    ),
                    child: Card(
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
                                padding: const EdgeInsets.all(5.0),
                                child:
                                //indexedInfo != null
                                 Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          snapshot.data.length > index ? snapshot.data?.elementAt(index).image : "https://i.stack.imgur.com/NiBMY.png?s=420&g=1",
                                        )))
                                )

                              ),
                              Expanded(
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          // indexedInfo != null
                                          //     ?  indexedInfo.name
                                          //     : "",
                                          snapshot.data.length > index ? snapshot.data?.elementAt(index).name.toString():"hash",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(
                                          height: SizeConfig.safeBlockVertical * 1,
                                        ),
                                        _chatIDList.length != 0
                                            ? Opacity(
                                          opacity:
                                          _chatIDList[index] == chaId ? 1.0 : 0.64,
                                          child: Text(
                                            _chatIDList[index] == chaId
                                                ? last
                                                : myChats[index].lastMessage.toString(),
                                            style: TextStyle(
                                                color: Colors.black54, fontSize: 12),
                                          ),
                                        )
                                            : Container(),
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
                            widget.onNav(
                                _chatIDList[index],
                                myChats[index].user2.elementAt(1).toString(),
                                myChats[index].image.toString(),
                                myChats[index].name.toString());
                          },
                        ),
                      ),
                    ),
                  );
          } else {
            return shimmercardWidget();}});
  }


  Widget shimmercardWidget(){
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
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: CustomWidget.circular(height: 50.0, width: 50.0),
            ),
            Expanded(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomWidget.rectangular(height: 10, width: MediaQuery.of(context).size.width*0.3),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 1,
                      ),
                      CustomWidget.rectangular(height: 10, width:MediaQuery.of(context).size.width*0.3),
                    ],
                  ),
                  Positioned(
                    right: 8,
                    child: CustomWidget.rectangular(height: 10, width:MediaQuery.of(context).size.width* 0.1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget ChatBoxforStream(ChatModel.Chat chat) {
    int index = myChats.indexOf(chat);
    //return Container(color: Colors.red,);


    return Card(
      elevation: 5,
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: Theme.of(context).colorScheme.surface,
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
                      image: NetworkImage(chat.image.toString()),
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
                          chat.name.toString(),
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
                            chat.lastMessage.toString(),
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
            widget.onNav(_chatIDList[index], chat.user2.elementAt(1).toString(),
                chat.image.toString(), chat.name.toString());
          },
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();

    ///reading 'UserChats' node
    _streamSubscription = getData().listen((data) {
      print("FUCKERRRRR");
      if (!mounted) return;
      setState(() {
        ids = data;
      });
    });

    ///When the stream spits out data the second stream is invoked to actively listen to 'Chats' node
    _streamSubscription.onData((data) {
      print("ddd");
      _streamSubscription1 = getInfo(data).listen((data) {
        if (!mounted) return;
        setState(() {
          myChats = data;
        });
      });
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _streamSubscription?.cancel();
    _streamSubscription1?.cancel();
    super.dispose();
  }

  ///
  /// Looping the chat id list to get the Chat related information
  /// such as lastSentMessage & thumb to indicate inside each users inbox
  ///
  /// Actively listening to "Chats" node to listen to any realtime updates
  /// in order to update the chat box UI with the lastSentMessage
  ///
  Stream<List<ChatModel.Chat>> getInfo(List<String> li) async* {
    final List<ChatModel.Chat> foundChats = [];


    for (var i in li) {
      ChatModel.Chat thisChat;
      FirebaseDatabase(
          databaseURL:
          "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
          .reference()
          .child("Chats/$i")
          .once()
          .then((event) {
        thisChat = ChatModel.Chat.fromJson(event.value);
        foundChats.add(thisChat);

      });


      FirebaseDatabase(
          databaseURL:
          "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
          .reference()
          .child("Chats/$i")
          .onValue
          .listen((event) {
        if (mounted) {
          setState(() {
            if(event.snapshot.value != null) {
              last = event.snapshot.value["lastSentMessage"];

              ///the last message itself recently updated
              chaId = i;

              ///used to indicate which last message was updated among all the other user chats
            }
          });
        }
      });

      print("INSIDE....");
      print("INSIDE.... " + foundChats.toString());
      yield foundChats;
    }
  }

  ///
  /// Fetching all the chat ids under a particular userid
  /// then adding those chat ids into a list
  ///
  Stream<List<String>> getData() async* {
    var usersChatsStream = FirebaseDatabase(
        databaseURL:
        "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
        .reference()
        .child('UserChats/$currentUserId')
        .onValue;


    List<ChatModel.Chat> foundChats = [];

    await for (var userChatSnapshot in usersChatsStream) {
      foundChats.clear();
      _chatIDList.clear();


      ///Keep track of chatID
      Map dictionary = userChatSnapshot.snapshot.value;
      if (dictionary != null) {
        for (var dictItem in dictionary.entries) {
          String chatID;
          if (dictItem.key != null) {
            chatID = dictItem.value;
          } else {
            chatID = "";
          }
          _chatIDList.add(chatID);

        }
      }

      yield _chatIDList;
    }
  }


  ///
  /// DatabaseReference points to Users node of the DB
  /// fetching second users info
  ///
  Stream<List<ChatModel.Chat>> SecondUserInfo(DatabaseReference databaseReference) async* {
    print("Secondingggg");
    ChatModel.Chat secondUser;
    secondUsers.clear();
    DataSnapshot snapshot = await databaseReference.once();
    if (snapshot.value != null) {
      /// Since name & image is stored as a map in the DB we assign the values to a map and then iterate to access the JSON object map
      Map dictionary = snapshot.value;
      if (dictionary != null) {
        for (var dictItem in dictionary.entries) {
          ///Json object is transformed to the chat model
          secondUser = ChatModel.Chat.fromUsers(dictItem.value, null, null);
        }
        secondUsers.add(secondUser);
      }
    }
    yield secondUsers;
  }
}

