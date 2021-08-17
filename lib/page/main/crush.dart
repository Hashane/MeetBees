import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/data/preferences.dart';
import 'package:meet_ceylon/model/preference.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:meet_ceylon/widget/app_bar_widget.dart';

class Crush extends StatefulWidget {
  @override
  _CrushState createState() => _CrushState();
}

Widget kBackBtn = Icon(
  Icons.arrow_back_ios,
  size: 40.0,
);

//carousel
int _currentIndex = 0;

class _CrushState extends State<Crush> {
  @override
  Widget build(BuildContext context) {
    List cardsList = [
      CrushesList(),
      CrushesList(), CrushesList(),
      CrushesList(),
    ];
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: CustomAppBar(title: "Crush", child: kBackBtn, onPressed: null),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.star,
                  ),
                  Text(
                    1.toString() +"(Remaining)",
                    style: TextStyle(
                        color: Colors.white, fontStyle: FontStyle.normal),
                  ),
                ],
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                aspectRatio: 1.0,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: cardsList.map((card) {
                return Builder(builder: (BuildContext context) {
                  return card;
                });
              }).toList(),
            ),
            Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: cardsList.asMap().entries.map((e) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == e.key ? Colors.deepOrange : Color.fromRGBO(0, 0, 0, 0.4)
                      ),
                    );
                  }).toList(),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Buy more',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            SizedBox(height: SizeConfig.safeBlockVertical * 1),
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
            SizedBox(height: SizeConfig.safeBlockVertical * 1),
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

class CrushesList extends StatefulWidget {
  @override
  _CrushesListState createState() => _CrushesListState();
}

class _CrushesListState extends State<CrushesList> {
  @override
  Widget build(BuildContext context) {
    final List<Preference> _preferences = preferencesList;
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.all(5),
            crossAxisSpacing: 10,
            mainAxisSpacing: 3,
            crossAxisCount: 2,
            childAspectRatio: (2 / 2),
            children: List.generate(
              4,
              (index) {
                itemCount:
                _preferences.length;
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.all(new Radius.circular(4)),
                    //side: BorderSide(width: 5, color: Colors.green)
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(4)),
                            image: DecorationImage(
                              image: new AssetImage(
                                  _preferences[index].imgUrl.toString()),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.8),
                                  BlendMode.dstATop),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
