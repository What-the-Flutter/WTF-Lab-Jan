import 'package:flutter/material.dart';

import '../model/category.dart';

class CategoryBottomSheetView extends StatelessWidget {
  final Category _category;

  CategoryBottomSheetView(this._category);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.info),
          title: Text('Info'),
        ),
        ListTile(
          leading: Icon(Icons.pin_drop),
          title: Text('Pin/Unpin Page'),
        ),
        ListTile(
          leading: Icon(Icons.archive),
          title: Text('Archive Page'),
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Edit Page'),
        ),
        ListTile(
          leading: Icon(Icons.delete),
          title: Text('Delete Page'),
        ),
      ],
    );
  }
}
