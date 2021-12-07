import 'package:flutter/material.dart';

import '../../../resources/icon_list.dart';
import '../cubit.dart';

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

class CategoryIcon extends StatefulWidget {
  final IconData icon;
  final EventScreenCubit cubit;

  const CategoryIcon({
    Key? key,
    required this.cubit,
    required this.icon,
  }) : super(key: key);

  @override
  State<CategoryIcon> createState() => _CategoryIconState();
}

class _CategoryIconState extends State<CategoryIcon> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          widget.cubit.addCurrentCategory(widget.icon);
          isSelected = !isSelected;
        },
        icon: Icon(
          widget.icon,
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
        ),
      ),
    );
  }
}
