import 'dart:io';

import 'package:intl/intl.dart';
import 'category.dart';

/// The element that is created on the event page
class EventDetail {
  String? message;
  File? image;
  bool isBookmarked;
  DateTime sendTime;
  String stringSendTime;
  Category? category;

  EventDetail({
    this.category,
    this.message,
    this.image,
    this.isBookmarked = false,
  })  : sendTime = DateTime.now(),
        stringSendTime = '${DateFormat('hh:mm a').format(DateTime.now())}';

  void updateSendTime() {
    stringSendTime = 'edited ${DateFormat('hh:mm a').format(DateTime.now())}';
  }

  int compareTo(EventDetail other) {
    return sendTime.isAfter(other.sendTime) ? -1 : 1;
  }
}
