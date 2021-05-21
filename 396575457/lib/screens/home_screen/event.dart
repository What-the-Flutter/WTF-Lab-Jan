import 'package:flutter/material.dart';

import '../create_event_screen/messages_store.dart';

class Event {
  String title;
  CircleAvatar avatar;
  EventsStore messages;

  Event({this.title, this.avatar, this.messages});

  String get titleString {
    return title;
  }

  EventsStore get messagesData {
    return messages;
  }

  CircleAvatar get circleAvatar {
    return avatar;
  }
}
