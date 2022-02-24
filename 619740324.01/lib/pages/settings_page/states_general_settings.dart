import 'package:equatable/equatable.dart';

class StatesGeneralSettings extends Equatable {
  final bool isDateTimeModification;
  final bool isBubbleAlignment;
  final bool isCenterDateBubble;

  StatesGeneralSettings({
    this.isDateTimeModification = false,
    this.isBubbleAlignment = false,
    this.isCenterDateBubble = false,
  });

  StatesGeneralSettings copyWith({
    final bool? isDateTimeModification,
    final bool? isBubbleAlignment,
    final bool? isCenterDateBubble,
  }) {
    return StatesGeneralSettings(
      isDateTimeModification:
          isDateTimeModification ?? this.isDateTimeModification,
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
    );
  }

  @override
  List<Object?> get props =>
      [isDateTimeModification, isBubbleAlignment, isCenterDateBubble];
}
