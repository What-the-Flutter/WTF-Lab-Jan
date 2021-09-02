import 'package:flutter/material.dart';

class Category {
  final String title;
  final IconData icon;

  Category({
    this.icon = Icons.favorite,
    this.title = '',
  });
}

class Event {
  int? id;
  int pageId;
  int categoryId;
  String message;
  String imagePath;
  bool isBookmarked;
  String formattedSendTime;
  int sendTime;

  Event({
    this.id,
    this.message = '',
    this.imagePath = '',
    this.categoryId = 0,
    this.pageId = -1,
    this.isBookmarked = false,
    this.formattedSendTime = '',
    this.sendTime = 0,
  });

  Event copyWith({
    int? categoryId,
    String? formattedSendTime,
    String? imagePath,
    bool? isBookmarked,
    String? message,
    int? pageId,
    int? sendTime,
  }) {
    return Event(
      categoryId: categoryId ?? this.categoryId,
      formattedSendTime: formattedSendTime ?? this.formattedSendTime,
      imagePath: imagePath ?? this.imagePath,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      message: message ?? this.message,
      pageId: pageId ?? this.pageId,
      sendTime: sendTime ?? this.sendTime,
    );
  }

  int compareTo(Event other) {
    return sendTime < other.sendTime ? -1 : 1;
  }

  Map<String, dynamic> toMap() {
    return {
      'pageId': pageId,
      'message': message,
      'imagePath': imagePath,
      'formattedSendTime': formattedSendTime,
      'sendTime': sendTime,
      'isBookmarked': isBookmarked ? 1 : 0,
    };
  }

  void updateSendTime() {
    final now = DateTime.now();
    sendTime = now.microsecondsSinceEpoch;
    formattedSendTime = 'edited ${now.hour}:${now.minute}';
  }
}

class PageInfo {
  int? id;
  int iconIndex;
  String title;
  String lastMessage;
  String lastEditDate;
  String createDate;
  bool isPinned;
  Icon icon;
  List<Event> events;

  PageInfo({
    this.id,
    this.iconIndex = 0,
    this.title = '',
    this.icon = const Icon(
      Icons.favorite,
      color: Colors.white,
    ),
    this.lastMessage = 'No Events. Click to create one.',
    this.isPinned = false,
    this.createDate = '',
    this.lastEditDate = '',
    this.events = const <Event>[],
  });
  // })  : lastEditDate = '${DateTime.now().day}/${DateTime.now().month}'
  //           '/${DateTime.now().year} at ${DateTime.now().hour}:'
  //           '${DateTime.now().minute}',
  //       createDate = '${DateTime.now().day}/${DateTime.now().month}'
  //           '/${DateTime.now().year} at ${DateTime.now().hour}:'
  //           '${DateTime.now().minute}';

  PageInfo copyWith({
    int? id,
    int? iconIndex,
    String? title,
    String? lastMessage,
    String? lastEditDate,
    String? createDate,
    bool? isPinned,
    Icon? icon,
    List<Event>? events,
  }) {
    return PageInfo(
      id: id ?? this.id,
      iconIndex: iconIndex ?? this.iconIndex,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      lastEditDate: lastEditDate ?? this.lastEditDate,
      createDate: createDate ?? this.createDate,
      isPinned: isPinned ?? this.isPinned,
      icon: icon ?? this.icon,
      events: events ?? this.events,
    );
  }

  PageInfo.from(PageInfo page)
      : id = page.id,
        iconIndex = page.iconIndex,
        events = page.events,
        lastMessage = page.lastMessage,
        title = page.title,
        lastEditDate = page.lastEditDate,
        createDate = page.createDate,
        isPinned = page.isPinned,
        icon = page.icon;

  Map<String, dynamic> toMap() {
    return {
      'iconIndex': iconIndex,
      'title': title,
      'lastMessage': lastMessage,
      'lastEditDate': lastEditDate,
      'createDate': createDate,
      'isPinned': isPinned ? 1 : 0,
    };
  }

  List<Event> sortEvents() {
    events.sort((a, b) => a.compareTo(b));
    return events;
  }

  @override
  String toString() {
    return '{$title id: $id, iconIndex: $iconIndex, isPinned: $isPinned}';
  }
}
