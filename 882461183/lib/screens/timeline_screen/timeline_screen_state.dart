part of 'timeline_screen_cubit.dart';

class TimelineScreenState {
  final bool isShowFavorites;
  final int selectedItemsCount;
  final List<Event> eventList;

  TimelineScreenState({
    this.isShowFavorites = false,
    this.eventList = const [],
    this.selectedItemsCount = 0,
  });

  TimelineScreenState copyWith({
    bool? isShowFavorites,
    List<Event>? eventList,
    int? selectedItemsCount,
  }) {
    return TimelineScreenState(
      isShowFavorites: isShowFavorites ?? this.isShowFavorites,
      eventList: eventList ?? this.eventList,
      selectedItemsCount: selectedItemsCount ?? this.selectedItemsCount,
    );
  }
}
