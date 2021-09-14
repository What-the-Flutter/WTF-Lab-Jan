class DbCategory {
  final int? id;
  final int color;
  final String? name;
  final String image;
  final int priority;
  final int isDefault;

  DbCategory({
    this.id,
    this.name,
    required this.color,
    required this.image,
    required this.priority,
    this.isDefault = 0
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'image': image,
      'priority': priority,
      'isDefault': isDefault,
    };
  }

  factory DbCategory.fromMap(Map<String, dynamic> map) {
    return DbCategory(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      image: map['image'],
      priority: map['priority'],
      isDefault: map['isDefault'],
    );
  }
}
