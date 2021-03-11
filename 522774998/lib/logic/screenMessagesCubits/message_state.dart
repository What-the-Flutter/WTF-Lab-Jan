part of 'message_cubit.dart';

class MessageState extends Equatable {
  final bool isSelected;
  final IconData icon;
  final String message;
  final Function onTap;

  MessageState({
    this.message,
    this.isSelected,
    this.onTap,
    this.icon,
  });

  MessageState copyWith({
    final bool isSelected,
    final String message,
    final Function onTap,
    final IconData icon,
  }) {
    return MessageState(
      isSelected: isSelected ?? this.isSelected,
      message: message ?? this.message,
      onTap: onTap,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object> get props => [isSelected, message, onTap];

  @override
  String toString() {
    return 'MessageState{isSelected: $isSelected, message: $message, onTap: $onTap}';
  }
}
