import 'package:flutter/material.dart';

import '../../models/category.dart';
import 'models/category.dart';

final int _defaultPriority = CategoryPriority.normal.index;
final List<DbCategory> defaultCategoriesData = [
  DbCategory(
    image: 'city.png',
    color: Colors.lightBlue.value,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  DbCategory(
    image: 'family.png',
    color: Colors.indigoAccent.value,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  DbCategory(
    image: 'health.png',
    color: Colors.amber.shade800.value,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  DbCategory(
    image: 'home_plant.png',
    color: Colors.amberAccent.shade400.value,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  DbCategory(
    image: 'it.png',
    color: Colors.lightBlue.shade300.value,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  DbCategory(
    image: 'money.png',
    color: Colors.red.shade800.value,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  DbCategory(
    image: 'plant.png',
    color: Colors.lightBlueAccent.shade100.value,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  DbCategory(
    image: 'shopping.png',
    color: Colors.blueGrey.shade800.value,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  DbCategory(
    image: 'space.png',
    color: Colors.blue.shade800.value,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  DbCategory(
    image: 'sports.png',
    color: Colors.orangeAccent.value,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  DbCategory(
    image: 'todo.png',
    color: Colors.pinkAccent.value,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  DbCategory(
    image: 'travel.png',
    color: Colors.lightBlue.value,
    priority: _defaultPriority,
    isDefault: 1,
  )
];

final List<DbCategory> categoriesData = [
  DbCategory(
    name: 'Sports',
    color: Colors.orangeAccent.value,
    image: 'sports.png',
    priority: _defaultPriority,
  ),
  DbCategory(
    name: 'Travel',
    color: Colors.lightBlue.value,
    image: 'travel.png',
    priority: _defaultPriority,
  ),
  DbCategory(
    name: 'Family',
    color: Colors.indigoAccent.value,
    image: 'family.png',
    priority: _defaultPriority,
  ),
];
