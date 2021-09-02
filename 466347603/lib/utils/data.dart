import 'package:flutter/material.dart';
import '../modules/page_info.dart';

final List<Category> initCategories = List<Category>.from(
  defaultIconsNames.map(
    (e) => Category(
      title: e,
      icon: defaultIcons[defaultIconsNames.indexOf(e)],
    ),
  ),
);

final List<IconData> defaultIcons = const <IconData>[
  Icons.bubble_chart,
  Icons.ac_unit,
  Icons.wine_bar,
  Icons.local_pizza,
  Icons.money,
  Icons.car_rental,
  Icons.food_bank,
  Icons.navigation,
  Icons.laptop,
  Icons.umbrella,
  Icons.access_alarm,
  Icons.accessible,
  Icons.account_balance,
  Icons.account_circle,
  Icons.adb,
  Icons.add_alarm,
  Icons.add_alert,
  Icons.airplanemode_active,
  Icons.attach_money,
  Icons.audiotrack,
  Icons.av_timer,
  Icons.backup,
  Icons.beach_access,
  Icons.block,
  Icons.brightness_1,
  Icons.bug_report,
  Icons.bubble_chart,
  Icons.call_merge,
  Icons.camera,
  Icons.change_history,
];

final List<String> defaultIconsNames = const <String>[
  '',
  'unit',
  'wine',
  'pizza',
  'money',
  'car',
  'food',
  'navigation',
];
