import 'package:flutter/material.dart';
import 'package:meet_ceylon/services/size_configurations.dart';


/// Regular button in Edit Profile
///
/// * Displays a text and changable trailing icon
class RegularButton extends StatelessWidget {
  final Widget child;
  final Widget icon;
  final double width;
  final double height;
  final Function onPressed;

  const RegularButton({
    Key key,
    @required this.child,
    this.icon,
    this.width = double.infinity,
    this.height = 40.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      color: Theme.of(context).colorScheme.surface,
      child:
      Material(
        color: Colors.transparent,
        child: InkWell(
          child:ListTile(
            title: child,
            trailing: icon,
          ),
          onTap: onPressed,
        ),
      ),
    );
  }
}
