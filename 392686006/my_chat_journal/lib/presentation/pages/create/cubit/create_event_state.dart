part of 'create_event_cubit.dart';

class CreateEventState extends Equatable {
  final List<IconData> icons;
  final Event? editPage;
  late final IconData? currentIcon;

  CreateEventState({
    this.icons = const [],
    this.currentIcon,
    this.editPage,
  });

  CreateEventState copyWith({
    List<IconData>? icons,
    IconData? currentIcon,
    Event? editPage,
  }) {
    return CreateEventState(
      icons: icons ?? this.icons,
      currentIcon:currentIcon ?? this.currentIcon,
      editPage: editPage ?? this.editPage,
    );
  }

  @override
  List<Object> get props {
    return [
      if (editPage != null) {editPage},
      if (currentIcon != null) {currentIcon},
      icons,
    ];
  }
}

