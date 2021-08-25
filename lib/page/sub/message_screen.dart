import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: buildAppBar(context),
      body: Container(),
    );
  }
}

buildAppBar(BuildContext context) {
  return AppBar(
    title: Row(
      children: [
        ///Todo add to git wiki - used for backbutton
        //BackButton(),
        CircleAvatar(
          backgroundImage:
              NetworkImage("https://i.stack.imgur.com/NiBMY.png?s=420&g=1"),
        ),
        SizedBox(width: SizeConfig.safeBlockHorizontal * 0.75),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kristin Watson",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            // Text(
            //   "Active 3m ago",
            //   style: TextStyle(fontSize: 12),
            // )
          ],
        )
      ],
    ),
    backgroundColor: Theme.of(context).colorScheme.surface,
    iconTheme: IconThemeData(
      color: Theme.of(context).colorScheme.secondary,
    ),
    actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),],
    elevation: 0,
  );
}
