import 'dart:io';

import 'package:intl/intl.dart';

class Event {
  String? message;
  File? image;
  bool isBookmarked;
  String sendTime;

  Event({
    this.message,
    this.image,
    this.isBookmarked = false,
    this.sendTime = '',
  }) {
    sendTime = '${DateFormat('hh:mm a').format(DateTime.now())}';
  }

  void updateSendTime(){
    sendTime = 'edited ${DateFormat('hh:mm a').format(DateTime.now())}';
  }
}
