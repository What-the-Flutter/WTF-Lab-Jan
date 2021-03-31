import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/category.dart';
import '../../../main/tabs/home/cubit/categories_cubit.dart';

class RecordCategoryName extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const RecordCategoryName({Key key, this.categoryName, this.categoryId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categoryName == null) {
      if (categoryId == null) {
        return emptyContainerWothoutSize();
      }
      return FutureBuilder(
        future: context.read<CategoriesCubit>().getById(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data is Category) {
              return RecordCategoryNameText(
                name: snapshot.data.name,
              );
            }
          }
          return emptyContainerWothoutSize();
        },
      );
    }
    return RecordCategoryNameText(name: categoryName);
  }
}

class RecordCategoryNameText extends StatelessWidget {
  final String name;

  const RecordCategoryNameText({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
    );
  }
}

Widget emptyContainerWothoutSize() {
  return Container(
    constraints: BoxConstraints(maxHeight: 0, maxWidth: 0),
  );
}
