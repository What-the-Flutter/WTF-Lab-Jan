import 'package:flutter/material.dart';

import '../../models/category_model.dart';
import 'db_models/category_db_model.dart';

final int _defaultPriority = CategoryPriority.normal.index;
final List<CategoryDbModel> defaultCategoriesData = [
  CategoryDbModel(
    icon: Icons.access_time_outlined,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.home,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.account_balance_outlined,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.airplanemode_on_outlined,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.anchor_outlined,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.assistant_photo_sharp,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.autorenew,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.backpack_outlined,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.bakery_dining_outlined,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.bathtub_outlined,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.bed_sharp,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.biotech_outlined,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.book_outlined,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.business_outlined,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.cake_outlined,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.call_end_outlined,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.coffee,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.directions_boat_outlined,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.sports,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.travel_explore,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.help,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.devices_other,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.face,
    priority: _defaultPriority,
    isDefault: 1,
  ),
  CategoryDbModel(
    icon: Icons.backpack,
    priority: _defaultPriority,
    isDefault: 1,
  ),
];

final List<CategoryDbModel> categoriesData = [
  CategoryDbModel(
    title: 'Sports',
    icon: Icons.sports,
    priority: _defaultPriority,
  ),
  CategoryDbModel(
    title: 'Travel',
    icon: Icons.travel_explore,
    priority: _defaultPriority,
  ),
  CategoryDbModel(
    title: 'Contact',
    icon: Icons.contact_mail,
    priority: _defaultPriority,
  ),
  CategoryDbModel(
    title: 'Help',
    icon: Icons.help,
    priority: _defaultPriority,
  ),
  CategoryDbModel(
    title: 'Other',
    icon: Icons.devices_other,
    priority: _defaultPriority,
  ),
];
