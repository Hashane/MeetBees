
import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as usr;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/model/chat.dart' as ChatModel;
import 'package:meet_ceylon/model/chatMessages.dart';
import 'package:meet_ceylon/model/user.dart';
import 'package:meet_ceylon/provider/database.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:meet_ceylon/widget/page_routes/scale_page_route.dart';
import 'package:meet_ceylon/widget/custom_widget.dart';


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


                        //print("loading");
                      });
                    }
                    return matchedUserCarousel();
                  }),
              // recentMatches(),
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
                    //return Text(myChats[index].name);
                  }),


              // StreamBuilder(
              //     stream: getData(),
              //     builder: (context, snapshot) {
              //       itemCount:
              //       myChats.length;
              //       //myChats.clear();
              //       if (snapshot.hasError || !snapshot.hasData)
              //         return new Text('Error: ${snapshot.error}');
              //       switch (snapshot.connectionState) {
              //         case ConnectionState.waiting:
              //           return new Text("Loading...");
              //         default:
              //           return ListView(
              //             scrollDirection: Axis.vertical,
              //             shrinkWrap: true,
              //             children: myChats.map(ChatBoxforStream).toList(),
              //           );
              //       }
              //     }),


              ///test
              // StreamBuilder(
              //     stream: getInfo(ids),
              //     builder: (context, snapshot) {
              //       itemCount:
              //       myChats.length;
              //       //myChats.clear();
              //       if (snapshot.hasError || !snapshot.hasData)
              //         return new Text('Error: ${snapshot.error}');
              //       switch (snapshot.connectionState) {
              //         case ConnectionState.waiting:
              //           return new Text("Loading...");
              //         default:
              //           return ListView(
              //             scrollDirection: Axis.vertical,
              //             shrinkWrap: true,
              //             children: myChats.map(ChatBoxforStream).toList(),
              //           );
              //       }
              //     }),
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
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    users[index].imageUris[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  // void prepareData(DataSnapshot snapshot, int index) {
  //   /// Fetching all the chats under the logged in user and adding their "ChatIds" to a list
  //   if (_chatIDList.contains(snapshot.value)) {
  //     // print(snapshot.value + " " + "Dismissed");
  //   } else {
  //     //print(snapshot.value.toString() + " " + "Accepted");
  //
  //     _chatIDList.add(snapshot.value.toString());
  //
  //     // print(_chatIDList.first);
  //
  //     if (_chatIDList.length > 0 && _chatIDList != null) {
  //       _chatIDList.forEach((element) {
  //         ///Grab individual Chat information using the "ChatIds" in the list
  //         _ref
  //             .child("Chats")
  //             .child(element)
  //             .once()
  //             .then((DataSnapshot snapshot) async {
  //           if (snapshot.exists) {
  //             ///Sample snapshot -
  //             /// {lastSentMessage: a, members: [PRRP71u1p1SwCWo8JguIf8T4xG73, 0ooqj1kSWtbEj1TvzXpaVn5so3L2]}
  //             Map data = snapshot.value;
  //
  //             ///From the map takes 'members' set which contains all the member information
  //             var user2ID = data["members"][1];
  //             _membersList.add(user2ID);
  //             // print(membersValSet);
  //
  //             ///First set of the map contains the lastMessages
  //             // print(data.values);
  //             var lastMessageSet = data["lastSentMessage"];
  //             _lastMList.add(lastMessageSet);
  //             //print(lastMessageSet.value);
  //
  //             ///2nd User's thumbnail and name is fetched here
  //             var thumb = data["thumb"];
  //             var name = data["name"];
  //             _usernameList.add(name);
  //             _thumbList.add(thumb);
  //
  //
  //             ///Legacy method used for fetching thumb & name staright from Firestore.
  //             ///Todo check this out later.
  //             // var collection = FirebaseFirestore.instance.collection('SL');
  //             // var docSnapshot = await collection.doc(user2ID).get();
  //             // if (docSnapshot.exists) {
  //             //   Map<String, dynamic> data = docSnapshot.data();
  //             //   _usernameList.add(data['name']);
  //             //   _thumbList.add(data['image_uris'][0]);
  //             //   if (mounted) {
  //             //     setState(() {
  //             //       /** **/
  //             //     });
  //             //   }
  //             // }
  //           }
  //         });
  //       });
  //       _chatIDList.remove(0);
  //     }
  //   }
  //
  //   ///Once the query completes and list is ready
  // }


  // Widget recentMatches(User user) {
  //   return PhysicalModel(
  //     color: Colors.white,
  //     elevation: 8,
  //     shadowColor: Colors.grey[100],
  //     borderRadius: BorderRadius.circular(10),
  //     child: Container(
  //       width: SizeConfig.safeBlockHorizontal * 75,
  //       height: SizeConfig.safeBlockVertical * 10,
  //       decoration: new BoxDecoration(
  //         border: Border.all(color: Colors.black54),
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.fromLTRB(5, 5, 45, 5),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           //crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Material(
  //               child: InkWell(
  //                 onTap: () {
  //                   widget.onNav(null, user.uid);
  //                 },
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(5.0),
  //                   child: Container(
  //                     width: SizeConfig.safeBlockHorizontal * 15,
  //                     height: SizeConfig.safeBlockVertical * 10,
  //                     decoration: new BoxDecoration(
  //                       image: new DecorationImage(
  //                         fit: BoxFit.cover,
  //                         image: NetworkImage(user.imageUris[0]),
  //                       ),
  //                       border: Border.all(color: Colors.transparent),
  //                       borderRadius: BorderRadius.circular(5),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey,
  //                           offset: Offset(0.0, 1.0), //(x,y)
  //                           blurRadius: 6.0,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }


  Widget ChatBox(int index) {
    ///grab the index where current userid resides in the myChats list. That means under "members" of the "Chats" node in firebase
    int usrIndex = myChats[index].user2.indexOf(currentUserId);


    /// determine the index position of the second user in relation to the current user index
    int secondUserIndex = usrIndex == 0 ? 1 : 0;


    ///using the above index we grab the second user id from the list
    String secondUser =
    myChats[index].user2.elementAt(secondUserIndex).toString();


    ///calling the method to fetch name and image of the second user






    return FutureBuilder<List<ChatModel.Chat>>(
        future: SecondUserInfo(FirebaseDatabase(
            databaseURL:
            "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
            .reference()
            .child("Users/$secondUser")),
        builder: (context, AsyncSnapshot<List<ChatModel.Chat>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            var indexedInfo;
            if(snapshot.data != null && snapshot.data.length > 0)
              indexedInfo = snapshot.data.elementAt(index);
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
                                child: indexedInfo != null
                                    ? Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(indexedInfo.image)),
                                  ),
                                )
                                    : Container(),
                              ),
                              Expanded(
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          indexedInfo != null
                                              ?  indexedInfo.name
                                              : "",
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


    _streamSubscription = getData().listen((data) {
      if (!mounted) return;
      setState(() {
        ids = data;
      });
    });


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


  // Stream<List<ChatModel.Chat>> getData() async* {
  //   var usersChatsStream = FirebaseDatabase(
  //           databaseURL:
  //               "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
  //       .reference()
  //       .child('UserChats/$currentUserId')
  //       .onValue;
  //
  //   List<ChatModel.Chat> foundChats = [];
  //   List<ChatModel.Chat> _chats = [];
  //
  //   await for (var userChatSnapshot in usersChatsStream) {
  //     foundChats.clear();
  //     _chatIDList.clear();
  //
  //     ///Keep track of chatID
  //     Map dictionary = userChatSnapshot.snapshot.value;
  //     if (dictionary != null) {
  //       for (var dictItem in dictionary.entries) {
  //         ChatModel.Chat thisChat;
  //         if (dictItem.key != null) {
  //           String chatID = dictItem.value;
  //           _chatIDList.add(chatID);
  //
  //           ///option 1
  //           //  Map<Object, Object> obj = (await FirebaseDatabase(databaseURL: "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/").reference().child("Chats/$chatID").once()).value;
  //           // thisChat = ChatModel.Chat.fromJson(oj);
  //           ///option 11
  //           //  getInfo(chatID).listen((event) {
  //           //   _chats =  event;
  //           //  });
  //           ///option 111 Async
  //           FirebaseDatabase(
  //                   databaseURL:
  //                       "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
  //               .reference()
  //               .child("Chats/$chatID")
  //               .onValue
  //               .listen((event) {
  //             thisChat = ChatModel.Chat.fromJson(event.snapshot.value);
  //             print(thisChat.lastMessage);
  //             foundChats.add(thisChat);
  //
  //           });
  //
  //           // FirebaseDatabase(
  //           // databaseURL:
  //           // "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
  //           //     .reference()
  //           //     .child("Chats/$chatID")
  //           //     .once().then((value) => {
  //           // thisChat = ChatModel.Chat.fromJson(value.value),
  //           //     print(thisChat.lastMessage),
  //           // foundChats.add(thisChat),
  //           //   _chats = List.from(foundChats),
  //           //
  //           // });
  //
  //           /// Option 1V Synchronous
  //           // var chatInfoStream = FirebaseDatabase(
  //           //           databaseURL:
  //           //               "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
  //           //       .reference()
  //           //       .child("Chats/$chatID").once().asStream();
  //           //
  //           // await for (var chatInfo in chatInfoStream) {
  //           //   thisChat = ChatModel.Chat.fromJson(chatInfo.value);
  //           //   print(thisChat.lastMessage);
  //           //   foundChats.add(thisChat);
  //           //
  //           // }
  //           // yield foundChats;
  //
  //         } else {
  //           thisChat = ChatModel.Chat();
  //         }
  //
  //         //foundChats= _chats;
  //         //foundChats.add(thisChat);
  //       }
  //     }
  //     print("a");
  //     yield foundChats;
  //   }
  // }


  // Stream<List<ChatModel.Chat>> getInfo(String chatID) async* {
  //   ChatModel.Chat thisChat;
  //   final List<ChatModel.Chat> foundChats = [];
  //   FirebaseDatabase(
  //           databaseURL:
  //               "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
  //       .reference()
  //       .child("Chats/$chatID")
  //       .onValue
  //       .listen((event) {
  //     thisChat = ChatModel.Chat.fromJson(event.snapshot.value);
  //
  //     foundChats.add(thisChat);
  //   });
  //
  //   print(foundChats.length);
  //   yield foundChats;
  // }
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


        //foundChats.add(thisChat);
      });


      // for (var chatInfo in chatInfoStream) {
      //     thisChat = ChatModel.Chat.fromJson(chatInfo.snapshot.value);
      //     print(thisChat.lastMessage);
      //     foundChats.add(thisChat);
      //   }


      FirebaseDatabase(
          databaseURL:
          "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
          .reference()
          .child("Chats/$i")
          .onChildChanged
          .listen((event) {
        if (mounted) {
          setState(() {
            last = event.snapshot.value;
            chaId = i;
          });
        }


        //thisChat = ChatModel.Chat.fromJson(event.snapshot.value);
      });


      yield foundChats;
    }
  }


  Stream<List<String>> getData() async* {
    var usersChatsStream = FirebaseDatabase(
        databaseURL:
        "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
        .reference()
        .child('UserChats/$currentUserId')
        .onValue;


    List<ChatModel.Chat> foundChats = [];
    List<ChatModel.Chat> _chats = [];


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


            ///option 1
            //  Map<Object, Object> obj = (await FirebaseDatabase(databaseURL: "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/").reference().child("Chats/$chatID").once()).value;
            // thisChat = ChatModel.Chat.fromJson(obj);
            ///option 11
            //  getInfo(chatID).listen((event) {
            //   _chats =  event;
            //  });
            ///option 111 Async
            // FirebaseDatabase(
            //     databaseURL:
            //     "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
            //     .reference()
            //     .child("Chats/$chatID")
            //     .onValue
            //     .listen((event) {
            //   thisChat = ChatModel.Chat.fromJson(event.snapshot.value);
            //   print(thisChat.lastMessage);
            //   foundChats.add(thisChat);
            //
            // });


            // FirebaseDatabase(
            // databaseURL:
            // "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
            //     .reference()
            //     .child("Chats/$chatID")
            //     .once().then((value) => {
            // thisChat = ChatModel.Chat.fromJson(value.value),
            //     print(thisChat.lastMessage),
            // foundChats.add(thisChat),
            //   _chats = List.from(foundChats),
            //
            // });


            /// Option 1V Synchronous
            // var chatInfoStream = FirebaseDatabase(
            //           databaseURL:
            //               "https://meet-ceylon-5ec4a.europe-west1.firebasedatabase.app/")
            //       .reference()
            //       .child("Chats/$chatID").once().asStream();
            //
            // await for (var chatInfo in chatInfoStream) {
            //   thisChat = ChatModel.Chat.fromJson(chatInfo.value);
            //   print(thisChat.lastMessage);
            //   foundChats.add(thisChat);
            //
            // }
            // yield foundChats;


          } else {
            chatID = "";
          }
          _chatIDList.add(chatID);
          //foundChats= _chats;
          //foundChats.add(thisChat);
        }
      }
      print(_chatIDList);
      yield _chatIDList;
    }
  }


  @override
  void didUpdateWidget(Chats oldWidget) {
    //   _streamSubscription = getData().listen((data) {
    //     if (!mounted) return;
    //     setState(() {
    //       ids = data;
    //     });
    //   });
    //
    //   _streamSubscription.onData((data) {
    //     print("ddd");
    //     _streamSubscription1 = getInfo(data).listen((data) {
    //       if (!mounted) return;
    //       setState(() {
    //         myChats = data;
    //       });
    //     });
    //   });
  }


  ///
  /// DatabaseReference points to Users node of the DB
  /// fetching second users info
  ///
  Future<List<ChatModel.Chat>> SecondUserInfo(DatabaseReference databaseReference) async {
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
    return secondUsers;
  }
}

