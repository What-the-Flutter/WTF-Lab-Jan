import 'package:flutter/material.dart';

const List<IconData> iconList = [
  Icons.work_outlined,
  Icons.wifi_outlined,
  Icons.weekend,
  Icons.airplanemode_on_rounded,
  Icons.wb_sunny,
];

const List<String> stringList = [
  'Work',
  'Internet',
  'Weekend',
  'Travel',
  'Weather',
];

final List<IconData> eventIconList = [
  Icons.close,
  ...iconList,
];

final List<String> eventStringList = [
  'None',
  ...stringList,
];