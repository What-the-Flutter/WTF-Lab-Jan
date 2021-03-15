part of 'dialog_page_cubit.dart';

class DialogPageState extends Equatable {
  final int id;
  final bool isPin;
  final IconData icon;
  final String title;
  final DateTime time;

  DialogPageState({this.id,this.icon, this.title, this.isPin, this.time});

  DialogPageState copyWith(
      {final int id,
        final bool isPin,
      final IconData icon,
      final String title,
      final DateTime time}) {
    return DialogPageState(
      id: id??this.id,
      isPin: isPin ?? this.isPin,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      time: time ?? this.time,
    );
  }

  @override
  String toString() {
    return 'DialogPageState{id: $id,isPin: $isPin, title: $title, time: $time}';
  }

  @override
  List<Object> get props => [id,isPin, icon, title];
}
