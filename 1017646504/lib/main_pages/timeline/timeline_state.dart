import '../../entity/page.dart';

class TimelineState {
  final bool showingFavourites;
  final bool isOnSearch;
  final bool isDateCentered;
  final bool isRightToLeft;
  String filter;
  List<Event> events = [];

  TimelineState(
      this.showingFavourites,
      this.isOnSearch,
      this.isDateCentered,
      this.isRightToLeft,
      this.filter,
      this.events,
      );

  TimelineState copyWith({
    bool? showingFavourites,
    bool? isOnSearch,
    bool? isDateCentered,
    bool? isRightToLeft,
    String? filter,
    List<Event>? events,
  }) =>
      TimelineState(
        showingFavourites ?? this.showingFavourites,
        isOnSearch ?? this.isOnSearch,
        isDateCentered ?? this.isDateCentered,
        isRightToLeft ?? this.isRightToLeft,
        filter ?? this.filter,
        events ?? this.events,
      );
}