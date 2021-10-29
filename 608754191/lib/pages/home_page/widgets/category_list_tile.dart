import 'package:flutter/material.dart';

import '../../../entity/category.dart';
import '../../../util/domain.dart';

class CategoryListTile extends StatelessWidget {
  final Category category;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;

  const CategoryListTile({
    Key? key,
    required this.category,
    this.onLongPress,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        category.title,
      ),
      subtitle: Text(
        category.subTitleMessage.isEmpty
            ? 'No events. Click to create one.'
            : category.subTitleMessage,
      ),
      leading: CircleAvatar(
        child: Icon(
          initialIcons[category.iconIndex],
        ),
        backgroundColor: Colors.black,
      ),
      onLongPress: onLongPress,
      onTap: onTap,
    );
  }
}
