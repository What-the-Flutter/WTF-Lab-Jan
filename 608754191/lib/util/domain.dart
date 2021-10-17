import 'package:flutter/material.dart';
import '../entity/category.dart';

import '../entity/tag_model.dart';

final List<IconData> initialIcons = [
  Icons.theater_comedy,
  Icons.family_restroom,
  Icons.work,
  Icons.local_shipping,
  Icons.sports_basketball,
  Icons.wine_bar,
  Icons.face_unlock_sharp,
  Icons.photo_camera,
  Icons.mode_edit,
  Icons.circle,
  Icons.volunteer_activism,
  Icons.square_foot_rounded,
  Icons.visibility_rounded,
  Icons.accessibility,
  Icons.agriculture,
  Icons.anchor,
  Icons.category,
  Icons.title,
  Icons.airline_seat_flat_rounded,
  Icons.attach_money,
  Icons.attach_file_outlined,
  Icons.auto_fix_high,
  Icons.airplanemode_active,
  Icons.radar,
  Icons.library_music_outlined,
  Icons.wb_sunny,
  Icons.gesture,
  Icons.train_outlined
];

final List<TagModel> tagsToSelect = [
  TagModel(id: '1', title: 'urgently'),
  TagModel(id: '2', title: 'important'),
  TagModel(id: '3', title: 'instruct'),
  TagModel(id: '4', title: 'recreation'),
  TagModel(id: '5', title: 'education'),
  TagModel(id: '6', title: 'studies'),
  TagModel(id: '7', title: 'family'),
  TagModel(id: '8', title: 'sport'),
  TagModel(id: '9', title: 'yourself'),
  TagModel(id: '10', title: 'fun'),
];

List<Category> initialCategories = [
  Category(iconIndex: 1, title: 'Family', subTitleMessage: ''),
  Category(iconIndex: 4, title: 'Sport', subTitleMessage: ''),
  Category(iconIndex: 27, title: 'Travel', subTitleMessage: ''),
];
