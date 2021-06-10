import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagRepository {
  final _list = [
    Icons.home,
    Icons.sports_basketball,
    Icons.ac_unit,
    Icons.access_alarm,
    Icons.account_balance,
    Icons.book,
    Icons.phone,
    Icons.photo,
  ];

  List<IconData> get list => _list;
}
