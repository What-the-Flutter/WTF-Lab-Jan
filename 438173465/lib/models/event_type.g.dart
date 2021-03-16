// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventType _$EventTypeFromJson(Map<String, dynamic> json) {
  return EventType(
    title: json['title'] as String,
    listEvents: (json['listEvents'] as List)
        ?.map(
            (e) => e == null ? null : Event.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    icon: json['icon'] as String,
  );
}

Map<String, dynamic> _$EventTypeToJson(EventType instance) => <String, dynamic>{
      'icon': instance.icon,
      'title': instance.title,
      'listEvents': instance.listEvents,
    };
