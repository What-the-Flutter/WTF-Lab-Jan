import 'package:flutter/material.dart';

final String pagesTable = 'pages';

class PagesFields {
  static final String columnId = '_id';
  static final String isPinned = 'isPinned';
  static final String title = 'title';
  static final String lastEditDate = 'lastEditDate';
  static final String createDate = 'createDate';
  static final String lastMessage = 'lastMessage';
}

class PageCategory {
  String title;
  List<Note> note;
  int iconIndex;

  PageCategory({
    required this.title,
    required this.iconIndex,
    required this.note,
  });
}

class PageCategoryInfo {
  int? id;
  String title;
  List<Note> note = <Note>[];
  IconData icon;
  bool isPinned;
  String lastEditDate;
  String createDate;
  String lastMessage;

  PageCategoryInfo({
    required this.title,
    required this.icon,
    this.id,})
      : lastMessage = 'Entry event',
        isPinned = false,
        lastEditDate = '${DateTime.now().day}/${DateTime.now().month}''/${DateTime.now().year}'
            ' at ${DateTime.now().hour}:''${DateTime.now().minute}',
        createDate = '${DateTime.now().day}/${DateTime.now().month}''/${DateTime.now().year}'
            ' at ${DateTime.now().hour}:''${DateTime.now().minute}';

  PageCategoryInfo copyWith({
    int? id,
    String? title,
    List<Note>? note,
    IconData? icon,
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
        note = page.note,
        id = page.id,
        isPinned = page.isPinned,
        createDate = page.createDate,
        lastEditDate = page.lastEditDate,
        lastMessage = page.lastMessage;

  Map<String, Object?> toJson() =>
      {
        // PagesFields.columnId
        PagesFields.lastEditDate: lastEditDate,
        PagesFields.lastMessage: lastMessage,
        PagesFields.createDate: createDate,
        PagesFields.isPinned: isPinned ? 1 : 0,
        PagesFields.title: title,
      };

  List<Note> sortEvents() {
    note.sort((a, b) => a.compareTo(b));
    return note;
  }

}

class Note {
  DateTime time;
  bool isBookmarked;
  String? description;
  EventCategory category;
  String formattedTime;

  // File? image;
  String? image;

  Note({this.image, this.description})
      : isBookmarked = false,
        category = const EventCategory(icon: null, title: ''),
        time = DateTime.now(),
        formattedTime = '${DateTime
            .now()
            .hour}:${DateTime
            .now()
            .minute}';

  int compareTo(Note other) {
    return time.isAfter(other.time) ? -1 : 1;
  }

  void updateSendTime() {
    final now = DateTime.now();
    time = now;
    formattedTime = 'edited ${now.hour}:${now.minute}';
  }
}

class EventCategory {
  final String title;
  final IconData? icon;

  const EventCategory({
    required this.icon,
    required this.title,
  });
}
