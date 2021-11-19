import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/cubit/new_category_cubit.dart';

Expanded categoryGrid(UpdateCategoryState state, BuildContext context) {
  return Expanded(
    flex: 8,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 3,
        children: state.defaultCategories
            .map(
              (category) => Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: state.selectedCategory?.icon == category.icon
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.all(8),
                    child: Center(
                      child: Icon(
                        category.icon,
                        size: 40,
                        color: state.selectedCategory?.icon == category.icon
                            ? Theme.of(context).backgroundColor
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => BlocProvider.of<NewCategoryCubit>(context)
                            .categoryChanged(category),
                      ),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    ),
  );
}
