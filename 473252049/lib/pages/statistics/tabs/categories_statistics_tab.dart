import 'package:flutter/material.dart';

class CategoriesStatisticsTab extends StatelessWidget {
  const CategoriesStatisticsTab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      text: 'By categories',
    );
  }
}
