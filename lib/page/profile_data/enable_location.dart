import 'package:flutter/material.dart';
import 'package:meet_ceylon/page/profile_data/photo_selection.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';

class EnableLocation extends StatefulWidget {
  @override
  _EnableLocationState createState() => _EnableLocationState();
}

class _EnableLocationState extends State<EnableLocation> {
  final dateController = TextEditingController();

  List<bool> _selection = List.generate(2, (index) => false);

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 50),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 20.0, //10 for example
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  child: Center(
                    child: Text(
                      'Turn on Location',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 5,
                ),
                Container(
                  child: Center(
                    child: Text(
                      'You will need to enable location in order to use the app',
                      style: TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Colors.black,
                          fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 5,
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset("assets/images/logo.png",
                              width: 150.0, height: 150.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 5,
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: SizedBox(
                      height: SizeConfig.safeBlockVertical * 7, //10 for example
                      width:
                          SizeConfig.safeBlockHorizontal * 100, //10 for example
                      child: Container(
                        decoration: new BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 25.0, // soften the shadow
                              spreadRadius: 2.0, //extend the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                10.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          child: Text("Continue"),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new PhotoSelection()),
                            );
                          },
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black54),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.grey)),
                        ),
                      ),
                    ),
                  ),
                ),
                // Expanded(child: Container(),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
