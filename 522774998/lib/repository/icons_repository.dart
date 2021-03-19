import 'package:flutter/material.dart';

class ListItemIcon {
  bool isSelected;
  IconData iconData;

  ListItemIcon(this.iconData, {this.isSelected = false});
}

final List<ListItemIcon> listIcon = <ListItemIcon>[
  ListItemIcon(Icons.fastfood),
  ListItemIcon(Icons.music_note),
  ListItemIcon(Icons.local_cafe),
  ListItemIcon(Icons.work),
  ListItemIcon(Icons.insert_emoticon),
  ListItemIcon(Icons.place),
  ListItemIcon(Icons.weekend),
  ListItemIcon(Icons.spa),
  ListItemIcon(Icons.local_movies),
  ListItemIcon(Icons.local_shipping),
  ListItemIcon(Icons.book_sharp),
  ListItemIcon(Icons.import_contacts_rounded),
  ListItemIcon(Icons.nature_people),
];
