import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';

class ElevatedDarkButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;

  const ElevatedDarkButton({
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
    return SizedBox(
      width: width,
      height: SizeConfig.safeBlockVertical * 6,
      child: Card(
        elevation: 6,
        // margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        color: Theme.of(context).colorScheme.onSurface,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
