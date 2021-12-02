import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The element that is created on the home page
class EventInfo {
  String title;
  String createDate;
  String lastEditDate;
  String lastMessage;
  bool isPinned;
  Icon icon;



  EventInfo({
    required this.title,
    required this.icon,
    this.isPinned = false,
    this.lastMessage = 'No Events. Click to create one.',
    this.createDate = '',
    this.lastEditDate = '',
  }){
    createDate = lastEditDate = '${DateFormat('yyyyy.MMMMM.dd GGG hh:mm aaa').format(DateTime.now())}';
  }
}
