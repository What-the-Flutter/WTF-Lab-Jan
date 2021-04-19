import 'package:flutter/material.dart';
import './main.dart';

class FloatingActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: null,
      backgroundColor: colorMain,
      child: Icon(Icons.plus_one),
    );
  }
}