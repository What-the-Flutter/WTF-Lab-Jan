import 'package:jiffy/jiffy.dart';

class Message {
  late final String? id;
  String message;
  final Jiffy time;
  bool isFavourite;
  String? sectionIconTitle;
  String? sectionName;
  String imagePath;

  Message({
    required this.message,
    required this.time,
    required this.isFavourite,
    required this.sectionIconTitle,
    required this.id,
    required this.sectionName,
    required this.imagePath,
  });

  Message.fromMap(String key, Map<dynamic, dynamic> map)
      : id = key,
        message = map['message'],
        time = Jiffy(map['time']),
        isFavourite = map['isFavourite'] == 1 ? true : false,
        sectionIconTitle = map['sectionIconTitle'],
        sectionName = map['sectionName'],
        imagePath = map['imagePath'];

  toJson() {
    return {
      'message': message,
      'time': time.dateTime.toString(),
      'isFavourite': isFavourite ? 1 : 0,
      'sectionIconTitle': sectionIconTitle,
      'sectionName': sectionName,
      'imagePath': imagePath,
    };
  }
}
