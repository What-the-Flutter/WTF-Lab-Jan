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
  Icons.call_merge,
  Icons.camera,
  Icons.change_history,
  Icons.my_library_books,
  Icons.book,
  Icons.text_fields,
  Icons.favorite,
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

final List<PageInfo> initPages = <PageInfo>[
  PageInfo(
    title: 'Journal',
    icon: const Icon(
      Icons.book,
      color: Colors.white,
    ),
  ),
  PageInfo(
    title: 'Notes',
    icon: const Icon(
      Icons.my_library_books,
      color: Colors.white,
    ),
  ),
  PageInfo(
    title: 'Text',
    icon: const Icon(
      Icons.text_fields,
      color: Colors.white,
    ),
  ),
];

List<String> months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];
