import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';
import '../models/category.dart';

class CategoryItem extends StatelessWidget {
  final NoteCategory category;
  final Function(NoteCategory)? onTap;

  const CategoryItem({Key? key, required this.category, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CornerRadius.card),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(CornerRadius.card),
        hoverColor: Theme.of(context).accentColor.withAlpha(Alpha.alpha30),
        highlightColor: Theme.of(context).accentColor.withAlpha(Alpha.alpha20),
        splashColor: Theme.of(context).accentColor.withAlpha(Alpha.alpha30),
        onTap: () => onTap?.call(category),
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
              Text(
                category.name,
                style: TextStyle(
                  color: category.color,
                  fontSize: FontSize.big,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
