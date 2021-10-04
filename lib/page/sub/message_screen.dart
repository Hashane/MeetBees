import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:meet_ceylon/constants.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/time_ago.dart';
import 'package:meet_ceylon/widget/messages/body_widget.dart';


class MessagesScreen extends StatelessWidget {
  final String chatID, user2id, thumbUri,name,lastOnline;
  final bool isActive;

  const MessagesScreen({Key key, this.chatID, this.user2id, this.thumbUri, this.name,this.isActive, this.lastOnline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: buildAppBar(context),
      body: Body(chatID: chatID,user2id: user2id, thumbUri: thumbUri,name: name),
    );
  }

  ///Builds the App bar
  AppBar buildAppBar(BuildContext context) {
    String lastOnlineAgo = '';
    DateTime now = DateTime.now();
    ///Extracting time from datetime
    if(lastOnline != null) {
      lastOnlineAgo =   TimeAgo.displayTimeAgoFromTimestamp(lastOnline);
      // DateTime.now().difference(DateTime.parse(lastOnline))
      // final fifteenAgo = new DateTime.now().subtract(new Duration(minutes: 15));
      //
      // print(timeago.format(fifteenAgo));
    }
    return AppBar(
      // automaticallyImplyLeading: false,
      title: Row(
        children: [
          //BackButton(),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryVariant,
            backgroundImage:CachedNetworkImageProvider(thumbUri),
          ),
          SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(width: kDefaultPadding * 0.35),
                  isActive ?  Icon(Icons.circle,color: Colors.green,size: 12,):Container(),
                ],
              ),
              isActive ? Container() :
              lastOnline != null ?
              Text(
                lastOnlineAgo,
                style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 12),
              ):Container(),
            ],
          )
        ],
      ),
      backgroundColor:  Theme.of(context).colorScheme.surface,
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.secondary,
      ),
      actions: [
        // IconButton(
        //   icon: Icon(Icons.more_vert,color: Theme.of(context).colorScheme.secondary,),
        //   onPressed: () {},
        // ),
        Theme(
          data: Theme.of(context).copyWith(
              textTheme: Theme.of(context).textTheme,
              dividerColor: Colors.red,
              iconTheme: IconThemeData(color: Colors.black54)),
          child: PopupMenuButton<int>(
            color: Theme.of(context).colorScheme.surface,
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: Text("Profile")),
              PopupMenuItem<int>(
                  value: 1, child: Text("Report")),
              PopupMenuDivider(),
              PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(
                        Icons.block,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text("End match")
                    ],
                  )),
            ],
            onSelected: (item) => SelectedItem(context, item),
          ),
        ),
      ],
    );
  }
  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        print("Settings");
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => SettingPage()));
        break;
      case 1:
        print("Privacy Clicked");
        break;
      case 2:
        print("User Logged out");
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => LoginPage()),
        //         (route) => false);
        break;
    }
  }
}