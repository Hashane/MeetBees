import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_ceylon/model/user.dart';
import 'package:meet_ceylon/page/user_profile/edit_profile_screen.dart';
import 'package:meet_ceylon/provider/database.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:meet_ceylon/widget/active_perks_card_widget.dart';
import 'package:meet_ceylon/widget/buttons_and_labels/elevated_dark_btn.dart';
import 'package:meet_ceylon/widget/custom_widget.dart';

class UserProfile extends StatefulWidget {
  final Function onNav;
  final Function onFilterNav;

  const UserProfile({Key key, this.onNav, this.onFilterNav}) : super(key: key);

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
        leading: IconButton(
            icon: Icon(Icons.settings_input_component),
            onPressed: widget.onFilterNav),
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.secondary,
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: FutureBuilder<User>(
            future: Database.getUserInfo(), // async work
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (!snapshot.hasData) {
                // show loading while waiting for real data
                return shimmerProfileLayout();
              }
              User userData = snapshot.data;
              return profileLayout(userData);

            }),
      ),
    );
  }

  Widget profileLayout(User userData){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(
          child: userCard(userData),
        ),
        // SizedBox(
        //   height: SizeConfig.safeBlockVertical * 2,
        // ),
        Text(
            toBeginningOfSentenceCase(userData.name) +
                ", " +
                calBday(userData.birthday.toString()),
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontWeight: FontWeight.normal, fontSize: 15)),
        // SizedBox(
        //   height: SizeConfig.safeBlockVertical * 2,
        // ),
        ElevatedDarkButton(
          child: Text("Edit my profile"),
          width: SizeConfig.safeBlockHorizontal * 70,
          onPressed: onEditPressed,
        ),
        // SizedBox(
        //   height: SizeConfig.safeBlockVertical * 2,
        // ),
        Text('Active packages',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontWeight: FontWeight.normal, fontSize: 15)),
        // SizedBox(
        //   height: SizeConfig.safeBlockVertical * 1,
        // ),
        ActivePlanCard(context),
        // SizedBox(
        //   height: SizeConfig.safeBlockVertical * 2,
        // ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment: CrossAxisAlignment.,
            children: [
              ActivePerksCards(
                  icon: Icon(
                    Icons.local_fire_department,
                    color:
                    Theme.of(context).colorScheme.primaryVariant,
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
                    color:
                    Theme.of(context).colorScheme.primaryVariant,
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
    );
  }

  ///Shimmer effect on the whole layout
  Widget shimmerProfileLayout(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(
          child: shimmerUserCard(),
        ),
        // SizedBox(
        //   height: SizeConfig.safeBlockVertical * 2,
        // ),
        CustomWidget.rectangular(height: 10, width: MediaQuery.of(context).size.width*0.3),
        // SizedBox(
        //   height: SizeConfig.safeBlockVertical * 2,
        // ),
        CustomWidget.rectangular(width: SizeConfig.safeBlockHorizontal * 70,),
        // SizedBox(
        //   height: SizeConfig.safeBlockVertical * 2,
        // ),
        CustomWidget.rectangular(height: 10, width: MediaQuery.of(context).size.width*0.3),
        // SizedBox(
        //   height: SizeConfig.safeBlockVertical * 1,
        // ),
        CustomWidget.rectangular( width: SizeConfig.safeBlockHorizontal * 70,
          height: SizeConfig.safeBlockVertical * 10,),
        // SizedBox(
        //   height: SizeConfig.safeBlockVertical * 2,
        // ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomWidget.rectangular(width: SizeConfig.safeBlockHorizontal * 23, height: SizeConfig.safeBlockVertical * 14,),
              CustomWidget.rectangular(width: SizeConfig.safeBlockHorizontal * 23, height: SizeConfig.safeBlockVertical * 14,),
            ]),
      ],
    );
  }

  ///Shimmer effect on the user image card
  Widget shimmerUserCard() {
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

  ///Calculates age from the birthdate
  String calBday(String db) {
    String _birthDate = db;
    String datePattern = "yyyy-MM-dd";
    DateTime birthDate = DateFormat(datePattern).parse(_birthDate);
    DateTime today = DateTime.now();

    String yearDiff = (today.year - birthDate.year).toString();
    return yearDiff;
  }

  ///Navigating to Edit profile
  void onEditPressed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditProfile()));
  }

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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.primaryVariant)),
            ),
          ),
        ],
      ),
    ),
  );
}
Widget userCard(User user) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.all(new Radius.circular(20)),
      //side: BorderSide(width: 5, color: Colors.green)
    ),
    child: Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: user.imageUris[0],
            fit: BoxFit.cover,
            imageBuilder: (context, imageProvider) => Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(20)),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
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


