import 'package:flutter/material.dart';

class CreateMessageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: AspectRatio(
            aspectRatio: 1,
            child: TextButton(
              child: Icon(Icons.photo_camera),
              onPressed: () {},
            ),
          ),
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter Event',
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 60,
          child: AspectRatio(
            aspectRatio: 1,
            child: TextButton(
              child: Icon(Icons.send),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}
