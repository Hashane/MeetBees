import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:meet_ceylon/widget/buttons_and_labels/elevated_dark_btn.dart';
import 'package:meet_ceylon/widget/buttons_and_labels/elevated_gradient_btn.dart';
import 'package:meet_ceylon/widget/buttons_and_labels/regular_white_btn.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'dart:ui';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  ///image picker related
  PickedFile _imageFile1;
  PickedFile _imageFile2;
  PickedFile _imageFile3;
  PickedFile _imageFile4;
  PickedFile _imageFile5;
  PickedFile _imageFile6;

  final ImagePicker _picker = ImagePicker();
  int _gestureIndex = 0;
  List<String> _photoList = [];
  List<String> _urlList = [];

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

        if (pickedImage != null) {
          _photoList.add(pickedImage.path.toString());
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title:
            Text("Edit profile", style: Theme.of(context).textTheme.headline4),
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
                      //Invokes _getImage function only if the _imageFile is null.
                      if (_imageFile1 == null) _getImage(_gestureIndex);
                    },
                    child: Card(
                      ///This is the empty thumbnail container for the images
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      elevation: 8,
                      //Parses int value to detect which image to remove when tapped on remove icon
                      child: _imageFile1 != null
                          ? imageArea(_imageFile1, 1)
                          : plusIcon(context),

                      ///context is used to access theme colors
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _gestureIndex = 2;
                      });
                      //Invokes _getImage function only if the _imageFile is null.
                      //Disallow image selection until previous placeholder is filled.
                      if (_imageFile1 != null && _imageFile2 == null)
                        _getImage(_gestureIndex);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      elevation: 8,
                      //Parses int value to detect which image to remove when tapped on remove icon
                      child: _imageFile2 != null
                          ? imageArea(_imageFile2, 2)
                          : plusIcon(context),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _gestureIndex = 3;
                      });
                      //Invokes _getImage function only if the _imageFile is null.
                      //Disallow image selection until previous placeholder is filled.
                      if (_imageFile1 != null &&
                          _imageFile2 != null &&
                          _imageFile3 == null) _getImage(_gestureIndex);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      elevation: 8,
                      //Parses int value to detect which image to remove when tapped on remove icon
                      child: _imageFile3 != null
                          ? imageArea(_imageFile3, 3)
                          : plusIcon(context),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _gestureIndex = 4;
                      });
                      //Invokes _getImage function only if the _imageFile is null.
                      //Disallow image selection until previous placeholder is filled.
                      if (_imageFile1 != null &&
                          _imageFile2 != null &&
                          _imageFile3 != null &&
                          _imageFile4 == null) _getImage(_gestureIndex);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      elevation: 8,
                      //Parses int value to detect which image to remove when tapped on remove icon
                      child: _imageFile4 != null
                          ? imageArea(_imageFile4, 4)
                          : plusIcon(context),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _gestureIndex = 5;
                      });
                      //Invokes _getImage function only if the _imageFile is null.
                      //Disallow image selection until previous placeholder is filled.
                      if (_imageFile1 != null &&
                          _imageFile2 != null &&
                          _imageFile3 != null &&
                          _imageFile4 != null &&
                          _imageFile5 == null) _getImage(_gestureIndex);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      elevation: 8,
                      //Parses int value to detect which image to remove when tapped on remove icon
                      child: _imageFile5 != null
                          ? imageArea(_imageFile5, 5)
                          : plusIcon(context),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _gestureIndex = 6;
                      });
                      //Invokes _getImage function only if the _imageFile is null.
                      //Disallow image selection until previous placeholder is filled.
                      if (_imageFile1 != null &&
                          _imageFile2 != null &&
                          _imageFile3 != null &&
                          _imageFile4 != null &&
                          _imageFile5 != null &&
                          _imageFile6 == null) _getImage(_gestureIndex);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      elevation: 8,
                      //Parses int value to detect which image to remove when tapped on remove icon
                      child: _imageFile6 != null
                          ? imageArea(_imageFile6, 6)
                          : plusIcon(context),
                    ),
                  ),
                ],
              ),
              ElevatedDarkButton(
                child: Text("My info"),
              ),
              RegularButton(
                child: Text(
                  "Work and education",
                ),
                onPressed: () {},
                icon: Icon(Icons.done),
              ),
              RegularButton(
                child: Text(
                  "Interest and hobbies",
                ),
                onPressed: () {},
                icon: Icon(Icons.done),
              ),
              RegularButton(
                child: Text(
                  "Something about me",
                ),
                onPressed: () {},
                icon: Icon(Icons.done),
              ),
              RegularButton(
                child: Text(
                  "Connect your instagram",
                ),
                onPressed: () {},
                icon: Icon(Icons.add),
              ),
              RegularButton(
                child: Text(
                  "Perfect 1st date",
                ),
                onPressed: () {},
                icon: Icon(Icons.done),
              ),
              RegularButton(
                child: Text(
                  "Dating type",
                ),
                onPressed: () {},
                icon: Icon(Icons.done),
              ),
              ElevatedDarkButton(
                child: Text("Verify profile"),
                width: SizeConfig.safeBlockHorizontal * 60,
                onPressed: () {},
              ),
              ElevatedGradientButton(
                child: Text("View profile"),
                width: SizeConfig.safeBlockHorizontal * 60,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Parses the _imageFile and gestureIndex values.
  ///
  /// * It displays image and the remove icon.
  /// * onTap on remove icon, it first removes the exact item from the _photoList
  /// * then using _gestureIndex it determines which "Image" value to be set as null
  Widget imageArea(PickedFile _imageFile, int _removeAtIndex) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            ///using ClipRRect to fit the images to the container with rounded corners
            borderRadius: BorderRadius.circular(20.0),
            child: Image.file(
              File(_imageFile.path),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                print("Removed: ${_imageFile.path.toString()}");
                _photoList.remove(_imageFile.path.toString());
                if (_removeAtIndex == 1) {
                  _imageFile1 = null;
                } else if (_removeAtIndex == 2) {
                  _imageFile2 = null;
                } else if (_removeAtIndex == 3) {
                  _imageFile3 = null;
                } else if (_removeAtIndex == 4) {
                  _imageFile4 = null;
                } else if (_removeAtIndex == 5) {
                  _imageFile5 = null;
                } else if (_removeAtIndex == 6) {
                  _imageFile6 = null;
                }
              });
            },
            child: Icon(
              Icons.highlight_remove_sharp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

/// Simply displays the plus icon in the middle of the empty image area
Widget plusIcon(BuildContext context) {
  return Align(
      alignment: Alignment.center,
      child: new Icon(Icons.add,
          size: 16.0, color: Theme.of(context).colorScheme.onSurface));
}
