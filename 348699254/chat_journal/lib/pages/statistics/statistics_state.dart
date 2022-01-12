import '../../data/model/event.dart';

class StatisticsState {
  final List<Event> summaryTotalList;
  final List<Event> summaryBookmarkList;
  final List<Event> summaryCategoryList;
  final String timePeriod;

  StatisticsState({
    required this.summaryTotalList,
    required this.summaryBookmarkList,
    required this.summaryCategoryList,
    required this.timePeriod,
  });

  StatisticsState copyWith({
    List<Event>? summaryTotalList,
    List<Event>? summaryBookmarkList,
    List<Event>? summaryCategoryList,
    String? timePeriod,
  }) {
    return StatisticsState(
      summaryTotalList: summaryTotalList ?? this.summaryTotalList,
      summaryBookmarkList: summaryBookmarkList ?? this.summaryBookmarkList,
      summaryCategoryList: summaryCategoryList ?? this.summaryCategoryList,
      timePeriod: timePeriod ?? this.timePeriod,
    );
  }
}
