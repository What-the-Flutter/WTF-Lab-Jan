import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'category.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: category.color.withAlpha(80)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                category.name,
                style: const TextStyle(color: Colors.black54, fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Image.asset(category.image),
            ],
          ),
        ),
      ),
    );
  }
}
