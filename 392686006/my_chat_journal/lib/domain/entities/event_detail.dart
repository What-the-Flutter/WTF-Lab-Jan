import 'dart:io';

import 'package:intl/intl.dart';
import 'category.dart';

/// The element that is created on the event page
class EventElement {
  String? message;
  File? image;
  bool isBookmarked;
  DateTime sendTime;
  String stringSendTime;
  Category? category;

  EventElement({
    this.category,
    this.message,
    this.image,
    this.isBookmarked = false,
  })  : sendTime = DateTime.now(),
        stringSendTime = '${DateFormat('hh:mm a').format(DateTime.now())}';

  void updateSendTime() {
    stringSendTime = 'edited ${DateFormat('hh:mm a').format(DateTime.now())}';
  }

  int compareTo(EventElement other) {
    return sendTime.isAfter(other.sendTime) ? -1 : 1;
  }
}
