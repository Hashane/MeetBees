import 'package:flutter/material.dart';

import 'chat_input_widget.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) =>
                 Text("asa"),
            ),
          ),
        ),
        ChatInputField(),
      ],
    );
  }
}