class ActivityPage {
  final String id;
  final String name;
  final int iconIndex;
  final String creationDate;
  final bool isPinned;

  ActivityPage({
    required this.id,
    required this.name,
    required this.iconIndex,
    required this.creationDate,
    required this.isPinned,
  });

  ActivityPage copyWith({
    String? id,
    String? name,
    int? iconIndex,
    String? creationDate,
    bool? isPinned,
  }) {
    return ActivityPage(
      id: id ?? this.id,
      name: name ?? this.name,
      iconIndex: iconIndex ?? this.iconIndex,
      creationDate: creationDate ?? this.creationDate,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  factory ActivityPage.fromMap(Map<String, dynamic> map) {
    return ActivityPage(
      id: map['id'],
      name: map['name'],
      iconIndex: map['icon_index'],
      creationDate: map['creation_date'],
      isPinned: map['is_pinned'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon_index': iconIndex,
      'creation_date': creationDate,
      'is_pinned': isPinned ? 1 : 0,
    };
  }
}
