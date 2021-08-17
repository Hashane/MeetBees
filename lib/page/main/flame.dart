import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:meet_ceylon/widget/app_bar_widget.dart';
import 'package:meet_ceylon/widget/premium_plans_widget.dart';

class Flames extends StatefulWidget {
  @override
  _FlamesState createState() => _FlamesState();
}

class _FlamesState extends State<Flames> {
  double percent = 20.0;

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
      backgroundColor: Colors.grey[200],
      appBar: CustomAppBar(title: "Flames", child: kBackBtn, onPressed: null),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeConfig.safeBlockVertical * 5,
            ),
            LinearProgressIndicator(
              value: percent / 100,
              semanticsLabel: 'Linear progress indicator',
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
              height: SizeConfig.safeBlockVertical * 1,
            ),
            premiumPlansContentCustom(context),
          ],
        ),
      ),
      //bottomNavigationBar: showModalBottomSheet();
    );
  }

  Widget premiumPlansContentCustom(context) {
    SizeConfig().init(context);
    return Stack(
      alignment: Alignment.topCenter,
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.safeBlockVertical * 5),
            Text(
              'Buy more',
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'Lobster',
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            SizedBox(height: SizeConfig.safeBlockVertical * 2),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 170,
                    decoration: new BoxDecoration(
                      border: Border.all(width: 2, color: Colors.deepOrange),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 170,
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
            Center(
              child: Container(
                width: SizeConfig.safeBlockHorizontal * 40,
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
                child:
                    Center(child: Text(
                      "Flame it!",
                      style: TextStyle(
                          color: Colors.black, fontStyle: FontStyle.normal),
                    ), ),
              ),
              // DecoratedBox(
              //   decoration: new BoxDecoration(
              //     border: Border.all(color: Colors.transparent),
              //     borderRadius: BorderRadius.circular(10),
              //     gradient: LinearGradient(
              //       stops: [0.0, 1.0],
              //       begin: FractionalOffset.centerLeft,
              //       end: FractionalOffset.centerRight,
              //       colors: <Color>[
              //         Colors.orangeAccent,
              //         Colors.deepOrange,
              //       ],
              //     ),
              //   ),
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     style: ButtonStyle(
              //       minimumSize: MaterialStateProperty.all(Size(
              //           SizeConfig.safeBlockHorizontal * 45,
              //           SizeConfig.safeBlockVertical * 5)),
              //       shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),),
              //     child: Text('Flame it'),
              //   ),
              // ),
            ),
          ],
        ),
      ],
    );
  }
}
