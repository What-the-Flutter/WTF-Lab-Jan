import 'package:chat_journal/entity/label.dart';
import 'package:flutter/material.dart';

final List<IconData> iconList = [
  Icons.work_outlined,
  Icons.wifi_outlined,
  Icons.weekend,
  Icons.airplanemode_on_rounded,
  Icons.work_outlined,
  Icons.wifi_outlined,
  Icons.weekend,
  Icons.airplanemode_on_rounded,
  Icons.work_outlined,
  Icons.wifi_outlined,
  Icons.weekend,
  Icons.airplanemode_on_rounded,
  Icons.work_outlined,
  Icons.wifi_outlined,
  Icons.weekend,
  Icons.airplanemode_on_rounded,
];

final List<String> stringList = [
  'Work',
  'Internet',
  'Weekend',
  'Travel',
  'Work',
  'Internet',
  'Weekend',
  'Travel',
  'Work',
  'Internet',
  'Weekend',
  'Travel',
  'Work',
  'Internet',
  'Weekend',
  'Travel',
];

final List<IconData> eventIconList = [
  Icons.close,
  ...iconList,
];

final List<String> eventStringList = [
  'None',
  ...stringList,
];

final List<Label> labels =
    List.generate(iconList.length, (index) => Label(index, stringList[index]));
