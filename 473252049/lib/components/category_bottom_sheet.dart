import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home_page_bloc/homepage_bloc.dart';
import '../model/category.dart';
import '../pages/category_edit_page.dart';

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
                  child: AlertDialog(
                    title: Text(category.name),
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
              title: Text('Pin/Unpin Page'),
              onTap: () {
                BlocProvider.of<HomepageBloc>(context).add(
                  CategoryPinChanged(category),
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
                        value: BlocProvider.of<HomepageBloc>(context),
                        child: CategoryEditPage(
                          category,
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
                            BlocProvider.of<HomepageBloc>(context).add(
                              CategoryDeleted(category),
                            );
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
