import 'package:flutter/material.dart';

class ActivePerksCards extends StatelessWidget {
  final Widget icon;
  final Widget text;
  final double width;
  final double height;
  final Function onPressed;

  const ActivePerksCards(
      {Key key,
      @required this.icon,
      @required this.text,
      @required this.width,
      @required this.height,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        onTap: onPressed,
        child: Card(
          elevation: 6,
          // margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              text,
            ],
          ),
        ),
      ),
    );
  }
}
