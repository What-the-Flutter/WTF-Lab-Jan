import 'package:flutter/material.dart';
import '../../../entity/category.dart';

class TimelinePage extends StatefulWidget {
  final List<Category> categories;

  TimelinePage({Key? key, required this.categories}) : super(key: key);

  @override
  State<TimelinePage> createState() => _TimelinePage(categories);
}

class _TimelinePage extends State<TimelinePage> {
  List<Category> categories;

  @required
  _TimelinePage(this.categories);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
