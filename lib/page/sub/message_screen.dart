import 'package:meet_ceylon/constants.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/widget/messages/body_widget.dart';


class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Body(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      // automaticallyImplyLeading: false,
      title: Row(
        children: [
          //BackButton(),
          CircleAvatar(
            backgroundColor: Colors.transparent,
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
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert,color: Theme.of(context).colorScheme.secondary,),
          onPressed: () {},
        ),
      ],
    );
    return AppBar(
     // automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Row(
        children: [
          //BackButton(),
          CircleAvatar(
            backgroundImage:NetworkImage(
                "https://i.stack.imgur.com/NiBMY.png?s=420&g=1"),
          ),
          SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hashane",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Active 3m ago",
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert,color: Theme.of(context).colorScheme.secondary,),
          onPressed: () {},
        ),
      ],
    );
  }
}