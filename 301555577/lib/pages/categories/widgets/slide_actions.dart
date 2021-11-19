import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../data/models/category_model.dart';
import '../../../logic/cubit/categories_cubit.dart';
import '../../create_category/create_category_page.dart';

ActionPane endActionPane(
    CategoriesFetchedState state, int index, BuildContext context) {
  return ActionPane(
    motion: const ScrollMotion(),
    children: [
      SlidableAction(
        // An action can be bigger than the others.
        flex: 1,
        onPressed: (context) {
          context
              .read<CategoriesCubit>()
              .deleteCategory(state.categories[index]);
        },
        backgroundColor: const Color(0xFF7BC043),
        foregroundColor: Colors.white,
        icon: Icons.archive,
        label: 'Delete',
      ),
      SlidableAction(
        onPressed: (_) => _update(state.categories[index], context),
        backgroundColor: const Color(0xFF0392CF),
        foregroundColor: Colors.white,
        icon: Icons.save,
        label: 'Edit',
      ),
    ],
  );
}

ActionPane startActionPane(CategoriesFetchedState state, int index) {
  return ActionPane(
    openThreshold: 0.5,
    motion: const ScrollMotion(),
    children: [
      SlidableAction(
        onPressed: (context) => context
            .read<CategoriesCubit>()
            .switchPriorityCategory(state.categories[index]),
        backgroundColor: const Color(0xFF7BC043),
        foregroundColor: Colors.white,
        icon: Icons.archive,
        label: 'Pin',
      ),
      SlidableAction(
        onPressed: (context) => context
            .read<CategoriesCubit>()
            .switchPriorityCategory(state.categories[index]),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.white,
        icon: Icons.archive,
        label: 'Share',
      ),
    ],
  );
}

void _update(Category category, context) async {
  final result = await Navigator.of(context).pushNamed(
    NewCategoryPage.routeName,
    arguments: NewCategoryArguments(category),
  );
  if (result != null && result is Category) {
    BlocProvider.of<CategoriesCubit>(context).updateCategory(result);
  }
}
