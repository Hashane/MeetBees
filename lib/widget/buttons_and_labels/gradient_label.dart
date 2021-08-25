import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';

class GradientLabel extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;

  const GradientLabel({Key key, this.width, this.height, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        margin: EdgeInsets.all(12),
        width: width,
        height: SizeConfig.safeBlockVertical * 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
          gradient: LinearGradient(
            stops: [0.0, 1.0],
            begin: FractionalOffset.centerLeft,
            end: FractionalOffset.centerRight,
            colors: <Color>[
              Colors.orangeAccent,
              Colors.red,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
