class Event {
  final String id;
  final String chatId;
  final String chatName;
  final String text;
  final String imagePath;
  final DateTime date;
  final bool isSelected;
  final bool isFavorite;
  final int categoryIndex;

  Event({
    required this.id,
    required this.chatId,
    required this.chatName,
    required this.text,
    required this.date,
    this.imagePath = '',
    this.isFavorite = false,
    this.isSelected = false,
    this.categoryIndex = 0,
  });

  Event copyWith({
    String? id,
    String? chatId,
    String? chatName,
    bool? isSelected,
    bool? isFavorite,
    String? text,
  }) {
    return Event(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      date: date,
      chatName: chatName ?? this.chatName,
      text: text ?? this.text,
      isFavorite: isFavorite ?? this.isFavorite,
      isSelected: isSelected ?? this.isSelected,
      imagePath: imagePath,
      categoryIndex: categoryIndex,
    );
  }

  factory Event.fromJson(Map<String, dynamic> map) => Event(
        id: map['id'],
        chatId: map['chat_id'],
        date: DateTime.parse(map['date']),
        chatName: map['chat_name'],
        text: map['text'],
        imagePath: map['image_path'],
        categoryIndex: map['category_index'],
        isFavorite: map['is_favorite'] == 1 ? true : false,
        isSelected: map['is_selected'] == 1 ? true : false,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'chat_name': chatName,
      'date': date.toString(),
      'text': text,
      'image_path': imagePath,
      'category_index': categoryIndex,
      'is_selected': isSelected ? 1 : 0,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }
}
