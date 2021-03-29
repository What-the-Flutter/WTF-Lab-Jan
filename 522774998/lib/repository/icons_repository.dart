import 'package:flutter/material.dart';

class ListItemIcon {
  bool isSelected;
  IconData iconData;

  ListItemIcon({
    this.iconData,
    this.isSelected = false,
  });

  @override
  String toString() {
    return 'LabelModel{icon: $iconData, isVisible: $isSelected}';
  }

  ListItemIcon copyWith({
    final IconData iconData,
    final bool isSelected,
  }) {
    return ListItemIcon(
      iconData: iconData ?? this.iconData,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class IconsRepository {
  final List<ListItemIcon> listIcon = <ListItemIcon>[
    ListItemIcon(iconData: Icons.fastfood),
    ListItemIcon(iconData: Icons.music_note),
    ListItemIcon(iconData: Icons.local_cafe),
    ListItemIcon(iconData: Icons.work),
    ListItemIcon(iconData: Icons.insert_emoticon),
    ListItemIcon(iconData: Icons.place),
    ListItemIcon(iconData: Icons.weekend),
    ListItemIcon(iconData: Icons.spa),
    ListItemIcon(iconData: Icons.local_movies),
    ListItemIcon(iconData: Icons.local_shipping),
    ListItemIcon(iconData: Icons.book_sharp),
    ListItemIcon(iconData: Icons.import_contacts_rounded),
    ListItemIcon(iconData: Icons.nature_people),
  ];
}
