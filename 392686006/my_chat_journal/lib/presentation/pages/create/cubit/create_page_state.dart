part of 'create_page_cubit.dart';

class CreatePageState extends Equatable {
  final List<IconData> icons;
  final EventInfo? editPage;
  late final IconData? currentIcon;

  CreatePageState({
    this.icons = const [],
    this.currentIcon,
    this.editPage,
  });

  CreatePageState copyWith({
    List<IconData>? icons,
    IconData? selectedIcon,
    EventInfo? editPage,
  }) {
    return CreatePageState(
      icons: icons ?? this.icons,
      currentIcon:selectedIcon ?? this.currentIcon,
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

