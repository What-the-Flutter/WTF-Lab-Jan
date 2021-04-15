// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    id: json['id'] as int,
    typeId: json['typeId'] as int,
    message: json['message'] as String,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    favorite: json['favorite'] as int,
  );
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'typeId': instance.typeId,
      'message': instance.message,
      'date': instance.date?.toIso8601String(),
      'favorite': instance.favorite,
    };
