import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:meet_ceylon/model/chatMessages.dart';
import 'package:meet_ceylon/services/message_dao.dart';
import 'package:path/path.dart' as p;
import 'package:meet_ceylon/services/database.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final String chatId;

  MyHomePage({@required this.title, this.chatId});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _MyHomePageState extends State<MyHomePage> {
  AppState state;
  File imageFile;

  //firebase storage
  firebase_storage.Reference _ref;
  bool _isLoading = false;
  double _progress = 0.0;
  UploadTask uploadTask;
  String _uploadUrl;


  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(children: <Widget>[
        Center(
          child: imageFile != null ? Image.file(imageFile) : Container(),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          top: 0,
          child: Center(
            child: Container(
              child: uploadTask != null
                  ? buildUploadStatus(uploadTask)
                  : Container(),
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 20,
          child: FloatingActionButton(
            backgroundColor: Colors.deepOrange,
            onPressed: () {
              if (state == AppState.free)
                _pickImage();
              else if (state == AppState.picked)
                _cropImage();
              else if (state == AppState.cropped) _clearImage();
            },
            child: _buildButtonIcon(),
          ),
        ),
        Positioned(
          bottom: 50,
          right: 20,
          child: state == AppState.free
              ? Container()
              : FloatingActionButton(
                  child: Icon(Icons.send),
                  backgroundColor: Colors.deepOrange,
                  heroTag: 1,
                  onPressed: () {
                    uploadImageToFirebaseStorage();
                    setState(() {});
                  },
                ),
        )
      ]),
    );

    //   Center(
    //     child: imageFile != null ? Image.file(imageFile) : Container(),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     backgroundColor: Colors.deepOrange,
    //     onPressed: () {
    //       if (state == AppState.free)
    //         _pickImage();
    //       else if (state == AppState.picked)
    //         _cropImage();
    //       else if (state == AppState.cropped) _clearImage();
    //     },
    //     child: _buildButtonIcon(),
    //   ),  floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    // );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.add);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }

  Future<Null> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }

  ///
  /// Upload image to Firebase
  Future uploadImageToFirebaseStorage() async {
    String chatId = widget.chatId;
    _ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('chatImages/$chatId/${p.basename(imageFile.path)}');

    uploadTask = Database.uploadTask(_ref, File(imageFile.path));
    setState(() {});

    if (uploadTask == null) return;

    final snapshot = await uploadTask.whenComplete(() {});
    _uploadUrl = await snapshot.ref.getDownloadURL();

    if(_uploadUrl != "") {
      print(_uploadUrl);

      ///Sending message
      DateTime now = DateTime.now();
      String _formattedTime = DateFormat.Hms().format(now);

      ///current user id
      final String _currentUserId = FirebaseAuth.instance.currentUser.uid;

      final _messageDao = MessageDao();
      final message = ChatMessage(
        text: _uploadUrl,
        date: DateTime.now(),
        messageType: ChatMessageType.image,
        messageStatus: MessageStatus.viewed,
        isSender: true,
        time: _formattedTime,
        uID: _currentUserId,
        u2ID: "eDrZDf0CFtQL9UrNTXAUL5YvIfP2",
        chatID: widget.chatId,
        thumb: "asas",
        name: "Asas",
      );

      _messageDao.saveMessage(message, null);

      ///Redirect back on completion
      /// Navigator.of(context).pop(true);
    }

  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            _progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (_progress * 100).toStringAsFixed(2);

            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: _progress * 100,
                    backgroundColor: Colors.white,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                    strokeWidth: 10,
                  ),
                ),
                Text(
                  percentage + "%",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      );
}
