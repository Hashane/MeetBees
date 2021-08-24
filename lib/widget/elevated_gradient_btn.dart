import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';

class ElevatedGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;

  const ElevatedGradientButton({
    Key key,
    @required this.child,
    this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: width,
      height: SizeConfig.safeBlockVertical * 5,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          stops: [0.0, 1.0],
          begin: FractionalOffset.centerLeft,
          end: FractionalOffset.centerRight,
          colors: <Color>[
            Colors.orangeAccent,
            Colors.deepOrange,
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}