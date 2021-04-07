import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../model/category.dart';
import '../../category_add_edit/category_add_edit_page.dart';
import '../dialogs/animated_dialog.dart';
import '../dialogs/category_info_dialog.dart';
import '../dialogs/delete_category_dialog.dart';
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
              title: Text(
                category.name,
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Info'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AnimatedDialog(
                      dialog: CategoryInfoDialog(
                        category: category,
                      ),
                    );
                  },
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
                          defaultIconData: category.icon,
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
                    return AnimatedDialog(
                      dialog: DeleteCategoryDialog(
                        category: category,
                        categoriesCubitContext: context,
                      ),
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
