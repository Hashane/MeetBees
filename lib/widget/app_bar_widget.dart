import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
final String title;
final Widget child;
final Function onPressed;
final Function onTitleTapped;

@override
final Size preferredSize;

CustomAppBar({@required this.title, @required this.child, @required this.onPressed, this.onTitleTapped})
    : preferredSize = Size.fromHeight(60.0);

ShapeBorder kBackButtonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(30),
  ),
);

@override
Widget build(BuildContext context) {
  return SafeArea(
    child: AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading:  IconButton(
        padding:  EdgeInsets.only(left: 40.0),
          icon: child,
          onPressed: onPressed),
      title: InkWell(
        onTap: onTitleTapped,child:
      Text(
        title,
        style: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w500,
          fontSize: 25,
          // color: Colors.black54,
        ),
      ),),
    ),
  );
}
}
