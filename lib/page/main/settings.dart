import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:meet_ceylon/widget/elevated_gradient_btn.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("Settings",style: Theme.of(context).textTheme.headline5),
        backgroundColor:  Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                elevation: 6,
                //margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                color: Theme.of(context).colorScheme.surface,
                child: ListTile(
                  title: Text("Account Info"),
                  leading: Icon(Icons.person),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              Card(
                elevation: 6,
                //  margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                color: Theme.of(context).colorScheme.surface,
                child: ListTile(
                  title: Text("Notification"),
                  leading: Icon(Icons.notifications),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              Card(
                elevation: 6,
                // margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                color: Theme.of(context).colorScheme.surface,
                child: ListTile(
                  title: Text("Security"),
                  leading: Icon(Icons.shield),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              Card(
                elevation: 6,
                // margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                color: Theme.of(context).colorScheme.surface,
                child: ListTile(
                  title: Text("Subscriptions"),
                  leading: Icon(Icons.credit_card),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              Card(
                elevation: 6,
                //margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                color: Theme.of(context).colorScheme.surface,
                child: ListTile(
                  title: Text("Events"),
                  leading: Icon(Icons.calendar_today),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              Card(
                elevation: 6,
                //margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                color: Theme.of(context).colorScheme.surface,
                child: ListTile(
                  title: Text("Company info"),
                  leading: Icon(Icons.favorite_border_rounded),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 2,
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 6,
                width: SizeConfig.safeBlockHorizontal * 60,
                child: Card(
                  elevation: 6,
                  //  margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  color: Theme.of(context).colorScheme.onSurface,
                  child: Center(
                    child: Text(
                      "Community guidelines",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 14.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 1,
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 6,
                width: SizeConfig.safeBlockHorizontal * 60,
                child: Card(
                  elevation: 6,
                  //margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  color: Theme.of(context).colorScheme.onSurface,
                  child: Center(
                    child: Text(
                      "Terms of services",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 14.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 1,
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 6,
                width: SizeConfig.safeBlockHorizontal * 60,
                child: Card(
                  elevation: 6,
                  // margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  color: Theme.of(context).colorScheme.onSurface,
                  child: Center(
                    child: Text(
                      "Privary policy",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 14.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 5,
              ),
              ElevatedGradientButton(
                child: Text("Test"),
                width: SizeConfig.safeBlockHorizontal * 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
