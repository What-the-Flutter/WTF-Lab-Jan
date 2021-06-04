import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagRepository {
  final _list = [
    Icon(Icons.home),
    Icon(Icons.sports_basketball),
    Icon(Icons.ac_unit),
    Icon(Icons.access_alarm),
    Icon(Icons.account_balance),
    Icon(Icons.book),
    Icon(Icons.phone),
    Icon(Icons.photo),
  ];

  List<Icon> get list => _list;
}
