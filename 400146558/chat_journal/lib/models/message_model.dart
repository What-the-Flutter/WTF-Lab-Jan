import 'package:jiffy/jiffy.dart';

class Message {
  String message;
  final Jiffy time;
  bool isFavourite;
  bool isSelected;

  Message(this.message, this.time, this.isFavourite, this.isSelected);
}

List<Message> travel = [
  Message(
      "buy bread",
      Jiffy({"year": 2021, "month": 9, "day": 20, "hour": 14, "minutes": 45}),
      false, false),
  Message(
      "go to work",
      Jiffy({"year": 2021, "month": 9, "day": 20, "hour": 14, "minutes": 50}),
      false, false),
  Message(
      "go to work",
      Jiffy({"year": 2021, "month": 9, "day": 20, "hour": 14, "minutes": 53}),
      false, false),
  Message(
      "write a letter",
      Jiffy({"year": 2021, "month": 10, "day": 18, "hour": 10, "minutes": 45}),
      false, false),
  Message(
      "cook a dinner",
      Jiffy({"year": 2021, "month": 10, "day": 18, "hour": 11, "minutes": 45}),
      false, false),
  Message(
      "drink a water",
      Jiffy({"year": 2021, "month": 10, "day": 18, "hour": 11, "minutes": 45}),
      false, false),
];
