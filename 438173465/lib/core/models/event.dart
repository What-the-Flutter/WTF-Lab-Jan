import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  int id;
  int typeId;
  String message;
  DateTime date;
  int favorite;

  Event({
    this.id,
    this.typeId,
    this.message,
    this.date,
    this.favorite,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
