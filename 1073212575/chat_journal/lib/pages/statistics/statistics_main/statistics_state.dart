import 'package:flutter/cupertino.dart';

class StatisticsPageState {
  final Widget statisticsType;
  final bool isColorChanged;

  StatisticsPageState({
    required this.statisticsType,
    required this.isColorChanged,
  });

  StatisticsPageState copyWith({
    Widget? statisticsType,
    bool? isColorChanged,
  }) {
    return StatisticsPageState(
        statisticsType:statisticsType??this.statisticsType,
      isColorChanged: isColorChanged ?? this.isColorChanged,
    );
  }
}
