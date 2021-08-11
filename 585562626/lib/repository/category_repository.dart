import 'dart:async';

import 'package:flutter/material.dart';

import '../models/category.dart';

class CategoryRepository {
  final List<NoteCategory> categories = [
    NoteCategory(name: 'Sports', color: Colors.orangeAccent, image: 'sports.png'),
    NoteCategory(name: 'Travel', color: Colors.lightBlue, image: 'travel.png'),
    NoteCategory(name: 'Family', color: Colors.indigoAccent, image: 'family.png'),
  ];

  final List<NoteCategory> defaultCategories = [
    NoteCategory(image: 'city.png', color: Colors.lightBlue),
    NoteCategory(image: 'family.png', color: Colors.indigoAccent),
    NoteCategory(image: 'health.png', color: Colors.amber.shade800),
    NoteCategory(image: 'home_plant.png', color: Colors.amberAccent.shade400),
    NoteCategory(image: 'it.png', color: Colors.lightBlue.shade300),
    NoteCategory(image: 'money.png', color: Colors.red.shade800),
    NoteCategory(image: 'plant.png', color: Colors.lightBlueAccent.shade100),
    NoteCategory(image: 'shopping.png', color: Colors.blueGrey.shade800),
    NoteCategory(image: 'space.png', color: Colors.blue.shade800),
    NoteCategory(image: 'sports.png', color: Colors.orangeAccent),
    NoteCategory(image: 'todo.png', color: Colors.pinkAccent),
    NoteCategory(image: 'travel.png', color: Colors.lightBlue)
  ];

  Future<List<NoteCategory>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return categories;
  }

  Future<int> addCategory(NoteCategory category) => Future.sync(() {
        categories.add(category);
        return 4;
      });

  Future updateCategory(NoteCategory category) async {
    final oldCategory = categories.firstWhere((element) => element.id == category.id);
    if (oldCategory.image != category.image || oldCategory.name != category.name) {
      final index = categories.indexOf(oldCategory);
      categories.remove(oldCategory);
      categories.insert(index, category);
    }
  }

  Future switchPriority(NoteCategory category) async {
    if (category.priority == CategoryPriority.high) {
      category.priority = CategoryPriority.normal;
    } else {
      category.priority = CategoryPriority.high;
    }
  }

  Future deleteCategory(NoteCategory category) async {
    categories.remove(category);
  }
}
