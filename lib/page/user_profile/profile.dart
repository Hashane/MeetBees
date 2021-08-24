import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:meet_ceylon/widget/active_perks_card_widget.dart';
import 'package:meet_ceylon/widget/elevated_dark_btn.dart';

class UserProfile extends StatefulWidget {
  final Function onNav;

  const UserProfile({Key key, this.onNav}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("Profile", style: Theme.of(context).textTheme.headline4),
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: widget.onNav),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.secondary,
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: userCard(),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            Text('Jude Hashane, 26',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.normal, fontSize: 15)),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            ElevatedDarkButton(
              child: Text("Edit my profile"),
              width: SizeConfig.safeBlockHorizontal * 70,
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            Text('Active packages',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.normal, fontSize: 15)),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 1,
            ),
            ActivePlanCard(context),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ActivePerksCards(
                      icon: Icon(
                        Icons.local_fire_department,
                        color: Theme.of(context).colorScheme.primaryVariant,
                        size: 40.0,
                      ),
                      text: Text(
                        "4",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      width: SizeConfig.safeBlockHorizontal * 23,
                      height: SizeConfig.safeBlockVertical * 14,
                      onPressed: null),
                  ActivePerksCards(
                      icon: Icon(
                        Icons.star,
                        color: Theme.of(context).colorScheme.primaryVariant,
                        size: 40.0,
                      ),
                      text: Text(
                        "2",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      width: SizeConfig.safeBlockHorizontal * 23,
                      height: SizeConfig.safeBlockVertical * 14,
                      onPressed: null),
                ]),
          ],
        ),
      ),
    );
  }

  ///Navigating to settings screen
  // void onPressed() {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  // }
}

Widget ActivePlanCard(BuildContext context) {
  return SizedBox(
    width: SizeConfig.safeBlockHorizontal * 70,
    height: SizeConfig.safeBlockVertical * 10,
    child: Card(
      elevation: 8,
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text("Weekly 5.60\$",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.only(
                bottomRight: const Radius.circular(12.0),
                bottomLeft: const Radius.circular(12.0),
              ),
            ),
            child: Center(
              child: Text("Cancel anytime in app store",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.bold,fontSize: 11,color: Theme.of(context).colorScheme.primaryVariant)),
            ),
          ),
        ],
      ),
    ),
  );
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
