import 'package:flutter/material.dart';

class EventIcon extends StatelessWidget {
  const EventIcon({
    Key? key,
    required this.iconData,
  }) : super(key: key);

  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Icon(
        iconData,
        color: Colors.white,
      ),
      radius: 32,
      backgroundColor: Theme.of(context).cardColor,
    );
  }
}
