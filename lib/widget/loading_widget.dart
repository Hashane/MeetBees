import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class LoadingWidget extends StatefulWidget {

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {});
    });
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Meet Ceylon',
              style: Theme.of(context).textTheme.headline6,
            ),
            CircularProgressIndicator(
              backgroundColor: Colors.black,
              value: controller.value,
              semanticsLabel: 'Linear progress indicator',
            ),
          ],
        ),
      ),
        ),
    );
  }
}
