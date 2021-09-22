import 'package:flutter/material.dart';

final String pagesTable = 'pages';
final String eventsTable = 'events';

class PagesFields {
  static final String id = '_id';
  static final String icon = 'icon';
  static final String title = 'title';
  static final String isPinned = 'isPinned';
  static final String lastEditDate = 'lastEditDate';
  static final String createDate = 'createDate';
  static final String lastMessage = 'lastMessage';

  static final List<String> values = [
    id,
    title,
    icon,
    isPinned,
    lastEditDate,
    createDate,
    lastMessage,
  ];
}

class PageCategoryInfo {
  int? id;
  String title;
  int icon;
  bool isPinned;
  String lastEditDate;
  String createDate;
  String lastMessage;

  PageCategoryInfo({
    required this.title,
    required this.icon,
    this.id,
  })  : lastMessage = 'Entry event',
        isPinned = false,
        lastEditDate = '${DateTime.now().day}/${DateTime.now().month}'
            '/${DateTime.now().year}'
            ' at ${DateTime.now().hour}:'
            '${DateTime.now().minute}',
        createDate = '${DateTime.now().day}/${DateTime.now().month}'
            '/${DateTime.now().year}'
            ' at ${DateTime.now().hour}:'
            '${DateTime.now().minute}';

  PageCategoryInfo copyWith({
    int? id,
    int? icon,
    String? title,
    bool? isPinned,
    String? lastEditDate,
    String? createDate,
    String? lastMessage,
  }) =>
      PageCategoryInfo(
        id: id ?? this.id,
        title: title ?? this.title,
        icon: icon ?? this.icon,
      );

  PageCategoryInfo.from(PageCategoryInfo page)
      : title = page.title,
        icon = page.icon,
        id = page.id,
        isPinned = page.isPinned,
        createDate = page.createDate,
        lastEditDate = page.lastEditDate,
        lastMessage = page.lastMessage;

  static PageCategoryInfo fromJson(Map<String, Object?> json) =>
      PageCategoryInfo(
        id: json[PagesFields.id] as int?,
        title: json[PagesFields.title] as String,
        icon: json[PagesFields.icon] as int,
      );

  Map<String, Object?> toJson() => {
        PagesFields.id: id,
        PagesFields.icon: icon,
        PagesFields.title: title,
        PagesFields.lastEditDate: lastEditDate,
        PagesFields.lastMessage: lastMessage,
        PagesFields.createDate: createDate,
        PagesFields.isPinned: isPinned ? 1 : 0,
      };

// List<Note> sortEvents() {
//   note.sort((a, b) => a.compareTo(b));
//   return note;
// }
}

class EventsFields {
  static final String id = '_id';
  static final String tableId = 'tableId';
  static final String description = 'description';
  static final String category = 'category';
  static final String time = 'time';
  static final String formattedTime = 'formattedTime';
  static final String isBookmarked = 'isBookMarked';
  static final String image = 'image';

  static final List<String> values = [
    id,
    tableId,
    category,
    description,
    time,
    formattedTime,
    isBookmarked,
    image,
  ];
}

class Note {
  int? id;
  int? tableId;
  bool isBookmarked;
  String? description;
  int category;
  String formattedTime;
  DateTime time;
  String? image;

  Note({
    this.id,
    this.tableId,
    this.image,
    this.description,
    required this.category,
    required this.isBookmarked,
    required this.time,
    required this.formattedTime,
  });

  Map<String, Object?> toJson() => {
        EventsFields.id: id,
        EventsFields.tableId: tableId,
        EventsFields.description: description,
        EventsFields.category: category,
        EventsFields.time: time.toIso8601String(),
        EventsFields.formattedTime: formattedTime,
        EventsFields.isBookmarked: isBookmarked ? 1 : 0,
        EventsFields.image: image,
      };

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[EventsFields.id] as int?,
        tableId: json[EventsFields.tableId] as int,
        description: json[EventsFields.description] as String,
        category: json[EventsFields.category] as int,
        time: DateTime.parse(json[EventsFields.time] as String),
        formattedTime: json[EventsFields.formattedTime] as String,
        isBookmarked: json[EventsFields.isBookmarked] == 1 ? true : false,
        image: json[EventsFields.image] as String?,
      );

  Note copyWith({
    int? id,
    int? tableId,
    int? category,
    String? description,
    DateTime? time,
    bool? isBookmarked,
    String? formattedTime,
    String? image,
  }) =>
      Note(
        id: id ?? id,
        tableId: tableId ?? tableId,
        category: category ?? this.category,
        description: description ?? this.description,
        time: time ?? this.time,
        formattedTime: formattedTime ?? this.formattedTime,
        isBookmarked: isBookmarked ?? this.isBookmarked,
        image: image ?? image,
      );

  int compareTo(Note other) {
    return time.isAfter(other.time) ? -1 : 1;
  }

  void updateSendTime() {
    final now = DateTime.now();
    formattedTime = 'edited ${now.hour}:${now.minute}';
  }
}

