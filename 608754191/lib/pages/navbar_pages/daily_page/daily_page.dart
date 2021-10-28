import 'package:flutter/material.dart';

import '../../../entity/category.dart';

class DailyPage extends StatefulWidget {
  final List<Category> categories;

  DailyPage({Key? key, required this.categories}) : super(key: key);

  @override
  State<DailyPage> createState() => _DailyPage(categories);
}

class _DailyPage extends State<DailyPage> {
  List<Category> categories;

  @required
  _DailyPage(this.categories);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
