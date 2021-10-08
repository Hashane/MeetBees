import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meet_ceylon/data/package_descriptions.dart';
import 'package:meet_ceylon/services/size_configurations.dart';

Widget premiumPlansContent(context) {
  SizeConfig().init(context);
  return Stack(
    alignment: Alignment.topCenter,
    // crossAxisAlignment: CrossAxisAlignment.start,
    // mainAxisSize: MainAxisSize.min,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: SizeConfig.safeBlockVertical * 5),
          Text(
            'Plans',
            style: Theme.of(context).textTheme.headline2,
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              enableInfiniteScroll: true,
              aspectRatio: 20.0,
              viewportFraction: 20.0,
              enlargeCenterPage: false,
            ),
            items: packageDescriptions.map((card) {
              return Builder(builder: (BuildContext context) {
                return Text(
                  card.toString(),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 14),
                );
              });
            }).toList(),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 170,
                  decoration: new BoxDecoration(
                    border: Border.all(),
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
                ),
                Container(
                  width: 120,
                  height: 170,
                  decoration: new BoxDecoration(
                    border: Border.all(),
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
          SizedBox(height: SizeConfig.safeBlockVertical * 1),
          Text(
            'Recurring bill, cancel anytime',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 0.2),
          RichText(
            text: TextSpan(
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
              children: <TextSpan>[
                TextSpan(
                    text: 'Terms of Service',
                    style: Theme.of(context).textTheme.bodyText2,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('Terms of Service"');
                      }),
                TextSpan(text: ' and ',style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Colors.grey),),
                TextSpan(
                    text: 'Privacy Policy',
                    style: Theme.of(context).textTheme.bodyText2,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('Privacy Policy"');
                      }),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 1),
          OutlinedButton(
            onPressed: null,
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(
                  SizeConfig.safeBlockHorizontal * 45,
                  SizeConfig.safeBlockVertical * 5)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.black45),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0))),
            ),
            child: Text(
              'Continue',
              style:
                  Theme.of(context).textTheme.headline2.copyWith(fontSize: 20),
            ),
          ),
        ],
      ),
    ],
  );
}
