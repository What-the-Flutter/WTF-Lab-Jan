import 'package:flutter/material.dart';

import '../../../entity/category.dart';

class ExplorePage extends StatefulWidget {
  final List<Category> categories;

  ExplorePage({Key? key, required this.categories}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePage(categories);
}

class _ExplorePage extends State<ExplorePage> {
  List<Category> categories;

  @required
  _ExplorePage(this.categories);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
