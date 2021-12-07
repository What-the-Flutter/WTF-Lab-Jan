import 'package:intl/intl.dart';

/// The element that is created on the event page
class EventElement {
  int? id;
  int eventId;
  int categoryId;
  String message;
  String imagePath;
  bool isBookmarked;
  int sendTime;
  String stringSendTime;

  EventElement({
    this.id,
    this.eventId = -1,
    this.categoryId = 0,
    this.message ='',
    this.imagePath ='',
    this.isBookmarked = false,
    this.stringSendTime = '',
    this.sendTime = 0,
  });

  EventElement copyWith({
    int? categoryId,
    String? stringSendTime,
    String? imagePath,
    bool? isBookmarked,
    String? message,
    int? eventId,
    int? sendTime,
  }) {
    return EventElement(
      categoryId: categoryId ?? this.categoryId,
      stringSendTime: stringSendTime ?? this.stringSendTime,
      imagePath: imagePath ?? this.imagePath,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      message: message ?? this.message,
      eventId: eventId ?? this.eventId,
      sendTime: sendTime ?? this.sendTime,
    );
  }

  void updateSendTime() {
    final dateNow = DateTime.now();
    sendTime = dateNow.millisecondsSinceEpoch;
    stringSendTime = 'edited ${DateFormat('hh:mm a').format(dateNow)}';
  }

  int compareTo(EventElement other) => sendTime < other.sendTime ? -1 : 1;

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'message': message,
      'imagePath': imagePath,
      'stringSendTime': stringSendTime,
      'sendTime': sendTime,
      'isBookmarked': isBookmarked ? 1 : 0,
    };
  }
}
