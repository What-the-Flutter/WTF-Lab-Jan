import '../event.dart';
import '../note.dart';

class StatesStatisticsPage {
  final List<Note> notes;
  final List<Event> events;
  final String selectedPeriod;
  final int countOfBookmarkedEventsInPeriod;
  final int countOfEventsInPeriod;
  final int countOfNotesInPeriod;

  StatesStatisticsPage copyWith({
    final List<Note> notes,
    final List<Event> events,
    final String selectedPeriod,
    final int countOfBookmarkedEventsInPeriod,
    final int countOfEventsInPeriod,
    final int countOfNotesInPeriod,
  }) {
    return StatesStatisticsPage(
      events: events ?? this.events,
      notes: notes ?? this.notes,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      countOfBookmarkedEventsInPeriod: countOfBookmarkedEventsInPeriod ??
          this.countOfBookmarkedEventsInPeriod,
      countOfEventsInPeriod:
          countOfEventsInPeriod ?? this.countOfEventsInPeriod,
      countOfNotesInPeriod: countOfNotesInPeriod ?? this.countOfNotesInPeriod,
    );
  }

  const StatesStatisticsPage({
    this.notes,
    this.events,
    this.selectedPeriod,
    this.countOfBookmarkedEventsInPeriod,
    this.countOfEventsInPeriod,
    this.countOfNotesInPeriod,
  });
}
