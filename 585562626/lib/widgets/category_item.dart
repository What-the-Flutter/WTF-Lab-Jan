import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/category.dart';
import '../utils/constants.dart';

class CategoryItem extends StatelessWidget {
  final NoteCategory category;
  final Function(NoteCategory)? onTap;
  final Function(NoteCategory)? onLongPress;

  const CategoryItem({
    Key? key,
    required this.category,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(CornerRadius.card),
      hoverColor: Theme.of(context).accentColor.withAlpha(Alpha.alpha30),
      highlightColor: Theme.of(context).accentColor.withAlpha(Alpha.alpha20),
      splashColor: Theme.of(context).accentColor.withAlpha(Alpha.alpha30),
      onTap: () => onTap?.call(category),
      onLongPress: () => onLongPress?.call(category),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(CornerRadius.circle),
                color: category.color.withAlpha(Alpha.alpha50),
              ),
              padding: const EdgeInsets.all(Insets.xmedium),
              height: 100,
              width: 100,
              child: Image.asset('assets/${category.image}'),
            ),
            if (category.name != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: Insets.medium),
                child: Text(
                  category.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: category.color,
                    fontSize: FontSize.big,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
