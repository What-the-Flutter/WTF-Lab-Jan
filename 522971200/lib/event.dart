import 'package:flutter/material.dart';

class ChatEvent{
  String messageEvent;
  ChatEvent({@required this.messageEvent});
}

List<ChatEvent> messages = [
    ChatEvent(messageEvent: 'Do my homework'),
    ChatEvent(messageEvent: 'Do some other event.'),
  ];