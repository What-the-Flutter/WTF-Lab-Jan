import '../../entity/label.dart';
import '../../entity/page.dart';

class StatisticsState {
  final String selectedTimeline;
  final List<Label> labels;
  final List<JournalPage> pages;
  final List<Event> events;

  StatisticsState(this.selectedTimeline, this.labels, this.events, this.pages);

  StatisticsState copyWith({
    String selectedTimeline,
    List<Label> labels,
    List<JournalPage> pages,
    List<Event> events,
  }) =>
      StatisticsState(
        selectedTimeline ?? this.selectedTimeline,
        labels ?? this.labels,
        events ?? this.events,
        pages ?? this.pages,
      );
}
