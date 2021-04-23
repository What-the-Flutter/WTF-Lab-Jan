import 'package:flutter/material.dart';

import 'constants/constants.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDateByDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameDateByHour(DateTime other) {
    return year == other.year &&
        month == other.month &&
        day == other.day &&
        hour == other.hour;
  }

  bool isSameDateByMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  DateTime applied(TimeOfDay time) {
    return DateTime(
      year,
      month,
      day,
      time.hour,
      time.minute,
    );
  }
}

extension TypeTimeDiagramExtension on TypeTimeDiagram {
  String get name {
    switch (this) {
      case TypeTimeDiagram.today:
        return 'Today';
      case TypeTimeDiagram.pastSevenDays:
        return 'Past 7 days';
      case TypeTimeDiagram.pastThirtyDays:
        return 'Past 30 days';
      case TypeTimeDiagram.thisYear:
        return 'This year';
      default:
        return 'Null';
    }
  }
}
