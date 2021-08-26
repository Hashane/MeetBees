import 'package:meet_ceylon/constants.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/widget/messages/body_widget.dart';


class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: buildAppBar(context),
      body: Body(),
    );
  }

  ///Builds the App bar
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      // automaticallyImplyLeading: false,
      title: Row(
        children: [
          //BackButton(),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryVariant,
            backgroundImage:NetworkImage(
                "https://i.stack.imgur.com/NiBMY.png?s=420&g=1"),
          ),
          SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hashane",
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                "Active 3m ago",
                style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 12),
              )
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