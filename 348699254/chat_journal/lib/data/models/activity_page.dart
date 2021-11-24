import 'package:flutter/cupertino.dart';

class ActivityPage {
  int id;
  String name;
  IconData icon;
  String creationDate;
  bool isPinned;

  ActivityPage({
    required this.id,
    required this.name,
    required this.icon,
    required this.creationDate,
    required this.isPinned,
  });

  ActivityPage copyWith({
    int? id,
    String? name,
    IconData? icon,
    String? creationDate,
    bool? isPinned,
  }) =>
      ActivityPage(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        creationDate: creationDate ?? this.creationDate,
        isPinned: isPinned ?? this.isPinned,
      );
}
