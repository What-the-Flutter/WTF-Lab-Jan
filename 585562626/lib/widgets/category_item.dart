import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/category.dart';
import '../utils/constants.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final Function(Category)? onTap;
  final Function(Category)? onLongPress;

  const CategoryItem({
    Key? key,
    required this.category,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  Widget _content() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FractionallySizedBox(
            widthFactor: 0.6,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(CornerRadius.circle),
                  color: category.color.withAlpha(Alpha.alpha50),
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Image.asset('assets/${category.image}'),
                ),
              ),
            ),
          ),
          if (category.name != null)
            Container(
              margin: const EdgeInsets.only(
                left: Insets.medium,
                right: Insets.medium,
                bottom: Insets.medium,
              ),
              child: Text(
                category.name!,
                maxLines: 1,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(CornerRadius.card),
      hoverColor: Theme.of(context).accentColor.withAlpha(Alpha.alpha30),
      highlightColor: Theme.of(context).accentColor.withAlpha(Alpha.alpha20),
      splashColor: Theme.of(context).accentColor.withAlpha(Alpha.alpha30),
      onTap: () => onTap?.call(category),
      onLongPress: () => onLongPress?.call(category),
      child: Stack(
        children: [
          _content(),
          if (category.priority == CategoryPriority.high)
            const Positioned(
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(Insets.small),
                child: Icon(Icons.push_pin),
              ),
            ),
        ],
      ),
    );
  }
}