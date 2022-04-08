part of 'statistic_screen_cubit.dart';

class StatisticScreenState {
  final List<Event> summaryTotalList;
  final List<Event> summaryBookmarkList;
  final List<Event> summaryCategoryList;
  final String timePeriod;

  StatisticScreenState({
    required this.summaryTotalList,
    required this.summaryBookmarkList,
    required this.summaryCategoryList,
    required this.timePeriod,
  });

  StatisticScreenState copyWith({
    List<Event>? summaryTotalList,
    List<Event>? summaryBookmarkList,
    List<Event>? summaryCategoryList,
    String? timePeriod,
  }) {
    return StatisticScreenState(
      summaryTotalList: summaryTotalList ?? this.summaryTotalList,
      summaryBookmarkList: summaryBookmarkList ?? this.summaryBookmarkList,
      summaryCategoryList: summaryCategoryList ?? this.summaryCategoryList,
      timePeriod: timePeriod ?? this.timePeriod,
    );
  }
}
