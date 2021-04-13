import '../event_page/event.dart';
import '../note_page/note.dart';

class StatisticsPageStates {
  final String period;
  final bool isSelected;
  final List<bool> bookmarks;
  final List <Event> events;
  final List <Note> notes;
  final int countOfEvents;

  StatisticsPageStates copyWith({
    final String period,
    final bool isSelected,
    final List<bool> bookmarks,
    final List<Event> events,
    final List <Note> notes,
    final int countOfEvents,
  }) {
    return StatisticsPageStates(
      period: period ?? this.period,
      isSelected: isSelected ?? this.isSelected,
      bookmarks: bookmarks ?? this.bookmarks,
      events: events ?? this.events,
      notes: notes ?? this.notes,
      countOfEvents: countOfEvents ?? this.countOfEvents,
    );
  }

  const StatisticsPageStates({
    this.period,
    this.isSelected,
    this.events,
    this.bookmarks,
    this.notes,
    this.countOfEvents
  });
}
