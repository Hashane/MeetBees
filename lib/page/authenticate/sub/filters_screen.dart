import 'package:flutter/material.dart';
import 'package:meet_ceylon/model/gender.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:meet_ceylon/widget/active_perks_card_widget.dart';
import 'package:meet_ceylon/widget/radio_btn_tiles_widget.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<Gender> genders = [];
  @override
  void initState() {
    super.initState();
    genders.add(new Gender("Male", Icons.person, false));
    genders.add(new Gender("Female",  Icons.person, false));
    genders.add(new Gender("Others",  Icons.person, false));
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("Filters", style: Theme.of(context).textTheme.headline4),
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.secondary,
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
                  title: Text("Interested in"),
                ),
              ),
              SizedBox( height: 100, child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: genders.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: Colors.pinkAccent,
                      onTap: () {
                        setState(() {
                          genders.forEach((gender) => gender.isSelected = false);
                          genders[index].isSelected = true;
                        });
                      },
                      child: CustomRadio(genders[index]),
                    );
                  }),),
              // Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Expanded(child:
              //       ActivePerksCards(
              //           text: Text(
              //             "Male",
              //             style: Theme.of(context)
              //                 .textTheme
              //                 .bodyText1
              //                 .copyWith(fontWeight: FontWeight.bold),
              //           ),
              //           width: SizeConfig.safeBlockHorizontal * 23,
              //           height: SizeConfig.safeBlockVertical * 14,
              //           onPressed: null),),
              //       Expanded(child:
              //       ActivePerksCards(
              //           text: Text(
              //             "Female",
              //             style: Theme.of(context).textTheme
              //                 .bodyText1
              //                 .copyWith(fontWeight: FontWeight.bold),
              //           ),
              //           width: SizeConfig.safeBlockHorizontal * 23,
              //           height: SizeConfig.safeBlockVertical * 14,
              //           onPressed: null),),
              //     ]),

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
            ],
          ),
        ),
      ),
    );
  }
}
