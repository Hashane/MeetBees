import 'package:flutter/material.dart';
import 'package:meet_ceylon/page/profile_data/photo_selection.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';

class PersonalInfo extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                      'Fill your personal information',
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
                      'We only show your age to potential matches',
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
                Material(
                  elevation: 20.0,
                  shadowColor: Colors.blue,
                  child: TextFormField(
                    autofocus: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        hintText: 'Name',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                BorderSide(color: Colors.white, width: 3.0))),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 5,
                ),
                Material(
                  elevation: 20.0,
                  shadowColor: Colors.blue,
                  child: TextFormField(
                    keyboardType: TextInputType.datetime,
                    autofocus: false,
                    readOnly: true,
                    controller: dateController,
                    decoration: InputDecoration(
                        hintText: 'Birthday',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                BorderSide(color: Colors.white, width: 3.0))),
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      dateController.text = date.toString().substring(0, 10);
                    },
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 5,
                ),
                Container(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    border: Border.all(color: Colors.transparent, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: ToggleButtons(
                    color: Colors.black,
                    selectedColor: Colors.red,
                    fillColor: Colors.black12,
                    children: <Widget>[
                      Container(
                          width: (SizeConfig.screenWidth) / 3,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Icon(
                                Icons.person,
                                size: 16.0,
                                color: Colors.white,
                              ),
                              new SizedBox(
                                width: 4.0,
                              ),
                              new Text(
                                "Male",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          )),
                      Container(
                          width: (SizeConfig.screenWidth) / 3,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Icon(
                                Icons.whatshot,
                                size: 16.0,
                                color: Colors.white,
                              ),
                              new SizedBox(
                                width: 4.0,
                              ),
                              new Text(
                                "Female",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          )),
                    ],
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < _selection.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            _selection[buttonIndex] = true;
                          } else {
                            _selection[buttonIndex] = false;
                          }
                        }
                      });
                    },
                    isSelected: _selection,
                  ),
                ),

                Expanded(
                    child: Align(
                  alignment: Alignment.bottomCenter,
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
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shadowColor:
                                MaterialStateProperty.all<Color>(Colors.grey)),
                      ),
                    ),
                  ),
                )), //Expanded(child: Container(),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
