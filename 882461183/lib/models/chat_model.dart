// List<Chat> chatList = [
//   Chat(
//     icon: Icons.flight_takeoff,
//     elementName: 'Travel',
//     creationDate: DateTime.now(),
//     eventList: [],
//   ),
//   Chat(
//     icon: Icons.weekend,
//     elementName: 'Family',
//     creationDate: DateTime.now(),
//     eventList: [],
//   ),
//   Chat(
//     icon: Icons.fitness_center,
//     elementName: 'Sports',
//     creationDate: DateTime.now(),
//     eventList: [],
//   ),
// ];

class Chat {
  final String id;
  final String elementName;
  final String elementSubname;
  final int iconIndex;
  final DateTime creationDate;
  final bool isPinned;

  Chat({
    required this.id,
    required this.creationDate,
    required this.iconIndex,
    required this.elementName,
    this.isPinned = false,
    this.elementSubname = 'No events. Click to create one.',
  });

  Chat copyWith({
    String? id,
    int? iconIndex,
    String? elementName,
    String? elementSubname,
    bool? isPinned,
  }) {
    return Chat(
      id: id ?? this.id,
      iconIndex: iconIndex ?? this.iconIndex,
      creationDate: creationDate,
      elementName: elementName ?? this.elementName,
      elementSubname: elementSubname ?? this.elementSubname,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  factory Chat.fromJson(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      elementName: map['name'],
      elementSubname: map['subname'],
      iconIndex: map['icon_index'],
      creationDate: DateTime.parse(map['creation_date']),
      isPinned: map['is_pinned'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': elementName,
      'subname': elementSubname,
      'icon_index': iconIndex,
      'creation_date': creationDate.toString(),
      'is_pinned': isPinned ? 1 : 0,
    };
  }
}
