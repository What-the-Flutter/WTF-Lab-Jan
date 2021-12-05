part of 'create_event_cubit.dart';

class CreateEventState extends Equatable {
  final List<IconData> icons;
  final Event? editEvent;
  late final IconData? currentIcon;
  final bool isContinue;

  CreateEventState({
    this.icons = const [],
    this.currentIcon,
    this.editEvent,
    this.isContinue = false,
  });

  CreateEventState copyWith({
    List<IconData>? icons,
    IconData? currentIcon,
    Event? editEvent,
    bool? isContinue,
  }) {
    return CreateEventState(
      icons: icons ?? this.icons,
      currentIcon: currentIcon ?? this.currentIcon,
      editEvent: editEvent ?? this.editEvent,
      isContinue: isContinue ?? this.isContinue,
    );
  }

  @override
  List<Object?> get props {
    return [editEvent, currentIcon, icons, isContinue];
  }
}
