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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0.0),
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
      ),
      onPressed: () { onPressed();},
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            stops: [0.0, 1.0],
            begin: FractionalOffset.centerLeft,
            end: FractionalOffset.centerRight,
            colors: <Color>[
              Colors.orangeAccent,
              Colors.red,
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: width,
          height: SizeConfig.safeBlockVertical * 5,
          child: Center(child: child,),
        ),
      ),
    );
  }
}
