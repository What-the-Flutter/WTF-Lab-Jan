import 'package:flutter/material.dart';

class AppFloatingActionButton extends StatelessWidget {
  final Function() onPressed;
  final Widget? child;

  const AppFloatingActionButton({Key? key, required this.onPressed, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
