import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/category.dart';

class CategoryInfoDialog extends StatelessWidget {
  final Category category;

  const CategoryInfoDialog({Key key, this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(category.name),
      content: Text(
        'Create date: ${DateFormat.yMMMd().format(category.createDateTime)}',
      ),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
