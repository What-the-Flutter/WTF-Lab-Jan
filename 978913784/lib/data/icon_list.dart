import 'package:flutter/material.dart';

import '../entity/label.dart';

final List<IconData> iconList = [
  Icons.work_outlined,
  Icons.wifi_outlined,
  Icons.weekend,
  Icons.airplanemode_on_rounded,
  Icons.whatshot,
  Icons.alarm_sharp,
  Icons.audiotrack_outlined,
  Icons.analytics,
];

final List<String> stringList = [
  'Work',
  'Internet',
  'Weekend',
  'Travel',
  'Trending',
  'Alarm',
  'Music',
  'Analytics',
];

final List<IconData> eventIconList = [
  Icons.close,
  ...iconList,
];

final List<String> eventStringList = [
  'None',
  ...stringList,
];

final List<Label> stockLabels =
    List.generate(iconList.length, (index) => Label(index, stringList[index]));
