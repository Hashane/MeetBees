import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:meet_ceylon/widget/scale_page_route.dart';

import '../test.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Widget kBackBtn = Icon(
    Icons.arrow_back_ios,
    size: 40.0,
  );

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

      body: Padding(
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
                Navigator.push(context,
                    ScaleRoute(page: Screen2()));
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
            Column(
              children: [
                personDetailCard(),
                personDetailCard(),
              ],
            ),
            // children: users.map((p) {
            //   return personDetailCard(p);
            // }).toList(),),
          ],
        ),
      ),
      //bottomNavigationBar: showModalBottomSheet();
    );
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

  Widget personDetailCard() {
    return Card(
      elevation: 5,
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Material(color:Colors.transparent,child: InkWell(child:
      Row(
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
      )
        , onTap: (){Navigator.push(context,
            ScaleRoute(page: Screen2()));},),)
    );
  }
}
