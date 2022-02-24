import '../../event.dart';
import '../../note.dart';

class StatesStatisticsPage {
  final List<Event> eventList;
  final List<Note> noteList;
  final String selectedPeriod;
  final int countOfEvents;
  final int countOfNotes;
  final int countOfBookmarkedEvents;

  const StatesStatisticsPage({
    this.eventList = const [],
    this.noteList = const [],
    this.selectedPeriod = 'Past year',
    this.countOfBookmarkedEvents = 0,
    this.countOfEvents = 0,
    this.countOfNotes = 0,
  });

  StatesStatisticsPage copyWith({
    final List<Event>? eventList,
    final List<Note>? noteList,
    final String? selectedPeriod,
    final int? countOfEvents,
    final int? countOfNotes,
    final int? countOfBookmarkedEvents,
  }) {
    return StatesStatisticsPage(
      eventList: eventList ?? this.eventList,
      noteList: noteList ?? this.noteList,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      countOfBookmarkedEvents:
          countOfBookmarkedEvents ?? this.countOfBookmarkedEvents,
      countOfEvents: countOfEvents ?? this.countOfEvents,
      countOfNotes: countOfNotes ?? this.countOfNotes,
    );
  }
}
