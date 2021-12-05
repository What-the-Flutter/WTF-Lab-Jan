part of 'create_event_cubit.dart';

class CreateEventState extends Equatable {
  final List<IconData> icons;
  final Event? editPage;
  late final IconData? currentIcon;
  final bool flag;

  CreateEventState({
    this.icons = const [],
    this.currentIcon,
    this.editPage,
    this.flag = false,
  });

  CreateEventState copyWith({
    List<IconData>? icons,
    IconData? currentIcon,
    Event? editPage,
    bool? flag,
  }) {
    return CreateEventState(
      icons: icons ?? this.icons,
      currentIcon: currentIcon ?? this.currentIcon,
      editPage: editPage ?? this.editPage,
      flag: flag ?? this.flag,
    );
  }

  @override
  List<Object?> get props {
    return [
      editPage,
      currentIcon,
      icons,
      flag,
    ];
  }
}
