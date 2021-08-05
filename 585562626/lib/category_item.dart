import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'category.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({Key? key, required this.category}) : super(key: key);

  void _onCategoryClick(BuildContext context, Category category) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(category.name)));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        hoverColor: Theme.of(context).accentColor.withAlpha(30),
        highlightColor: Theme.of(context).accentColor.withAlpha(20),
        splashColor: Theme.of(context).accentColor.withAlpha(30),
        onTap: () => _onCategoryClick(context, category),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: category.color.withAlpha(50),
                ),
                padding: const EdgeInsets.all(12.0),
                height: 100,
                width: 100,
                child: Image.asset('assets/${category.image}'),
              ),
              Text(
                category.name,
                style: TextStyle(
                  color: category.color,
                  fontSize: 18.0,
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
