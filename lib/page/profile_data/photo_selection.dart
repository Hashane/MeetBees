import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:image_picker/image_picker.dart';

import 'enable_location.dart';

class PhotoSelection extends StatefulWidget {
  @override
  _PhotoSelectionState createState() => _PhotoSelectionState();
}

class _PhotoSelectionState extends State<PhotoSelection> {
  PickedFile _imageFile1;
  PickedFile _imageFile2;
  PickedFile _imageFile3;
  PickedFile _imageFile4;
  PickedFile _imageFile5;
  PickedFile _imageFile6;
  final ImagePicker _picker = ImagePicker();
  int _gestureIndex = 0;

  Future _getImage(int index) async {
    try {
      final pickedImage = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        if (_gestureIndex == 1) {
          _imageFile1 = pickedImage;
        } else if (_gestureIndex == 2) {
          _imageFile2 = pickedImage;
        } else if (_gestureIndex == 3) {
          _imageFile3 = pickedImage;
        } else if (_gestureIndex == 4) {
          _imageFile4 = pickedImage;
        } else if (_gestureIndex == 5) {
          _imageFile5 = pickedImage;
        } else if (_gestureIndex == 6) {
          _imageFile6 = pickedImage;
        }
      });
    } catch (e) {
      print(e.toString());
    }
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
          child: SafeArea(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               SizedBox(
                    height:
                        SizeConfig.safeBlockVertical * 20.0, //10 for example
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
                    'Add atleast 3 photos to continue. You can change these later.',
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
              Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.all(5),
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: 3,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.5),
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _gestureIndex = 1;
                            });
                            _getImage(_gestureIndex);
                          },
                          child: Container(
                            color: Colors.black12,
                            child: _imageFile1 == null
                                ? new Icon(Icons.add,
                                    size: 16.0, color: Colors.white)
                                : Image.file(
                                    File(_imageFile1.path),
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _gestureIndex = 2;
                            });
                            _getImage(_gestureIndex);
                          },
                          child: Container(
                            color: Colors.black12,
                            child: _imageFile2 == null
                                ? new Icon(Icons.add,
                                    size: 16.0, color: Colors.white)
                                : Image.file(
                                    File(_imageFile2.path),
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _gestureIndex = 3;
                            });
                            _getImage(_gestureIndex);
                          },
                          child: Container(
                            color: Colors.black12,
                            child: _imageFile3 == null
                                ? new Icon(Icons.add,
                                    size: 16.0, color: Colors.white)
                                : Image.file(
                                    File(_imageFile3.path),
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _gestureIndex = 4;
                            });
                            _getImage(_gestureIndex);
                          },
                          child: Container(
                            color: Colors.black12,
                            child: _imageFile4 == null
                                ? new Icon(Icons.add,
                                    size: 16.0, color: Colors.white)
                                : Image.file(
                                    File(_imageFile4.path),
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _gestureIndex = 5;
                            });
                            _getImage(_gestureIndex);
                          },
                          child: Container(
                            color: Colors.black12,
                            child: _imageFile5 == null
                                ? new Icon(Icons.add,
                                    size: 16.0, color: Colors.white)
                                : Image.file(
                                    File(_imageFile5.path),
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _gestureIndex = 6;
                            });
                            _getImage(_gestureIndex);
                          },
                          child: Container(
                            color: Colors.black12,
                            child: _imageFile6 == null
                                ? new Icon(Icons.add,
                                    size: 16.0, color: Colors.white)
                                : Image.file(
                                    File(_imageFile6.path),
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                                builder: (context) => new EnableLocation()),
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
