import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../model/category.dart';
import '../../category_add_edit/category_add_edit_page.dart';
import '../tabs/home/cubit/categories_cubit.dart';

class CategoryBottomSheet extends StatelessWidget {
  final Category category;

  CategoryBottomSheet(this.category);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Info'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
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
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.pin_drop),
              title: Text(category.isPinned ? 'Unpin page' : 'Pin page'),
              onTap: () {
                context.read<CategoriesCubit>().changePin(
                      category: category,
                    );
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.archive),
              title: Text('Archive Page'),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Page'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return BlocProvider.value(
                        value: context.read<CategoriesCubit>(),
                        child: CategoryAddEditPage(
                          mode: CategoryAddEditMode.edit,
                          category: category,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Page'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (newContext) {
                    return AlertDialog(
                      title: Text('Delete ${category.name}?'),
                      actions: [
                        TextButton(
                          child: Text("Don't"),
                          onPressed: () {
                            Navigator.of(newContext).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () {
                            context
                                .read<CategoriesCubit>()
                                .delete(id: category.id);
                            Navigator.of(newContext).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
