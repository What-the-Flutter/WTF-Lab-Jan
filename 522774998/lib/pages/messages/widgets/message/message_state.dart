part of 'message_cubit.dart';

class MessageState extends Equatable {
  final int id;
  final bool isSelected;
  final IconData icon;
  final String message;
  final DateTime time;
  final Function onTap;

  MessageState(
      {this.id,
      this.message,
      this.time,
      this.isSelected,
      this.onTap,
      this.icon});

  MessageState copyWith(
      {final int id,
      final bool isSelected,
      final String message,
      final String time,
      final Function onTap,
      final IconData icon}) {
    return MessageState(
      id: id ?? this.id,
      isSelected: isSelected ?? this.isSelected,
      message: message ?? this.message,
      time: time ?? this.time,
      onTap: onTap,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object> get props => [id, isSelected, message, time, onTap, time];

  @override
  String toString() {
    return 'MessageState{id: $id,isSelected: $isSelected, message: $message, time: $time,onTap: $onTap}';
  }
}
