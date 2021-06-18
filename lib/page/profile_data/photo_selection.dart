import 'dart:io';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as p;


import 'enable_location.dart';
import 'dart:developer' as developer;

class PhotoSelection extends StatefulWidget {
  // Declare a field that holds user information
  final Map<String, String> userInfoMap;

  @override
  _PhotoSelectionState createState() => _PhotoSelectionState();

  PhotoSelection({Key key, @required this.userInfoMap}) : super(key: key);
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
  List<String> _photoList = [];
  List<String> _urlList = [];

  //firebase storage
  firebase_storage.Reference ref;
  bool _isLoading = false;
  double _progress;
  UploadTask uploadTask;

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
    developer.log(_photoList.toString(), name: 'my.meet_ceylon.photo');
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
            child: Center(
              child: Column(
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
                                //Invokes _getImage function only if the _imageFile is null.
                                if (_imageFile1 == null)
                                  _getImage(_gestureIndex);
                              },
                              child: Container(
                                color: Colors.black12,
                                //Parses int value to detect which image to remove when tapped on remove icon
                                child: _imageFile1 != null
                                    ? imageArea(_imageFile1, 1)
                                    : plusIcon(),
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
                              child: Container(
                                color: Colors.black12,
                                //Parses int value to detect which image to remove when tapped on remove icon
                                child: _imageFile2 != null
                                    ? imageArea(_imageFile2, 2)
                                    : plusIcon(),
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
                                    _imageFile3 == null)
                                  _getImage(_gestureIndex);
                              },
                              child: Container(
                                color: Colors.black12,
                                //Parses int value to detect which image to remove when tapped on remove icon
                                child: _imageFile3 != null
                                    ? imageArea(_imageFile3, 3)
                                    : plusIcon(),
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
                                    _imageFile4 == null)
                                  _getImage(_gestureIndex);
                              },
                              child: Container(
                                color: Colors.black12,
                                //Parses int value to detect which image to remove when tapped on remove icon
                                child: _imageFile4 != null
                                    ? imageArea(_imageFile4, 4)
                                    : plusIcon(),
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
                                    _imageFile5 == null)
                                  _getImage(_gestureIndex);
                              },
                              child: Container(
                                color: Colors.black12,
                                //Parses int value to detect which image to remove when tapped on remove icon
                                child: _imageFile5 != null
                                    ? imageArea(_imageFile5, 5)
                                    : plusIcon(),
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
                                    _imageFile6 == null)
                                  _getImage(_gestureIndex);
                              },
                              child: Container(
                                color: Colors.black12,
                                //Parses int value to detect which image to remove when tapped on remove icon
                                child: _imageFile6 != null
                                    ? imageArea(_imageFile6, 6)
                                    : plusIcon(),
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
                        height:
                            SizeConfig.safeBlockVertical * 7, //10 for example
                        width: SizeConfig.safeBlockHorizontal *
                            100, //10 for example
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
                              if (_photoList.length < 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("Add at least 3 images")));
                              } else {

                                uploadImageToFirebaseStorage();
                                showLoaderDialog(context);

                                //Invoking upload function and displaying completion message.


                                // uploadImageToFirebaseStorage().whenComplete(() =>
                                //      DialogBuilder(context).showLoadingIndicator('Uploading ${(_progress * 100).toStringAsFixed(2)} %'),
                                // );

                                // Text('Uploading ${(_progress * 100).toStringAsFixed(2)} %');

                                //   uploadImages().whenComplete(() =>
                                //       developer.log("first", name: 'my.meet_ceylon.photo'));
                                //
                                //
                                //
                                //       // ScaffoldMessenger.of(context)
                                //       //     .showSnackBar(SnackBar(
                                //       //   duration: Duration(milliseconds: 1000),
                                //       //   content: Text("Images upload Completed!"),
                                //       //   behavior: SnackBarBehavior
                                //       //       .floating, // Add this line
                                //       // )));
                                //
                                //
                                //
                              }
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(color: Colors.red))),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black54),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
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
      ),
    );
  }

  /// Bulk upload images in the _photoList
  ///
  /// * Loops through _photoList
  /// * Provides a unique reference to each image in the list
  /// * Asynchronously each image will be uploaded and the download url is taken.
  /// * Each download url is stored in _urlList
  Future uploadImageToFirebaseStorage() async {
    if (_photoList.length > 0) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${p.basename(_photoList[0])}');
      uploadTask = ref.putFile(File(_photoList[0]));
      _photoList.removeAt(0);

      uploadTask.snapshotEvents.listen((event) {
          _progress =
          (event.bytesTransferred.toDouble() / event.totalBytes.toDouble());
      });

      uploadTask.whenComplete(() async => {
            await ref.getDownloadURL().then((value) {
              _urlList.add(value);
            }),
            uploadUserImagesToFirebaseStorage(),
          });
    }
  }


  //upload beer images
  uploadUserImagesToFirebaseStorage() {
    if (_photoList.length > 0) {
      uploadImageToFirebaseStorage();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new EnableLocation(
                photoList: _urlList, userInfoMap: widget.userInfoMap)),
      );
    }
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
          child: Image.file(
            File(_imageFile.path),
            fit: BoxFit.fill,
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

  /// Simply displays the plus icon in the middle of the empty image area
  Widget plusIcon() {
    return Align(
        alignment: Alignment.center,
        child: new Icon(Icons.add, size: 16.0, color: Colors.white));
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))
      ),
      backgroundColor: Colors.black.withOpacity(0.8),
      content:
        Container(
            padding: EdgeInsets.all(16),
            color: Colors.black87,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(margin: EdgeInsets.only(left: 7),
                      child:

                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text("Uploading..",style: TextStyle(
                            color: Colors.white,
                            fontSize: 14
                      ),
                    textAlign: TextAlign.center,),
                          )),
                  CircularProgressIndicator(value: _progress,),
                ]
            )
        ),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

}
