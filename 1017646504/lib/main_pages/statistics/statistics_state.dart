import '../../entity/page.dart';

class StatisticsState {
  final String selectedTimeline;
  final List<JournalPage> pages;
  final List<Event> events;

  StatisticsState(this.selectedTimeline, this.events, this.pages);

  StatisticsState copyWith({
    String? selectedTimeline,
    List<JournalPage>? pages,
    List<Event>? events,
  }) =>
      StatisticsState(
        selectedTimeline ?? this.selectedTimeline,
        events ?? this.events,
        pages ?? this.pages,
      );
}
