part of 'statistics_page_cubit.dart';

class StatisticsPageState {
  final String period;
  final bool isSelected;
  final List<bool> bookmarks;
  final List <Event> events;
  final List <Note> notes;
  final int countOfEvents;

  StatisticsPageState copyWith({
    final String? period,
    final bool? isSelected,
    final List<bool>? bookmarks,
    final List<Event>? events,
    final List <Note>? notes,
    final int? countOfEvents,
  }) {
    return StatisticsPageState(
      period: period ?? this.period,
      isSelected: isSelected ?? this.isSelected,
      bookmarks: bookmarks ?? this.bookmarks,
      events: events ?? this.events,
      notes: notes ?? this.notes,
      countOfEvents: countOfEvents ?? this.countOfEvents,
    );
  }

  const StatisticsPageState({
    required this.period,
    required this.isSelected,
    required this.events,
    required this.bookmarks,
    required this.notes,
    required this.countOfEvents
  });
}