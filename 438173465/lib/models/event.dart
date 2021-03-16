import 'package:json_annotation/json_annotation.dart';

part'event.g.dart';

@JsonSerializable()
class Event {
  final String message;
  final DateTime date;

  Event({this.message, this.date});

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
