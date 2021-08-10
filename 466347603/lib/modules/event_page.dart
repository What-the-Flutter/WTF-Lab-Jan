import 'dart:io';

class Event {
  String? message;
  File? image;
  late bool isBookmarked;
  late String sendTime;

  Event({this.message, this.image}) {
    isBookmarked = false;
    var now = DateTime.now();
    sendTime = '${now.hour}:${now.minute}';
  }

  void updateSendTime() {
    var now = DateTime.now();
    sendTime = 'edited ${now.hour}:${now.minute}';
  }
}
