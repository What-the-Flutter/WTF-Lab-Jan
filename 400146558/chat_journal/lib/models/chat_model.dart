import 'package:jiffy/jiffy.dart';

class Chat {
  String? id;
  String title;
  bool? isPinned;
  Jiffy? time;
  String? chatIconTitle;
  String? lastMessage;
  Jiffy? lastMessageTime;

  Chat({
    required this.time,
    required this.title,
    required this.isPinned,
    required this.id,
    required this.chatIconTitle,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  Chat.fromMap(String key, Map<dynamic, dynamic> map)
      : id = key,
        title = map['title'],
        isPinned = map['isPinned'] == 1 ? true : false,
        time = Jiffy(map['time']),
        chatIconTitle = map['iconTitle'],
        lastMessage = map['lastMessage'] == '' ? 'No events. Click to create one' : map['lastMessage'],
        lastMessageTime = map['lastMessageTime'] == '' ? null : Jiffy(map['lastMessageTime']);

  toJson() {
    return {
      'iconTitle': chatIconTitle,
      'title': title,
      'isPinned': isPinned! ? 1 : 0,
      'time': time!.dateTime.toString(),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime == null ? '' : lastMessageTime!.dateTime.toString(),
    };
  }
}
