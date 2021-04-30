import 'package:flutter/material.dart';
import 'package:meet_ceylon/page/profile_data/photo_selection.dart';
import 'package:meet_ceylon/page/profile_data/user_preferences.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meet_ceylon/widget/alert_dialog_widget.dart';

class EnableLocation extends StatefulWidget {
  @override
  _EnableLocationState createState() => _EnableLocationState();
}

class _EnableLocationState extends State<EnableLocation> {
  final dateController = TextEditingController();
  String latitude = "";
  String longtitude = "";

  @override
  void initState() {
    super.initState();
  }

  void _getLocation() async {
    try {
      final position = await _determinePosition();
      setState(() {
        latitude = '${position.latitude}';
        longtitude = '${position.longitude}';
      });
    }catch(e){
      print(e.toString());
      _showDialog(context);
      // final snackBar = SnackBar(content: Text(e.toString()));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  }

  _showDialog(BuildContext context)
  {

    VoidCallback continueCallBack = () async => {
      Navigator.of(context).pop(),
      // code on continue comes here
      //await Geolocator.openLocationSettings(),
      await Geolocator.openAppSettings(),
    };
    BlurryDialog  alert = BlurryDialog("Abort","Are you sure you want to abort this operation?",continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
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
                      onTap: () { _getLocation(); latitude != null ? print(' $latitude , $longtitude') : print("no location");   },
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
                                  builder: (context) => new UserPreferences()),
                            );
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(color: Colors.red)
                                  )
                              ),
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
