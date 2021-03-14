import 'package:flutter/material.dart';

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildSignUp();
  }

}
Widget buildSignUp() {
  return Scaffold(
  body: Column(
    children: [
      TextButton.icon(
        onPressed: () {},
        icon: Icon(Icons.sports_soccer_outlined),
        label: Text('Google'),
      ),
      TextButton.icon(
          onPressed: null,
          icon: Icon(Icons.sports_soccer_outlined),
          label: Text('Facebook')),
      TextButton.icon(
          onPressed: () {},
          icon: Icon(Icons.phone),
          label: Text('Mobile Number'))
    ],
  ),
  );
}
