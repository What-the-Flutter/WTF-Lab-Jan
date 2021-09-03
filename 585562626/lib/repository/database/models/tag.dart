class DbTag {
  final int? id;
  final String name;

  DbTag({this.id, required this.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  factory DbTag.fromMap(Map<String, dynamic> map) => DbTag(id: map['id'], name: map['name']);
}
