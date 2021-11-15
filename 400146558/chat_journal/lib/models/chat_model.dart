import 'package:chat_journal/models/message_model.dart';
import 'package:jiffy/jiffy.dart';

import 'chaticon_model.dart';

class Chat {
  int id;
  int chatIconId;
  String title;
  bool? isPinned;
  Jiffy? time;
  ChatIcon? chatIcon;
  List<Message> messageBase = [];

  Chat({
    required this.chatIconId,
    required this.time,
    required this.title,
    required this.isPinned,
    required this.id,
    required this.chatIcon,
    required this.messageBase,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatIconId': chatIconId,
      'title': title,
      'isPinned': isPinned! ? 1 : 0,
      'time': time!.dateTime.toString(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      chatIconId: map['chatIconId'],
      title: map['title'],
      isPinned: map['isPinned'] == 1 ? true : false,
      time: Jiffy(map['time']),
      messageBase: [],
      chatIcon: null,
    );
  }
}
