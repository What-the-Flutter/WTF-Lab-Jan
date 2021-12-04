part of 'home_page_cubit.dart';

class HomePageState extends Equatable {
  final List<Event> events;
  final int currentEvent;

  const HomePageState({
    this.events = const [],
    this.currentEvent = 0,
  });

  HomePageState copyWith({
    List<Event>? events,
    int? currentEvent,
  }) {
    return HomePageState(
      events: events ?? this.events,
      currentEvent: currentEvent ?? this.currentEvent,
    );
  }

  @override
  List<Object> get props {
    return [events, currentEvent];
  }
}
