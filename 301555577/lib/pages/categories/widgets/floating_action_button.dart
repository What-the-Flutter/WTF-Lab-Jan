import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/category_model.dart';
import '../../../logic/cubit/categories_cubit.dart';
import '../../create_category/create_category_page.dart';

FloatingActionButton floatingActionButton(BuildContext context) {
  return FloatingActionButton(
    heroTag: 'new_category',
    onPressed: () => _navigateToNewCategory(context),
    child: const Icon(Icons.add),
  );
}

void _navigateToNewCategory(context) async {
  final result =
      await Navigator.of(context).pushNamed(NewCategoryPage.routeName);
  if (result != null && result is Category) {
    result.id == null
        ? BlocProvider.of<CategoriesCubit>(context).addCategory(result)
        : BlocProvider.of<CategoriesCubit>(context).updateCategory(result);
  }
}
