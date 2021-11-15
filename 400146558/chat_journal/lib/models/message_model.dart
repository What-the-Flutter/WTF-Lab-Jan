import 'package:chat_journal/models/sectionicon_model.dart';
import 'package:jiffy/jiffy.dart';

class Message {
  late final int id;
  int chatId;
  String message;
  final Jiffy time;
  bool isFavourite;
  int? sectionIconId;
  SectionIcon? sectionIcon;

  Message({
    required this.message,
    required this.time,
    required this.isFavourite,
    required this.sectionIconId,
    required this.chatId,
    required this.id,
    required this.sectionIcon,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'message': message,
      'time': time.dateTime.toString(),
      'isFavourite': isFavourite ? 1 : 0,
      'sectionIconId': sectionIconId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      chatId: map['chatId'],
      message: map['message'],
      time: Jiffy(map['time']),
      isFavourite: map['isFavourite'] == 1 ? true : false,
      sectionIconId: map['sectionIconId'],
      sectionIcon: null,
    );
  }
}
