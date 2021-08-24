import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:meet_ceylon/widget/premium_plans_widget.dart';

class Flames extends StatefulWidget {
  @override
  _FlamesState createState() => _FlamesState();
}

class _FlamesState extends State<Flames> {
  double percent = 100.0;

  @override
  void initState() {
    Timer timer;
    timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      print('Percent Update');
      if (this.mounted) {
        setState(() {
          percent -= 1;
          if (percent <= 0) {
            timer.cancel();
            // percent=0;
          }
        });
      }
    });
    super.initState();
  }

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
        title: Text("Flames", style: Theme.of(context).textTheme.headline5),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: SizeConfig.safeBlockVertical * 5,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  value: percent / 100,
                  minHeight: 10,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                  backgroundColor: Color(0xffD6D6D6),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "(" + percent.toString() + " minutes remaining)",
                style: TextStyle(fontSize: 12.0, color: Colors.black38),
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 5,
            ),
            Center(
              child: Container(
                width: SizeConfig.safeBlockHorizontal * 80,
                height: SizeConfig.safeBlockVertical * 20,
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
                    SizedBox(height: SizeConfig.safeBlockVertical * 1),
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    SizedBox(height: SizeConfig.safeBlockVertical * 1),
                    Text(
                      "5",
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.normal),
                    ),
                    SizedBox(height: SizeConfig.safeBlockVertical * 1),
                    Text(
                      "Remaining",
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.normal),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 1,
            ),
            premiumPlansContentCustom(context),
          ],
        ),
      ),
    );
  }

  Widget premiumPlansContentCustom(context) {
    SizeConfig().init(context);
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.safeBlockVertical * 5),
            Text(
              'Buy more',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            SizedBox(height: SizeConfig.safeBlockVertical * 2),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 110,
                    height: 130,
                    decoration: new BoxDecoration(
                      border: Border.all(width: 2, color: Colors.deepOrange),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    width: 110,
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
            SizedBox(height: SizeConfig.safeBlockVertical * 2),
            InkWell(
              onTap: () {},
              child: Center(
                child: Container(
                  width: SizeConfig.safeBlockHorizontal * 80,
                  height: SizeConfig.safeBlockVertical * 5,
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
                  child: Center(
                    child: Text(
                      "Flame it!",
                      style: TextStyle(
                          color: Colors.black, fontStyle: FontStyle.normal),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
