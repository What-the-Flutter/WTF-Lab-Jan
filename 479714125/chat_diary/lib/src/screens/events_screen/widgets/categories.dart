import 'package:flutter/material.dart';

import '../../../resources/icon_list.dart';
import '../cubit/cubit.dart';

class Categories extends StatelessWidget {
  const Categories({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  final EventScreenCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: IconList.iconCategoriesList
            .map(
              (e) => CategoryIcon(cubit: cubit, icon: e),
            )
            .toList(),
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final IconData icon;
  final EventScreenCubit cubit;

  const CategoryIcon({
    Key? key,
    required this.cubit,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          cubit.addCurrentCategory(icon);
        },
        icon: Icon(
          icon,
          color: icon == cubit.state.currentCategory
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
        ),
      ),
    );
  }
}
