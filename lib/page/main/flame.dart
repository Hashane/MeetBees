import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meet_ceylon/services/size_configurations.dart';
import 'package:meet_ceylon/widget/buttons_and_labels/elevated_gradient_btn.dart';

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
      //print('Percent Update');
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    child: LinearProgressIndicator(
                      value: percent / 100,
                      minHeight: 8,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                      backgroundColor: Color(0xffD6D6D6),
                    ),
                  ),
                  Text(
                    "(" + percent.toString() + " minutes remaining)",
                    style: TextStyle(fontSize: 12.0, color: Colors.black38),
                  ),
                ],
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child:
            // ),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 7), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Use flames to get more matches",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .apply(color: Colors.black),
                    ),
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    Text(
                      "5",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .apply(color: Colors.black),
                    ),
                    Text(
                      "Remaining",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .apply(color: Colors.black45),
                    ),
                  ],
                ),
              ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Buy more',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            SizedBox(height: SizeConfig.safeBlockVertical * 2),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ///2 flames package
              SizedBox(
                width: 110,
                height: 130,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.deepOrangeAccent.shade100,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: SizeConfig.safeBlockVertical * 1),
                      Text(
                        "2 Flames",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .apply(color: Colors.black),
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 1),
                      Icon(
                        Icons.local_fire_department,
                        color: Colors.deepOrangeAccent,
                        size: 40.0,
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 1),
                      Text(
                        "\$ 5.45",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .apply(color: Colors.black),
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 1),
                    ],
                  ),
                ),
              ),

              ///5 flames package
              SizedBox(
                width: 110,
                height: 130,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.deepOrangeAccent.shade100,
                      width: 1.0,
                    ),
                  ),
                  child: ClipRect(
                    child: Banner(
                      message: "Save 50%",
                      location: BannerLocation.topEnd,
                      color: Colors.deepOrangeAccent.withOpacity(0.6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: SizeConfig.safeBlockVertical * 1),
                          Text(
                            "5 Flames",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .apply(color: Colors.black),
                          ),
                          SizedBox(height: SizeConfig.safeBlockVertical * 1),
                          Icon(
                            Icons.local_fire_department,
                            color: Colors.deepOrangeAccent,
                            size: 40.0,
                          ),
                          SizedBox(height: SizeConfig.safeBlockVertical * 1),
                          Text(
                            "\$ 10.90",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .apply(color: Colors.black),
                          ),
                          SizedBox(height: SizeConfig.safeBlockVertical * 1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox(height: SizeConfig.safeBlockVertical * 2),
            ElevatedGradientButton(
              child: Text(
                "Flame it !",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .apply(color: Colors.black, fontSizeDelta: 2),
              ),
              width: SizeConfig.safeBlockHorizontal * 80,
              onPressed: () {
                print("asasa");
              },
            ),
          ],
        ),
      ],
    );
  }
}
