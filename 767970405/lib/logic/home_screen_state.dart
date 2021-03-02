part of 'home_screen_cubit.dart';

class HomeScreenInitial {
  final bool isEditPage;
  final bool isPin;
  final bool isEditMessages;

  HomeScreenInitial({this.isEditPage, this.isPin, this.isEditMessages});

  HomeScreenInitial copyWith({
    final bool isEditPage,
    final bool isPin,
    final bool isEditMessages,
}) {
    return HomeScreenInitial(
      isEditPage: isEditPage ?? this.isEditPage,
      isPin: isPin ?? this.isPin,
      isEditMessages: isEditMessages ?? this.isEditMessages,
    );
  }
}
