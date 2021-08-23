import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({Key key, Widget title,Widget actionIcon, Function onPressed})
      : super(key: key, title: title, actions: <Widget>[
          new IconButton(
            icon: actionIcon,
            onPressed: () => onPressed,
          )
        ]);
}
