import 'package:json_annotation/json_annotation.dart';
import 'event.dart';

part'event_type.g.dart';

@JsonSerializable()
class EventType {
  final String icon;
  final String title;
  final List<Event> listEvents;

  EventType({this.title, this.listEvents, this.icon});

  factory EventType.fromJson(Map<String, dynamic> json) =>
      _$EventTypeFromJson(json);

  Map<String, dynamic> toJson() => _$EventTypeToJson(this);
}