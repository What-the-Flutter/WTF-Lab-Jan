import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class MyFloatingActionButton extends StatelessWidget {
  const MyFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(
        LineIcons.plus,
        color: Colors.black,
      ),
      elevation: 2,
      onPressed: () {},
    );
  }
}
