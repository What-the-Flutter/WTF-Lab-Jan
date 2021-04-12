part of 'chat_interface_setting_cubit.dart';

class ChatInterfaceSettingState extends Equatable {
  final bool isDateTimeModification;
  final bool isLeftBubbleAlign;
  final bool isCenterDateBubble;
  final bool isAuthentication;

  final String pathBackgroundImage;

  ChatInterfaceSettingState({
    this.isDateTimeModification = false,
    this.isLeftBubbleAlign = false,
    this.isCenterDateBubble = false,
    this.isAuthentication = true,
    this.pathBackgroundImage = '',
  });

  ChatInterfaceSettingState copyWith({
    final bool isDateTimeModification,
    final bool isLeftBubbleAlign,
    final bool isCenterDateBubble,
    final bool isAuthentication,
    final String pathBackgroundImage,
  }) {
    return ChatInterfaceSettingState(
      isDateTimeModification:
          isDateTimeModification ?? this.isDateTimeModification,
      isLeftBubbleAlign: isLeftBubbleAlign ?? this.isLeftBubbleAlign,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
      isAuthentication: isAuthentication ?? this.isAuthentication,
      pathBackgroundImage: pathBackgroundImage ?? this.pathBackgroundImage,
    );
  }

  @override
  List<Object> get props => [
        isDateTimeModification,
        isLeftBubbleAlign,
        isCenterDateBubble,
        isAuthentication,
        pathBackgroundImage,
      ];
}
