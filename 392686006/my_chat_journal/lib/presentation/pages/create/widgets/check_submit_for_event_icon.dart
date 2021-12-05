import 'package:flutter/material.dart';

class CheckSubmitForEventIcon extends StatelessWidget {
  const CheckSubmitForEventIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 11,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 9,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 17,
        ),
      ),
    );
  }
}
