part of 'event_page_cubit.dart';

class EventPageState extends Equatable {
  final bool isPin;
  final IconData icon;
  final String title;
  final DateTime time;

  EventPageState({
    this.icon,
    this.title,
    this.isPin,
    this.time,
  });

  EventPageState copyWith({
    final bool isPin,
    final IconData icon,
    final String title,
    final DateTime time,
  }) {
    return EventPageState(
      isPin: isPin ?? this.isPin,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      time: time ?? this.time,
    );
  }

  @override
  String toString() {
    return 'EventPageState{isPin: $isPin, title: $title, time: $time}';
  }

  @override
  List<Object> get props => [isPin, icon, title];
}
