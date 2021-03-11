part of 'dialog_page_cubit.dart';

class DialogPageState extends Equatable {
  final bool isPin;
  final IconData icon;
  final String title;
  final DateTime time;

  DialogPageState({
    this.icon,
    this.title,
    this.isPin,
    this.time,
  });

  DialogPageState copyWith({
    final bool isPin,
    final IconData icon,
    final String title,
    final DateTime time,
  }) {
    return DialogPageState(
      isPin: isPin ?? this.isPin,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      time: time ?? this.time,
    );
  }

  @override
  String toString() {
    return 'DialogPageState{isPin: $isPin, title: $title, time: $time}';
  }

  @override
  List<Object> get props => [isPin, icon, title];
}
