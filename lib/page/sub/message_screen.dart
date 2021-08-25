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
        IconButton(
          icon: Icon(Icons.more_vert,color: Theme.of(context).colorScheme.secondary,),
          onPressed: () {},
        ),
      ],
    );
  }
}