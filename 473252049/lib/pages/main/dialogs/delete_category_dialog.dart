import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/category.dart';
import '../tabs/home/cubit/categories_cubit.dart';

class DeleteCategoryDialog extends StatelessWidget {
  final Category category;
  final BuildContext categoriesCubitContext;

  const DeleteCategoryDialog(
      {Key key, this.category, this.categoriesCubitContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete ${category.name}?'),
      actions: [
        TextButton(
          child: Text("Don't"),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Delete'),
          onPressed: () {
            categoriesCubitContext
                .read<CategoriesCubit>()
                .delete(id: category.id);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
