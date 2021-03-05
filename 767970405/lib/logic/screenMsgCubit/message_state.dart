part of 'message_cubit.dart';

class MessageState extends Equatable {
  final bool isFavor;
  final bool isSelected;
  final String message;
  final Function onTap;

  MessageState({
    this.message,
    this.isFavor,
    this.isSelected,
    this.onTap,
  });

  MessageState copyWith({
    final bool isFavor,
    final bool isSelected,
    final String message,
    final Function onTap,
  }) {
    return MessageState(
      isFavor: isFavor ?? this.isFavor,
      isSelected: isSelected ?? this.isSelected,
      message: message ?? this.message,
      onTap: onTap,
    );
  }

  @override
  List<Object> get props => [isFavor, isSelected, message, onTap];

  @override
  String toString() {
    return 'MessageState{isSelected: $isSelected, message: $message, onTap: $onTap}';
  }
}
