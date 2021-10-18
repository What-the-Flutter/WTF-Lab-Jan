import 'package:flutter/material.dart';

import '../utils/data.dart';
import '../utils/decoder.dart';

class Category {
  final String title;
  final IconData icon;

  const Category({
    this.icon = Icons.favorite,
    this.title = '',
  });
}

class Event {
  int? id;
  int? pageId;
  int? categoryId;
  String? message;
  String? imageString;
  Image? image;
  Category? category;
  bool isBookmarked;
  bool isEdited;
  String? formattedSendTime;
  DateTime? sendTime;

  Event({
    this.id,
    this.pageId = -1,
    this.categoryId,
    this.message = '',
    this.category,
    this.image,
    this.imageString = '',
    this.isBookmarked = false,
    this.isEdited = false,
    this.sendTime,
    this.formattedSendTime,
  }) {
    sendTime ??= DateTime.now();
    var hour = '${sendTime!.hour}';
    hour = hour.length == 2 ? hour : '0$hour';
    var minute = '${sendTime!.minute}';
    minute = minute.length == 2 ? minute : '0$minute';
    formattedSendTime ??= '$hour:$minute';

    if (imageString != '') {
      image = Decoder.imageFromBase64String(imageString!);
    }

    if (categoryId != null && categoryId != -1) {
      category = initCategories[categoryId!];
    }

    if (isEdited) {
      formattedSendTime = 'edited $formattedSendTime';
    }
  }

  Event copyWith({
    int? id,
    Category? category,
    String? formattedSendTime,
    bool? isBookmarked,
    String? message,
    int? pageId,
    DateTime? sendTime,
  }) {
    return Event(
      id: id ?? this.id,
      category: category ?? this.category,
      formattedSendTime: formattedSendTime ?? this.formattedSendTime,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      message: message ?? this.message,
      pageId: pageId ?? this.pageId,
      sendTime: sendTime ?? this.sendTime,
    );
  }

  void updateSendTime() {
    sendTime ??= DateTime.now();
    var hour = '${sendTime!.hour.toString().padLeft(2, '0')}';
    // hour = hour.length == 2 ? hour : '0$hour';
    var minute = '${sendTime!.minute.toString().padLeft(2, '0')}';
    // minute = minute.length == 2 ? minute : '0$minute';
    formattedSendTime = 'edited $hour:$minute';
    isEdited = true;
  }

  Map<String, dynamic> toMap() {
    return {
      'pageId': pageId,
      'categoryId': category != null ? initCategories.indexOf(category!) : -1,
      'message': message,
      'imageString': imageString ?? '',
      'sendTime': sendTime.toString(),
      'isBookmarked': isBookmarked ? 1 : 0,
      'isEdited': isEdited ? 1 : 0,
    };
  }
}

class PageInfo {
  int? id;
  Icon? icon;
  String title;
  String lastMessage;
  String? lastEditDate;
  String? createDate;
  bool isPinned;
  List<Event> events = <Event>[];

  PageInfo({
    this.id,
    this.title = '',
    this.lastEditDate = '',
    this.lastMessage = 'No Events. Click to create one.',
    this.createDate,
    this.isPinned = false,
    this.events = const [],
    this.icon,
  }) {
    final now = DateTime.now();
    createDate ??= '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  PageInfo copyWith({
    int? id,
    String? title,
    String? lastMessage,
    bool? isPinned,
    Icon? icon,
    List<Event>? events,
  }) {
    return PageInfo(
      id: id ?? this.id,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      isPinned: isPinned ?? this.isPinned,
      icon: icon ?? this.icon,
      events: events ?? this.events,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'iconIndex': defaultIcons.indexOf(icon!.icon!),
      'title': title,
      'lastMessage': lastMessage,
      'lastEditDate': lastEditDate,
      'createDate': createDate,
      'isPinned': isPinned ? 1 : 0,
    };
  }

  PageInfo.from(PageInfo page)
      : events = page.events,
        lastMessage = page.lastMessage,
        title = page.title,
        lastEditDate = page.lastEditDate,
        createDate = page.createDate,
        isPinned = page.isPinned,
        icon = page.icon;
}
