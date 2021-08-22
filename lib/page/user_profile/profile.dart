import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:meet_ceylon/widget/app_bar_widget.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

Widget _backBtn = Icon(
  Icons.arrow_back_ios,
  size: 40.0,
);

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: CustomAppBar(title: "Profile", child: _backBtn, onPressed: null),
      body:
      Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: userCard(),
          ),
          Text('Jude Hashane, 26',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.normal, fontSize: 15)),
          SizedBox(
            height: 40,
            width: 250,
            child: TextButton(
                child: Text("Edit my profile".toUpperCase(),
                    style: TextStyle(fontSize: 14)),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(15)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)))),
                onPressed: () => null),
          ),
          Text('Active packages',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.normal, fontSize: 15)),
          Container(
            width: SizeConfig.safeBlockHorizontal * 70,
            height: SizeConfig.safeBlockVertical * 10,
            decoration: new BoxDecoration(
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                stops: [0.0, 1.0],
                begin: FractionalOffset.centerLeft,
                end: FractionalOffset.centerRight,
                colors: <Color>[
                  Colors.orangeAccent,
                  Colors.deepOrange,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: SizeConfig.safeBlockVertical * 1),
                Text(
                  "Use flames to get more matches",
                  style: TextStyle(
                      color: Colors.white, fontStyle: FontStyle.normal),
                ),

                Text(
                  "Remaining",
                  style: TextStyle(
                      color: Colors.white, fontStyle: FontStyle.normal),
                ),
              ],
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 130,
                  decoration: new BoxDecoration(
                    border: Border.all(width: 2, color: Colors.deepOrange),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  width: 100,
                  height: 130,
                  decoration: new BoxDecoration(
                    border: Border.all(width: 2, color: Colors.deepOrange),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRect(
                    child: Banner(
                      message: "Save 50%",
                      location: BannerLocation.topEnd,
                      color: Colors.red,
                      child: Container(
                        child: Center(
                          child: Text("premium"),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ],
      ),),
    );
  }
}

Widget userCard() {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.all(new Radius.circular(20)),
      //side: BorderSide(width: 5, color: Colors.green)
    ),
    child: Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(20)),
              image: DecorationImage(
                image: NetworkImage(
                    "https://i.stack.imgur.com/NiBMY.png?s=420&g=1"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.8), BlendMode.dstATop),
              ),
            ),
          ),
        ),
        ClipRect(
          // <-- clips to the 200x200 [Container] below
          child: Container(
            alignment: Alignment.center,
            width: 140.0,
            height: 220.0,
          ),
        ),
      ],
    ),
  );
}
